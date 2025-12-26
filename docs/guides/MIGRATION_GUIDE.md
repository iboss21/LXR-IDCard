# 🔄 Migration Guide - Roadmap Features Update

This guide helps existing users of The Land of Wolves ID Card System migrate to the new version with all 6 roadmap features implemented.

---

## 📋 What's New

This update adds:
- **Phase 1**: Camera integration for real mugshots
- **Phase 2**: ID inspection by nearby players
- **Phase 3**: Lost/stolen ID replacement system
- **Phase 4**: Citizenship expiration and renewal
- **Phase 5**: Multiple citizenship tiers (Basic, Premium, Elite)
- **Phase 6**: Admin statistics dashboard

---

## 🔧 Migration Steps

### Step 1: Backup Your Data

**IMPORTANT**: Always backup before updating!

```sql
-- Backup your existing data
CREATE TABLE tlw_id_applications_backup AS SELECT * FROM tlw_id_applications;
```

### Step 2: Update Files

Replace the following files with the new versions:
- `config.lua` - Contains new configuration options
- `server/main.lua` - Contains new server logic
- `client/main.lua` - Contains new client functionality
- `html/index.html` - Contains new UI elements
- `html/script.js` - Contains new UI logic
- `html/style.css` - Contains new styles

### Step 3: Database Migration

The new system will automatically create the new tables and columns when the server starts. However, you may want to manually add columns to existing data:

```sql
-- Add new columns to existing table
ALTER TABLE tlw_id_applications 
ADD COLUMN tier VARCHAR(20) DEFAULT 'Basic',
ADD COLUMN expiration_date DATETIME;

-- Update existing records with expiration dates (30 days from now)
UPDATE tlw_id_applications 
SET expiration_date = DATE_ADD(NOW(), INTERVAL 30 DAY)
WHERE status = 'approved' AND expiration_date IS NULL;

-- Verify new tables are created (automatic on server start)
SHOW TABLES LIKE 'tlw_id_%';
```

### Step 4: Update Configuration

Review and customize the new configuration options in `config.lua`:

#### Phase 1: Camera Settings
```lua
Config.Camera = {
    enabled = true, -- Enable/disable camera feature
    fov = 30.0, -- Adjust camera zoom
    offsetForward = 0.5, -- Camera distance
    offsetUp = 0.6, -- Camera height
    duration = 5000, -- Photo duration (ms)
    useWebcam = false, -- Future: actual webcam
    storeAsBase64 = true -- Store photo data
}
```

#### Phase 2: Inspection Settings
```lua
Config.Inspection = {
    enabled = true, -- Enable/disable inspection
    maxDistance = 3.0, -- Max distance for inspection
    requireIDInHand = true, -- Must be showing ID
    allowDenial = true -- Can deny inspection
}
```

#### Phase 3: Replacement Settings
```lua
Config.Replacement = {
    enabled = true,
    fee = 150.0, -- Cost to replace ID
    cooldown = 86400, -- 24 hours in seconds
    trackInDatabase = true,
    maxReplacements = 5 -- Max replacements allowed
}
```

#### Phase 4: Expiration Settings
```lua
Config.Expiration = {
    enabled = true,
    duration = 2592000, -- 30 days in seconds
    renewalFee = 75.0,
    warningDays = 7, -- Warn X days before expiration
    allowExpiredUse = false -- Can show expired IDs
}
```

#### Phase 5: Tier Settings
```lua
Config.Tiers = {
    enabled = true,
    allowUpgrade = true,
    upgradeRefund = true -- 50% refund on upgrade
}
```

You can customize tier prices, benefits, colors, and badges in the `Config.Tiers.tiers` table.

#### Phase 6: Statistics Settings
```lua
Config.Statistics = {
    enabled = true,
    adminCommand = 'idstats', -- Command to view stats
    trackMetrics = {
        applications = true,
        approvals = true,
        denials = true,
        replacements = true,
        renewals = true,
        tierDistribution = true,
        averageProcessingTime = true
    }
}
```

### Step 5: Update Locale Strings

New locale strings have been added. Review them in `config.lua`:
- Camera messages
- Inspection messages
- Replacement messages
- Expiration/renewal messages
- Tier messages

Customize these to match your server's theme.

### Step 6: Test the Installation

1. Start your server
2. Check console for successful database initialization
3. Test each new feature:
   - Take a photo at photographer
   - Inspect another player's ID
   - Replace an ID at government office
   - Check expiration notifications
   - Upgrade citizenship tier
   - View statistics as admin (`/idstats`)

---

## 🔄 Updating Existing IDs

Existing player IDs will continue to work but won't have the new features until updated. Here are your options:

### Option 1: Automatic Migration (Recommended)

Add a one-time migration script in `server/main.lua`:

```lua
-- One-time migration for existing IDs
RegisterCommand('migrateids', function(source, args)
    if source ~= 0 then return end -- Console only
    
    print('[TLW-IDCard] Starting migration of existing IDs...')
    
    -- Update all approved IDs with expiration and tier
    MySQL.query([[
        UPDATE tlw_id_applications 
        SET tier = 'Basic',
            expiration_date = DATE_ADD(timestamp, INTERVAL 30 DAY)
        WHERE status = 'approved' 
        AND (tier IS NULL OR expiration_date IS NULL)
    ]], {}, function(result)
        print('[TLW-IDCard] Migration complete! Updated ' .. result.affectedRows .. ' records.')
    end)
end, false)
```

Run from server console: `migrateids`

### Option 2: Manual Player Update

Players can:
1. Use the ID replacement system to get a new ID with all features
2. OR renew their ID to update it

### Option 3: Force Re-application

For a fresh start, you could:
1. Announce an "ID update period"
2. Remove all existing IDs
3. Have players re-apply with new tier system

---

## 🎮 Player Communication

Inform your players about the new features:

### Announcement Template

```
🐺 THE LAND OF WOLVES - ID SYSTEM UPDATE 🐺

We've enhanced our citizenship system with exciting new features!

NEW FEATURES:
📸 Real mugshot photos on your ID
👥 Inspect other players' IDs
🔄 Replace lost or stolen IDs ($150, 24hr cooldown)
📅 IDs now expire after 30 days (renew for $75)
⭐ Three citizenship tiers with unique benefits:
   • Basic - $50 (Standard rights)
   • Premium - $150 (Priority + 10% discounts)
   • Elite - $500 (VIP + 25% discounts + exclusive access)

EXISTING CITIZENS:
- Your current ID will continue to work
- Visit the government office to upgrade to a tier
- IDs will expire 30 days after issuance
- You can upgrade your tier anytime!

NEW APPLICANTS:
- Choose your tier when applying
- Get your mugshot at the photographer first

Questions? Contact staff!
```

---

## ⚙️ Advanced Configuration

### Disabling Specific Features

Don't want certain features? Disable them:

```lua
-- Disable camera (use placeholder photos)
Config.Camera.enabled = false

-- Disable ID inspection
Config.Inspection.enabled = false

-- Disable replacement system
Config.Replacement.enabled = false

-- Disable expiration
Config.Expiration.enabled = false

-- Disable tier system (everyone gets Basic)
Config.Tiers.enabled = false

-- Disable statistics
Config.Statistics.enabled = false
```

### Adjusting Fees

Customize fees to match your server's economy:

```lua
Config.PhotoFee = 20.0
Config.ApplicationFee = 50.0
Config.Replacement.fee = 150.0
Config.Expiration.renewalFee = 75.0

-- Tier prices
Config.Tiers.tiers[1].price = 50.0  -- Basic
Config.Tiers.tiers[2].price = 150.0 -- Premium
Config.Tiers.tiers[3].price = 500.0 -- Elite
```

### Adjusting Timers

Customize cooldowns and durations:

```lua
-- Cooldowns (in seconds)
Config.Cooldowns.photo = 60           -- 1 minute
Config.Cooldowns.application = 300    -- 5 minutes
Config.Cooldowns.replacement = 86400  -- 24 hours

-- Expiration
Config.Expiration.duration = 2592000  -- 30 days
Config.Expiration.warningDays = 7     -- Warn 7 days before
```

### Custom Tier Benefits

Add custom benefits for each tier:

```lua
Config.Tiers.tiers = {
    {
        name = 'Basic',
        label = 'Basic Citizenship',
        price = 50.0,
        benefits = {
            'Access to public services',
            'Basic territorial rights',
            'Standard voting rights'
        },
        color = '#8b6f47',
        badge = '📋'
    },
    -- Add more tiers or customize existing ones
}
```

---

## 🔍 Verification Checklist

After migration, verify:

- [ ] All database tables exist (`tlw_id_applications`, `tlw_id_replacements`, `tlw_id_renewals`, `tlw_id_statistics`)
- [ ] New columns added to main table (`tier`, `expiration_date`)
- [ ] Camera system works when taking photos
- [ ] Existing IDs still display correctly
- [ ] New IDs include all new features
- [ ] Inspection system works between players
- [ ] Replacement system enforces cooldowns
- [ ] Expiration warnings display correctly
- [ ] Tier badges show on ID cards
- [ ] Tier upgrade system works
- [ ] Statistics dashboard displays data (`/idstats`)
- [ ] All Discord webhooks still work
- [ ] No console errors

---

## 🐛 Common Issues & Solutions

### Issue: Database columns not added
**Solution**: Run the migration query manually (see Step 3)

### Issue: Camera not working
**Solution**: 
- Check `Config.Camera.enabled = true`
- Verify RedM native compatibility
- Check console for camera errors

### Issue: IDs don't show tier badge
**Solution**:
- Ensure `Config.Tiers.enabled = true`
- Verify tier was set during application
- Check ID metadata includes `tier` field

### Issue: Statistics show zero
**Solution**:
- Statistics only track NEW actions after update
- Old data won't be included
- Use `/idstats` to verify tracking

### Issue: Expiration not working
**Solution**:
- Run migration to add expiration dates to old IDs
- Ensure `Config.Expiration.enabled = true`
- Check server console for calculation errors

### Issue: Replacement fee too high/low
**Solution**: Adjust `Config.Replacement.fee` in config.lua

### Issue: Players can't inspect IDs
**Solution**:
- Check `Config.Inspection.enabled = true`
- Verify ox_target is working
- Ensure players are within max distance

---

## 📞 Support

If you encounter issues during migration:

1. Check the console for error messages
2. Verify all files were updated correctly
3. Review the configuration settings
4. Test with a fresh character
5. Check the GitHub issues page
6. Ask in the discussions section

---

## 🎉 Post-Migration

After successful migration:

1. Announce new features to your community
2. Update your server rules if needed
3. Train staff on new admin commands
4. Monitor statistics for system usage
5. Gather player feedback
6. Adjust configurations based on needs

---

## 📊 Monitoring

Keep an eye on:
- Number of applications per day
- Approval/denial rates
- Tier distribution (are tiers balanced?)
- Replacement frequency (is fee too low?)
- Renewal rates (is duration appropriate?)

Use `/idstats` regularly to monitor these metrics!

---

## 🚀 Next Steps

Consider integrating tier benefits with other systems:
- Give Premium/Elite players priority in queues
- Provide tier-based discounts in shops
- Grant tier-specific spawn locations
- Create tier-exclusive areas
- Add tier-based job bonuses

---

**Migration Status**: ✅ READY

This guide covers everything needed to successfully migrate from the base system to the full roadmap implementation. Take your time, backup your data, and test thoroughly!
