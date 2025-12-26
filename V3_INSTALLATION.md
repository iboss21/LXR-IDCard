# 🚀 v3.0 Installation and Upgrade Guide

## Overview

This guide covers installation and upgrading to The Land of Wolves IDCard System v3.0.

---

## 📋 Requirements

### Core Requirements (Same as v2.0)
- RedM Server
- RSG-Core Framework
- rsg-inventory (ox_inventory based)
- ox_lib
- ox_target
- oxmysql
- MySQL/MariaDB Database

### New v3.0 Requirements
- **Chart.js** (for advanced statistics) - Optional
- **HTTPS connection** (for webcam feature) - Optional
- Modern browser with HTML5 support

---

## 🆕 Fresh Installation

### Step 1: Download and Extract

```bash
cd resources
git clone https://github.com/iboss21/LXR-IDCard.git tlw_idcard
cd tlw_idcard
```

### Step 2: Database Setup

No additional database tables needed! v3.0 uses the same schema as v2.0.

If you're installing fresh, the script will automatically create all necessary tables on first start.

### Step 3: Configure the Script

Edit `config.lua` and configure:

```lua
-- REQUIRED: Set your server locations
Config.PhotographerLocations = {
    {coords = vector3(x, y, z), ...}
}

Config.GovernmentOffices = {
    {coords = vector3(x, y, z), ...}
}

-- OPTIONAL: Discord webhook
Config.Discord.webhook = 'YOUR_WEBHOOK_URL'

-- OPTIONAL: Enable v3.0 features
Config.Webcam.enabled = false -- Keep disabled unless HTTPS
Config.PhotoEditing.enabled = true
Config.MultiLanguage.enabled = true
Config.AdvancedStatistics.enabled = true
-- ... configure other features as needed
```

### Step 4: Add Items to Inventory

See [INSTALL.md](INSTALL.md) for detailed inventory integration steps.

Items needed:
- `photo_plate`
- `id_card_pending`
- `id_card_citizen`

### Step 5: Add to server.cfg

```
ensure tlw_idcard
```

### Step 6: Restart Server

```
restart tlw_idcard
```

---

## 🔄 Upgrading from v2.0 to v3.0

### Automatic Upgrade (Recommended)

v3.0 is **fully backward compatible** with v2.0. Simply update the files:

```bash
cd resources/tlw_idcard
git pull origin main
```

Then restart the resource:
```
restart tlw_idcard
```

**That's it!** All your existing data, configurations, and functionality will continue to work.

### Manual Upgrade Steps

1. **Backup your current installation:**
   ```bash
   cp -r tlw_idcard tlw_idcard_backup
   ```

2. **Backup your configuration:**
   ```bash
   cp tlw_idcard/config.lua config_backup.lua
   ```

3. **Update the files:**
   Download the new version and replace all files EXCEPT `config.lua`

4. **Merge configuration:**
   - Open your backup `config_backup.lua`
   - Open the new `config.lua`
   - Copy your custom settings (coordinates, fees, etc.) to the new config
   - The new config has all the v3.0 features at the bottom
   - Configure v3.0 features as desired

5. **Restart the resource:**
   ```
   restart tlw_idcard
   ```

### Configuration Migration

Add these new sections to your existing `config.lua`:

```lua
-- At the end of your config file, add:

-- v3.0 Features
Config.Webcam = { ... } -- Copy from new config
Config.PhotoEditing = { ... }
Config.CardDesigns = { ... }
Config.FamilyTiers = { ... }
Config.SeasonalBonuses = { ... }
Config.AdvancedStatistics = { ... }
Config.MultiLanguage = { ... }
Config.CustomTiers = { ... }
Config.TierPerks = { ... }
Config.JobIntegration = { ... }
Config.PropertyIntegration = { ... }
Config.CriminalRecords = { ... }
```

---

## ⚙️ Feature-Specific Setup

### Webcam Integration

**Requirements:**
- HTTPS connection (required by browser security)
- Player permission for camera access

**Setup:**
1. Ensure your server uses HTTPS
2. Enable in config:
   ```lua
   Config.Webcam.enabled = true
   ```
3. Players will be prompted for camera permission on first use

**Troubleshooting:**
- If webcam doesn't work, it automatically falls back to in-game camera
- Check browser console (F12) for errors
- Ensure HTTPS is properly configured

### Advanced Statistics

**Optional: Chart.js Integration**

For visual charts in the statistics dashboard:

1. Download Chart.js: https://www.chartjs.org/
2. Place `chart.min.js` in `html/assets/`
3. Add to `fxmanifest.lua`:
   ```lua
   files {
       'html/assets/chart.min.js'
   }
   ```
4. Add to `html/index.html`:
   ```html
   <script src="assets/chart.min.js"></script>
   ```

**Note:** Statistics work without Chart.js, but charts won't display.

### Multi-Language Support

**Adding More Languages:**

1. Create new locale file: `locales/xx.lua` (xx = language code)
2. Copy structure from `locales/en.lua`
3. Translate all strings
4. Add to config:
   ```lua
   Config.MultiLanguage.availableLanguages = {
       ...
       {code = 'xx', label = 'Language Name', flag = '🏳️'}
   }
   ```

### Job/Property/Criminal Integrations

**Setup:**
1. Configure the framework name:
   ```lua
   Config.JobIntegration.framework = 'rsg-core'
   Config.PropertyIntegration.framework = 'rsg-housing'
   Config.CriminalRecords.framework = 'rsg-lawman'
   ```

2. In your other scripts, use the API:
   ```lua
   local canTake = exports['tlw_idcard']:CanTakeJob(source, 'police')
   ```

See [API_GUIDE.md](API_GUIDE.md) for complete integration instructions.

---

## 🔍 Post-Installation Verification

### 1. Test Basic Functionality

- [ ] Resource starts without errors
- [ ] Blips appear on map
- [ ] Can take photos at photographer
- [ ] Can submit citizenship application
- [ ] ID cards display correctly

### 2. Test v3.0 Features

- [ ] Language selection works (`/idlanguage`)
- [ ] Photo editing interface opens (if enabled)
- [ ] Statistics dashboard shows (`/idstats`)
- [ ] Seasonal bonuses display
- [ ] API exports work in other scripts

### 3. Check Console

```
Server console should show:
[TLW-IDCard v3.0] API exports loaded successfully
[TLW-IDCard v3.0] Client features loaded successfully
```

---

## 🚨 Troubleshooting

### Resource Won't Start

**Check:**
1. All dependencies installed and started first
2. No syntax errors in config.lua
3. Server console for error messages

**Common Fixes:**
```bash
# Ensure dependencies start first
ensure ox_lib
ensure ox_target
ensure rsg-core
ensure tlw_idcard
```

### Webcam Not Working

**Issue:** Webcam doesn't activate
**Solution:** 
1. Check HTTPS is enabled
2. Verify `Config.Webcam.enabled = true`
3. Test in different browser
4. Falls back to in-game camera automatically

### Statistics Not Showing

**Issue:** Statistics dashboard is blank
**Solution:**
1. Ensure `Config.AdvancedStatistics.enabled = true`
2. Check admin permissions
3. Verify database has data
4. Check browser console (F12) for errors

### Locale Not Changing

**Issue:** Language doesn't change
**Solution:**
1. Ensure `Config.MultiLanguage.enabled = true`
2. Check locale files exist
3. Verify language code is correct
4. Restart resource after adding locales

### API Exports Not Working

**Issue:** Other scripts can't use exports
**Solution:**
1. Ensure tlw_idcard is started
2. Check export name is correct
3. Use server-side only (not client)
4. Check `server/api.lua` loaded

---

## 📊 Performance Optimization

### For Large Servers (100+ players)

```lua
-- Reduce statistics refresh rate
Config.AdvancedStatistics.refreshInterval = 60000 -- 1 minute

-- Disable real-time updates
Config.AdvancedStatistics.features.realtime = false

-- Disable webcam (falls back to in-game camera)
Config.Webcam.enabled = false
```

### For Potato Servers

```lua
-- Disable heavy features
Config.AdvancedStatistics.features.charts = false
Config.PhotoEditing.enabled = false
Config.SeasonalBonuses.enabled = false
```

---

## 🔐 Security Recommendations

### Production Deployment

1. **Disable webcam unless necessary:**
   ```lua
   Config.Webcam.enabled = false
   ```

2. **Set reasonable limits:**
   ```lua
   Config.CustomTiers.maxCustomTiers = 5
   Config.Replacement.maxReplacements = 3
   ```

3. **Configure admin permissions:**
   ```lua
   Config.AdminAce = 'admin'
   ```

4. **Enable Discord logging:**
   ```lua
   Config.Discord.enabled = true
   Config.Discord.webhook = 'YOUR_WEBHOOK'
   ```

---

## 📝 Configuration Best Practices

### Start Simple

Begin with default settings, then customize:

```lua
-- Start with these enabled:
Config.PhotoEditing.enabled = true
Config.MultiLanguage.enabled = true
Config.AdvancedStatistics.enabled = true

-- Keep these disabled initially:
Config.Webcam.enabled = false
Config.FamilyTiers.enabled = false
```

### Test Incrementally

1. Enable one feature at a time
2. Test thoroughly
3. Monitor performance
4. Enable next feature

---

## 🆘 Getting Help

### Resources

- **Documentation:** V3_FEATURES.md, API_GUIDE.md
- **GitHub Issues:** https://github.com/iboss21/LXR-IDCard/issues
- **Discussions:** https://github.com/iboss21/LXR-IDCard/discussions

### Before Asking for Help

1. Check server console for errors
2. Check client console (F8) for errors
3. Verify all dependencies are updated
4. Try with default configuration
5. Review troubleshooting section

### Reporting Issues

Include:
- Server version
- Framework version
- Resource version (3.0.0)
- Error messages (server and client)
- Steps to reproduce
- Configuration (without webhook URLs)

---

## 🎉 You're All Set!

Your v3.0 installation is complete! Enjoy the new features:

- 🎥 Webcam integration
- 🎨 Photo editing
- 🎴 Multiple card designs
- 👨‍👩‍👧‍👦 Family packages
- 🍂 Seasonal bonuses
- 📈 Advanced statistics
- 🌍 Multi-language support
- ⚙️ Custom tiers
- 🔌 API integrations

**Next Steps:**
1. Customize your configuration
2. Test all features
3. Integrate with your other scripts
4. Enjoy enhanced citizenship roleplay!

---

**Version:** 3.0.0  
**Last Updated:** December 2024  
**Support:** https://github.com/iboss21/LXR-IDCard
