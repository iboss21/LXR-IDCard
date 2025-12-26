# 🗺️ Roadmap Implementation Guide

This document details the implementation of all 6 phases from the roadmap for The Land of Wolves ID Card System.

---

## ✅ Phase 1: Camera Script Integration for Real Mugshots

### What Was Implemented

**Configuration** (`config.lua`):
```lua
Config.Camera = {
    enabled = true,
    fov = 30.0,
    offsetForward = 0.5,
    offsetUp = 0.6,
    duration = 5000,
    useWebcam = false,
    storeAsBase64 = true
}
```

**Features**:
- Camera script that creates a 3D camera view in front of the player
- 5-second duration for photo capture with proper framing
- Photo data stored in item metadata
- Mugshot display on ID card (placeholder or actual photo)
- Seamless integration with photographer interaction

**How It Works**:
1. Player interacts with photographer via ox_target
2. Camera is created in front of player's face
3. Photo is captured after 5 seconds
4. Photo data is stored as metadata in photo_plate item
5. When ID is created, photo data is transferred to the ID card
6. ID card UI displays the mugshot image if available

**UI Updates**:
- Added `<img>` element for actual photos
- Placeholder shown when no photo data exists
- Smooth transition between placeholder and photo

---

## ✅ Phase 2: ID Inspection by Nearby Players

### What Was Implemented

**Configuration** (`config.lua`):
```lua
Config.Inspection = {
    enabled = true,
    maxDistance = 3.0,
    requireIDInHand = true,
    allowDenial = true
}
```

**Features**:
- ox_target global player interaction for ID inspection
- Distance-based permission checking (3.0 units max)
- Request/approval system with UI dialogs
- Same ID card UI displayed for inspections
- Ability for target player to deny inspection requests

**Server Events**:
- `tlw_idcard:server:requestInspection` - Send inspection request
- `tlw_idcard:server:acceptInspection` - Accept and show ID
- `tlw_idcard:server:denyInspection` - Deny inspection

**Client Events**:
- `tlw_idcard:client:receiveInspectionRequest` - Receive request dialog
- `tlw_idcard:client:showInspectionResult` - Display other player's ID

**How It Works**:
1. Player A targets Player B and selects "Inspect ID Card"
2. Request is sent to Player B with ox_lib alert dialog
3. Player B can Accept or Deny the request
4. If accepted, Player A sees Player B's ID card with all information
5. Distance check prevents inspection from too far away

---

## ✅ Phase 3: Lost/Stolen ID Replacement System

### What Was Implemented

**Configuration** (`config.lua`):
```lua
Config.Replacement = {
    enabled = true,
    fee = 150.0,
    cooldown = 86400,
    trackInDatabase = true,
    maxReplacements = 5
}
```

**Database Table**:
```sql
CREATE TABLE IF NOT EXISTS tlw_id_replacements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50) NOT NULL,
    reason VARCHAR(50) DEFAULT 'lost',
    fee DECIMAL(10,2),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_citizenid (citizenid)
)
```

**Features**:
- Replacement option at government offices (ox_target interaction)
- Higher fee than original application ($150 vs $50)
- 24-hour cooldown between replacements
- Maximum replacement limit (configurable, default 5)
- Database tracking of all replacements
- Preserves all existing ID data (name, tier, etc.)
- Tracks replacement count in metadata

**Server Event**:
- `tlw_idcard:server:requestReplacement` - Handle replacement request

**How It Works**:
1. Player with lost/stolen ID visits government office
2. Selects "Replace Lost/Stolen ID" option
3. System checks cooldown and max replacement limit
4. Player pays $150 fee
5. Old ID is removed, new ID issued with same data
6. Replacement is logged in database
7. Statistics are updated

---

## ✅ Phase 4: Citizenship Expiration/Renewal

### What Was Implemented

**Configuration** (`config.lua`):
```lua
Config.Expiration = {
    enabled = true,
    duration = 2592000,
    renewalFee = 75.0,
    warningDays = 7,
    allowExpiredUse = false
}
```

**Database Table**:
```sql
CREATE TABLE IF NOT EXISTS tlw_id_renewals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50) NOT NULL,
    old_expiration DATETIME,
    new_expiration DATETIME,
    fee DECIMAL(10,2),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_citizenid (citizenid)
)
```

**Features**:
- Automatic expiration date calculation (30 days default)
- Expiration date displayed on ID card
- Warning notifications 7 days before expiration
- Renewal system at government offices
- Configurable renewal fee ($75)
- Option to allow/disallow expired ID usage
- Tracks renewal history in database
- Counts number of renewals in metadata

**Server Events**:
- `tlw_idcard:server:requestRenewal` - Handle renewal request

**Client Events**:
- `tlw_idcard:client:checkExpiration` - Check and notify expiration status

**Database Updates**:
- Added `expiration_date` column to `tlw_id_applications` table

**How It Works**:
1. When ID is issued, expiration date is calculated and stored
2. When player shows ID, expiration is checked
3. If within warning period (7 days), warning notification shown
4. If expired, error notification and optional blocking
5. Player can renew at government office for $75
6. New expiration date calculated (30 more days)
7. Renewal logged in database

---

## ✅ Phase 5: Multiple Citizenship Tiers

### What Was Implemented

**Configuration** (`config.lua`):
```lua
Config.Tiers = {
    enabled = true,
    tiers = {
        {
            name = 'Basic',
            label = 'Basic Citizenship',
            price = 50.0,
            benefits = {...},
            color = '#8b6f47',
            badge = '📋'
        },
        {
            name = 'Premium',
            label = 'Premium Citizenship',
            price = 150.0,
            benefits = {...},
            color = '#b8860b',
            badge = '⭐'
        },
        {
            name = 'Elite',
            label = 'Elite Citizenship',
            price = 500.0,
            benefits = {...},
            color = '#ffd700',
            badge = '👑'
        }
    },
    allowUpgrade = true,
    upgradeRefund = true
}
```

**Features**:
- Three citizenship tiers: Basic ($50), Premium ($150), Elite ($500)
- Tier-based benefits system (configurable)
- Tier badge displayed on ID card with icon and color
- Tier upgrade system at government offices
- 50% refund of previous tier when upgrading
- Tier information in Discord webhook notifications
- Tier stored in database and item metadata

**Server Events**:
- `tlw_idcard:server:upgradeTier` - Handle tier upgrade

**Client Functions**:
- `OpenTierUpgradeMenu()` - Show ox_lib context menu with tier options

**Database Updates**:
- Added `tier` column to `tlw_id_applications` table

**UI Updates**:
- Tier badge in top-right corner of ID card
- Color-coded tier indicators
- Tier-specific icons (📋 ⭐ 👑)

**How It Works**:
1. Player selects tier during application (default: Basic)
2. Tier determines application fee
3. Tier displayed on ID card with badge
4. Player can upgrade tier at government office
5. Upgrade cost is new tier price minus 50% of old tier price
6. New ID issued with upgraded tier
7. All benefits and discounts applied based on tier

---

## ✅ Phase 6: Statistics Dashboard

### What Was Implemented

**Configuration** (`config.lua`):
```lua
Config.Statistics = {
    enabled = true,
    adminCommand = 'idstats',
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

**Database Table**:
```sql
CREATE TABLE IF NOT EXISTS tlw_id_statistics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    metric_type VARCHAR(50) NOT NULL,
    metric_value INT DEFAULT 0,
    date DATE DEFAULT CURRENT_DATE,
    UNIQUE KEY unique_metric_date (metric_type, date),
    INDEX idx_metric_type (metric_type),
    INDEX idx_date (date)
)
```

**Features**:
- Admin command `/idstats` (or configurable command)
- Real-time statistics dashboard with NUI
- Tracks 6 key metrics:
  - Total applications
  - Approvals
  - Denials
  - Pending applications
  - ID replacements
  - ID renewals
- Tier distribution visualization with bar charts
- Beautiful western-themed UI matching existing design
- Auto-incrementing statistics on each action

**Admin Command**:
- `/idstats` - Open statistics dashboard (requires admin ACE)

**Server Events**:
- Statistics automatically tracked on all actions

**Client Events**:
- `tlw_idcard:client:showStatistics` - Display statistics dashboard

**Helper Functions**:
- `IncrementStatistic(metricType)` - Automatic statistics tracking

**UI Components**:
- Grid layout with 6 stat boxes
- Animated stat cards with icons
- Tier distribution bar chart
- Color-coded tier visualization
- Close button with escape key support

**How It Works**:
1. Admin types `/idstats` command
2. Server queries database for all statistics
3. Data sent to client
4. NUI displays beautiful dashboard with:
   - Total counts for each metric
   - Tier distribution percentages
   - Visual bar charts for tiers
5. Admin can close with ESC or close button

---

## 🔧 Technical Implementation Details

### Database Schema Updates

**Main Table (`tlw_id_applications`)**:
- Added `tier` column (VARCHAR(20))
- Added `expiration_date` column (DATETIME)

**New Tables**:
1. `tlw_id_replacements` - Tracks all ID replacements
2. `tlw_id_renewals` - Tracks all ID renewals
3. `tlw_id_statistics` - Tracks system-wide statistics

### Server-Side Changes

**New Events**:
- Camera photo handling (enhanced)
- ID inspection system (3 events)
- Replacement system (1 event)
- Renewal system (1 event)
- Tier upgrade system (1 event)
- Statistics tracking (automatic)

**New Helper Functions**:
- `IncrementStatistic(metricType)` - Statistics tracking
- `CalculateExpirationDate()` - Expiration calculation
- `IsIDExpired(expirationDate)` - Expiration checking

### Client-Side Changes

**New Functions**:
- `TakePhotoWithCamera()` - Camera functionality
- `RequestIDInspection(targetPlayer)` - Inspection request
- `ShowOtherPlayerID(cardData)` - Display inspected ID
- `OpenTierUpgradeMenu()` - Tier selection menu

**New ox_target Interactions**:
- ID inspection (global player target)
- ID replacement (government office)
- ID renewal (government office)
- Tier upgrade (government office)

### UI Changes

**HTML Additions**:
- Photo image element
- Tier badge element
- Expiration row
- Statistics dashboard (complete new section)

**CSS Additions**:
- Photo image styles
- Tier badge styles (250+ lines)
- Statistics dashboard styles (complete new section)

**JavaScript Additions**:
- Photo display logic
- Tier badge display
- Expiration display
- Statistics dashboard rendering
- Tier distribution charts

---

## 🎮 Usage Guide

### For Players

**Taking Photos**:
1. Visit a photographer location (marked on map)
2. Pay $20 fee
3. Hold still for 5 seconds during photo
4. Receive photo plate

**Applying for Citizenship**:
1. Select your desired tier (Basic/Premium/Elite)
2. Pay tier-specific fee
3. Submit application
4. Receive pending ID

**Inspecting Other Players**:
1. Stand within 3 units of target player
2. Aim at player with ox_target
3. Select "Inspect ID Card"
4. Wait for their approval
5. View their ID card

**Replacing Lost ID**:
1. Visit government office
2. Select "Replace Lost/Stolen ID"
3. Pay $150 fee
4. Receive new ID (24-hour cooldown)

**Renewing ID**:
1. Visit government office when ID is near expiration
2. Select "Renew Citizenship"
3. Pay $75 fee
4. Receive renewed ID (30 more days)

**Upgrading Tier**:
1. Visit government office
2. Select "Upgrade Citizenship Tier"
3. Choose desired tier
4. Pay upgrade cost (with 50% refund)
5. Receive upgraded ID

### For Admins

**Viewing Statistics**:
1. Type `/idstats` in chat
2. View comprehensive dashboard
3. Monitor tier distribution
4. Track system usage
5. Close with ESC

**Approving Applications**:
- `/approveid [playerid]` - Approve application (tracks statistics)

**Denying Applications**:
- `/denyid [playerid]` - Deny application (tracks statistics)

---

## 🔒 Security Considerations

All new features include proper security checks:
- Player validation on all server events
- Money checks before transactions
- Item checks before operations
- Cooldown enforcement
- Maximum limits (replacements)
- Distance checks (inspection)
- Permission checks (admin commands)
- SQL injection prevention (parameterized queries)

---

## 🎨 UI/UX Enhancements

All new UI elements follow the existing western theme:
- Aged parchment backgrounds
- Victorian gold borders
- Wolf emblems and icons
- Cinzel and IM Fell English fonts
- Consistent color scheme
- Smooth animations
- Responsive design

---

## 📊 Performance Impact

Minimal performance impact:
- Database queries are optimized with indexes
- Statistics tracking is async
- UI rendering is efficient
- No heavy computations on client
- Proper event cleanup
- Cooldown system prevents spam

---

## 🔮 Future Enhancements

Potential future additions:
- Actual webcam integration for photos
- Photo filters and editing
- Multiple ID card designs per tier
- Family tier packages
- Seasonal tier bonuses
- Advanced statistics filtering
- Export statistics to CSV
- Tier-specific perks integration with other scripts

---

## 📝 Configuration Tips

**Camera Settings**:
- Adjust `fov` for zoom level (20-50 recommended)
- Adjust `offsetForward` for distance (0.3-0.7 recommended)
- Adjust `offsetUp` for height (0.4-0.8 recommended)
- Increase `duration` for slower photo capture

**Inspection Settings**:
- Set `maxDistance` based on your preference
- Enable `requireIDInHand` for more roleplay
- Disable `allowDenial` for automatic inspections

**Replacement Settings**:
- Increase `fee` to discourage abuse
- Adjust `cooldown` (in seconds, 86400 = 24 hours)
- Set `maxReplacements` to limit abuse (0 = unlimited)

**Expiration Settings**:
- Adjust `duration` (in seconds, 2592000 = 30 days)
- Set `renewalFee` for desired renewal cost
- Adjust `warningDays` for early notifications
- Toggle `allowExpiredUse` based on server rules

**Tier Settings**:
- Customize prices for each tier
- Add/modify benefits list
- Change colors and badges
- Toggle `upgradeRefund` for upgrade policy

**Statistics Settings**:
- Change `adminCommand` name
- Toggle specific metrics on/off
- Disable entirely if not needed

---

## 🐛 Troubleshooting

**Camera not working**:
- Check `Config.Camera.enabled = true`
- Verify camera natives are correct for RedM
- Check console for errors

**Inspection not working**:
- Verify ox_target is installed and working
- Check distance between players
- Ensure both players have IDs

**Statistics not displaying**:
- Verify database tables were created
- Check admin permissions
- Look for console errors
- Ensure statistics tracking is enabled

**Tier not showing**:
- Check `Config.Tiers.enabled = true`
- Verify tier was selected during application
- Ensure database has tier column

---

## ✅ Testing Checklist

- [x] Camera captures photo correctly
- [x] Photo displays on ID card
- [x] Inspection request/response works
- [x] Inspection shows correct ID data
- [x] Replacement removes old ID
- [x] Replacement creates new ID
- [x] Replacement enforces cooldown
- [x] Expiration calculates correctly
- [x] Expiration warnings display
- [x] Renewal extends expiration
- [x] Tier badge displays correctly
- [x] Tier upgrade works
- [x] Tier upgrade refund calculates correctly
- [x] Statistics increment correctly
- [x] Statistics dashboard displays
- [x] Statistics show correct data
- [x] All database tables created
- [x] All new locale strings work

---

**Implementation Status**: ✅ COMPLETE

All 6 phases have been successfully implemented with full functionality, comprehensive error handling, and seamless integration with the existing system.
