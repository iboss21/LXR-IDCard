# 🚀 v3.0 Feature Documentation

## Overview

Version 3.0 introduces 12 major enhancements to The Land of Wolves ID Card System, focusing on advanced features, integrations, and player experience improvements.

---

## 📋 Feature List

### 1. **Actual Webcam Integration** 
Real player photos using HTML5 webcam API

**Configuration:**
```lua
Config.Webcam = {
    enabled = false,
    provider = 'html5',
    resolution = {width = 640, height = 480},
    quality = 0.8,
    countdown = 3,
    retakeAllowed = true,
    maxRetakes = 3,
    fallbackToCamera = true
}
```

**Usage:**
- When enabled, players can use their real webcam for ID photos
- Countdown system before capture
- Multiple retake attempts allowed
- Automatic fallback to in-game camera if webcam fails

**Security Note:** Requires player permission to access webcam. Disabled by default for privacy.

---

### 2. **Photo Filters and Editing**
Professional photo editing tools

**Configuration:**
```lua
Config.PhotoEditing = {
    enabled = true,
    filters = {...}, -- 5 preset filters
    brightness = {enabled = true, min = 0.5, max = 1.5},
    contrast = {enabled = true, min = 0.5, max = 1.5},
    rotation = {enabled = true, angles = {0, 90, 180, 270}}
}
```

**Features:**
- 5 western-themed filters (Sepia, B&W, Vintage, Aged)
- Brightness/contrast adjustments
- Image rotation (0°, 90°, 180°, 270°)
- Real-time preview
- Reset functionality

---

### 3. **Multiple ID Card Designs per Tier**
Customizable ID card templates

**Configuration:**
```lua
Config.CardDesigns = {
    enabled = true,
    designs = {
        Basic = {...},   -- 2 designs
        Premium = {...}, -- 3 designs
        Elite = {...}    -- 4 designs
    },
    allowChange = true,
    changeFee = 25.0
}
```

**Features:**
- Tier-specific design options
- More designs unlock with higher tiers
- Players can change design after issuance
- Small fee for design changes

**Designs:**
- Classic Parchment (all tiers)
- Simple Document (Basic)
- Ornate Gold (Premium+)
- Leather Bound (Premium+)
- Royal Decree (Elite)
- Platinum Edition (Elite)

---

### 4. **Family Tier Packages**
Discounted citizenship for families

**Configuration:**
```lua
Config.FamilyTiers = {
    enabled = true,
    packages = {
        {name = 'Family Basic', pricePerMember = 40.0, maxMembers = 4},
        {name = 'Family Premium', pricePerMember = 120.0, maxMembers = 6}
    },
    sharedBenefits = true
}
```

**Features:**
- 20% discount vs individual citizenship
- 2-6 family members supported
- Shared tier benefits
- Family badge on ID cards
- Optional integration with family/gang scripts

---

### 5. **Seasonal Tier Bonuses**
Special bonuses based on real-world seasons

**Configuration:**
```lua
Config.SeasonalBonuses = {
    enabled = true,
    seasons = {
        winter = {...}, -- Dec-Feb
        spring = {...}, -- Mar-May
        summer = {...}, -- Jun-Aug
        autumn = {...}  -- Sep-Nov
    }
}
```

**Features:**
- Automatic season detection
- Tier-specific discounts (5-25%)
- Seasonal bonus items/perks
- Applies to renewals and upgrades
- Seasonal badge display

---

### 6. **Advanced Statistics**
Professional analytics dashboard with charts

**Configuration:**
```lua
Config.AdvancedStatistics = {
    enabled = true,
    features = {
        charts = true,
        graphs = true,
        exports = true,
        filtering = true,
        realtime = true
    },
    exportFormats = {csv = true, json = true}
}
```

**Features:**
- 6 key metric cards
- 4 interactive charts (Line, Doughnut, Bar)
- Real-time data updates
- Export to CSV/JSON
- Date range filtering
- Beautiful western-themed UI

**Metrics Tracked:**
- Total applications
- Approvals/denials
- Pending applications
- ID replacements
- ID renewals
- Tier distribution

**Charts:**
- Applications over time (line chart)
- Tier distribution (doughnut chart)
- Approval rate (bar chart)
- Seasonal activity (line chart)

---

### 7. **Multi-Language Support**
Comprehensive localization system

**Configuration:**
```lua
Config.MultiLanguage = {
    enabled = true,
    defaultLanguage = 'en',
    availableLanguages = {
        {code = 'en', label = 'English', flag = '🇺🇸'},
        {code = 'es', label = 'Español', flag = '🇪🇸'},
        {code = 'fr', label = 'Français', flag = '🇫🇷'},
        {code = 'de', label = 'Deutsch', flag = '🇩🇪'},
        {code = 'pt', label = 'Português', flag = '🇵🇹'}
    },
    allowPlayerSelection = true,
    savePreference = true
}
```

**Features:**
- 5 languages included (EN, ES, FR, DE, PT)
- Player language selection via `/idlanguage`
- Persistent language preferences
- Easy to add new languages
- Fallback to English if translation missing

**Adding Languages:**
1. Create `/locales/xx.lua` (xx = language code)
2. Copy English locale structure
3. Translate all strings
4. Add to `Config.MultiLanguage.availableLanguages`

---

### 8. **Custom Tier Creation via Config**
Flexible tier system

**Configuration:**
```lua
Config.CustomTiers = {
    enabled = true,
    allowAdminCreation = true,
    maxCustomTiers = 10,
    tiers = {
        -- Add custom tiers here
    }
}
```

**Features:**
- Define unlimited custom tiers
- Admin command to create tiers in-game
- Job/level requirements per tier
- Custom colors and badges
- Unique benefits per tier

**Example Custom Tier:**
```lua
{
    name = 'Merchant',
    label = 'Merchant Citizenship',
    price = 200.0,
    benefits = {'Reduced market fees', 'Merchant guild access'},
    color = '#cd7f32',
    badge = '💰',
    requiredJob = 'merchant',
    requiredLevel = 5
}
```

---

### 9. **Tier-Specific Perks API**
Integration API for other scripts

**Configuration:**
```lua
Config.TierPerks = {
    enabled = true,
    perks = {
        Basic = {shopDiscounts = 0.0, jobPayBonus = 0.0},
        Premium = {shopDiscounts = 0.10, jobPayBonus = 0.05},
        Elite = {shopDiscounts = 0.25, jobPayBonus = 0.15}
    },
    exportForOtherScripts = true
}
```

**Exported Functions:**
```lua
-- Get player's citizenship tier
local tier = exports['tlw_idcard']:GetPlayerTier(source)

-- Check if player has citizenship
local hasCitizenship = exports['tlw_idcard']:HasCitizenship(source)

-- Get player's perks
local perks = exports['tlw_idcard']:GetPlayerPerks(source)

-- Get specific discounts
local shopDiscount = exports['tlw_idcard']:GetShopDiscount(source)
local jobBonus = exports['tlw_idcard']:GetJobBonus(source)
local housingDiscount = exports['tlw_idcard']:GetHousingDiscount(source)
```

**Perks Available:**
- Shop discounts (0-25%)
- Job pay bonuses (0-15%)
- Housing discounts (0-25%)
- Fast travel access
- Custom emotes
- Custom clothing items

---

### 10. **Integration with Job Systems**
Job requirements and bonuses

**Configuration:**
```lua
Config.JobIntegration = {
    enabled = true,
    framework = 'rsg-core',
    features = {
        jobRequirements = true,
        jobBonuses = true,
        governmentJobs = {'police', 'doctor', 'judge'},
        tierJobBonuses = {
            Basic = 0.0,
            Premium = 0.05,
            Elite = 0.15
        }
    },
    jobTierRequirements = {
        police = 'Basic',
        judge = 'Premium',
        mayor = 'Elite'
    }
}
```

**Features:**
- Citizenship required for government jobs
- Tier requirements for specific jobs
- Automatic job pay bonuses
- Prevents non-citizens from restricted jobs

**API Usage:**
```lua
-- Check if player can take a job
local canTake, reason = exports['tlw_idcard']:CanTakeJob(source, 'police')
if not canTake then
    -- Notify player of requirement
end
```

---

### 11. **Integration with Property Systems**
Property ownership requirements

**Configuration:**
```lua
Config.PropertyIntegration = {
    enabled = true,
    framework = 'rsg-housing',
    features = {
        purchaseRequirement = true,
        tierDiscounts = true,
        tierLimits = true
    },
    discounts = {
        Basic = 0.0,
        Premium = 0.10,
        Elite = 0.25
    },
    propertyLimits = {
        none = 0,
        Basic = 1,
        Premium = 3,
        Elite = 10
    },
    taxReduction = {
        Basic = 0.0,
        Premium = 0.15,
        Elite = 0.30
    }
}
```

**Features:**
- Citizenship required to purchase property
- Tier-based purchase discounts (0-25%)
- Property ownership limits by tier
- Tax reductions (0-30%)

**API Usage:**
```lua
-- Check if player can purchase
local canPurchase, reason = exports['tlw_idcard']:CanPurchaseProperty(source)

-- Get discount
local discount = exports['tlw_idcard']:GetPropertyDiscount(source)

-- Get property limit
local limit = exports['tlw_idcard']:GetPropertyLimit(source)

-- Get tax reduction
local taxReduction = exports['tlw_idcard']:GetPropertyTaxReduction(source)
```

---

### 12. **Criminal Record Integration**
Criminal history affects citizenship

**Configuration:**
```lua
Config.CriminalRecords = {
    enabled = true,
    framework = 'rsg-lawman',
    features = {
        showOnID = true,
        affectApproval = true,
        tierRestrictions = true,
        recordExpiry = true
    },
    tierCrimeLimits = {
        Basic = 5,
        Premium = 2,
        Elite = 0
    },
    recordExpiryDays = 90,
    allowAppeals = true,
    appealFee = 100.0
}
```

**Features:**
- Criminal status displayed on ID
- Crime count limits per tier
- Records expire after 90 days
- Appeal system for record removal
- Automatic approval consideration

**API Usage:**
```lua
-- Get crime count
local crimeCount = exports['tlw_idcard']:GetCriminalRecordCount(source)

-- Check if player can get tier
local canGet, reason = exports['tlw_idcard']:CanGetTierWithRecord(source, 'Elite')
```

---

## 🎮 Commands

| Command | Description | Permission |
|---------|-------------|------------|
| `/idlanguage` | Change UI language | All players |
| `/idstats` | View statistics dashboard | Admin |
| `/createtier` | Create custom tier | Admin |

---

## 📊 Database Changes

### New Tables

**None** - All v3.0 features use existing tables or are configuration-based.

### Modified Tables

**None** - Backward compatible with v2.0 database schema.

---

## 🔧 Configuration Tips

### Enabling/Disabling Features

Each feature can be independently enabled/disabled:

```lua
Config.Webcam.enabled = false -- Disable webcam
Config.PhotoEditing.enabled = true -- Enable photo editing
Config.SeasonalBonuses.enabled = true -- Enable seasonal bonuses
```

### Performance Optimization

For servers with many players:

```lua
Config.AdvancedStatistics.refreshInterval = 60000 -- Reduce refresh rate
Config.AdvancedStatistics.features.realtime = false -- Disable real-time
```

### Privacy Considerations

Webcam feature is disabled by default:

```lua
Config.Webcam.enabled = false -- Keep disabled unless players consent
```

---

## 🔌 Integration Examples

### Shop Script Integration

```lua
-- In your shop script
local function GetFinalPrice(source, basePrice)
    local discount = exports['tlw_idcard']:GetShopDiscount(source)
    return basePrice * (1 - discount)
end
```

### Job Script Integration

```lua
-- In your job script
RegisterNetEvent('myjob:hire', function(jobName)
    local source = source
    local canTake, reason = exports['tlw_idcard']:CanTakeJob(source, jobName)
    
    if not canTake then
        TriggerClientEvent('notify', source, reason, 'error')
        return
    end
    
    -- Continue with hiring
end)
```

### Property Script Integration

```lua
-- In your property script
RegisterNetEvent('myproperty:purchase', function(propertyId, price)
    local source = source
    local canPurchase = exports['tlw_idcard']:CanPurchaseProperty(source)
    local discount = exports['tlw_idcard']:GetPropertyDiscount(source)
    
    local finalPrice = price * (1 - discount)
    -- Continue with purchase
end)
```

---

## 🎨 UI Customization

All new UI elements follow the western theme and can be customized via CSS:

```css
/* Webcam interface */
.webcam-card { background: #F5E6D3; }

/* Photo editor */
.editor-card { border: 2px solid #B8860B; }

/* Statistics dashboard */
.stats-dashboard { background: linear-gradient(#E8D4B8, #D4C4A8); }
```

---

## 🐛 Troubleshooting

### Webcam Not Working
- Check browser permissions
- Ensure HTTPS connection (required for webcam API)
- Verify `Config.Webcam.enabled = true`
- Check console for errors

### Statistics Not Loading
- Ensure database connection is working
- Check `Config.AdvancedStatistics.enabled = true`
- Verify admin permissions
- Check server console for SQL errors

### Integrations Not Working
- Ensure framework matches configuration
- Verify export functions are being called correctly
- Check that both scripts are started
- Enable debug mode for detailed logs

---

## 📝 Notes

- All v3.0 features are optional and can be disabled
- Backward compatible with v2.0
- No breaking changes to existing functionality
- Minimal performance impact
- Comprehensive error handling

---

## 🔮 Future Considerations

Potential future additions:
- AI-powered photo enhancement
- Blockchain-based ID verification
- Biometric authentication
- Virtual reality ID viewing
- Machine learning tier recommendations

---

**Version**: 3.0.0  
**Last Updated**: December 2024  
**Author**: The Land of Wolves Team
