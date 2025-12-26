-- v3.0 Configuration Examples
-- Copy these into your config.lua and customize as needed

-- ============================================
-- EXAMPLE 1: Enable All v3.0 Features
-- ============================================

--[[
Config.Webcam.enabled = true
Config.PhotoEditing.enabled = true
Config.CardDesigns.enabled = true
Config.FamilyTiers.enabled = true
Config.SeasonalBonuses.enabled = true
Config.AdvancedStatistics.enabled = true
Config.MultiLanguage.enabled = true
Config.CustomTiers.enabled = true
Config.TierPerks.enabled = true
Config.JobIntegration.enabled = true
Config.PropertyIntegration.enabled = true
Config.CriminalRecords.enabled = true
]]

-- ============================================
-- EXAMPLE 2: Minimal v3.0 Setup (Recommended Start)
-- ============================================

--[[
Config.Webcam.enabled = false -- Disabled for privacy
Config.PhotoEditing.enabled = true -- Basic photo editing
Config.CardDesigns.enabled = false -- One design per tier
Config.FamilyTiers.enabled = false -- Individual only
Config.SeasonalBonuses.enabled = true -- Automatic bonuses
Config.AdvancedStatistics.enabled = true -- Better admin dashboard
Config.MultiLanguage.enabled = true -- Multi-language UI
Config.CustomTiers.enabled = false -- Use default tiers only
Config.TierPerks.enabled = true -- Enable perks API
Config.JobIntegration.enabled = false -- No job restrictions
Config.PropertyIntegration.enabled = false -- No property restrictions
Config.CriminalRecords.enabled = false -- No criminal checks
]]

-- ============================================
-- EXAMPLE 3: Roleplay-Focused Server
-- ============================================

--[[
-- Strict citizenship requirements with criminal checks
Config.Webcam.enabled = false
Config.PhotoEditing.enabled = true
Config.CardDesigns.enabled = true
Config.FamilyTiers.enabled = true
Config.SeasonalBonuses.enabled = true
Config.AdvancedStatistics.enabled = true
Config.MultiLanguage.enabled = true
Config.CustomTiers.enabled = true
Config.TierPerks.enabled = true
Config.JobIntegration.enabled = true
Config.PropertyIntegration.enabled = true
Config.CriminalRecords.enabled = true

-- Strict criminal limits
Config.CriminalRecords.tierCrimeLimits = {
    Basic = 2,
    Premium = 0,
    Elite = 0
}

-- High property value
Config.PropertyIntegration.propertyLimits = {
    none = 0,
    Basic = 1,
    Premium = 2,
    Elite = 5
}

-- Government jobs require citizenship
Config.JobIntegration.jobTierRequirements = {
    police = 'Basic',
    doctor = 'Basic',
    judge = 'Premium',
    mayor = 'Elite',
    sheriff = 'Elite'
}
]]

-- ============================================
-- EXAMPLE 4: Casual Server
-- ============================================

--[[
-- Easy citizenship, focus on features not restrictions
Config.Webcam.enabled = false
Config.PhotoEditing.enabled = true
Config.CardDesigns.enabled = true
Config.FamilyTiers.enabled = true
Config.SeasonalBonuses.enabled = true
Config.AdvancedStatistics.enabled = true
Config.MultiLanguage.enabled = true
Config.CustomTiers.enabled = false
Config.TierPerks.enabled = true
Config.JobIntegration.enabled = false
Config.PropertyIntegration.enabled = false
Config.CriminalRecords.enabled = false

-- Generous discounts
Config.TierPerks.perks = {
    Basic = {shopDiscounts = 0.05, jobPayBonus = 0.05},
    Premium = {shopDiscounts = 0.15, jobPayBonus = 0.10},
    Elite = {shopDiscounts = 0.30, jobPayBonus = 0.20}
}

-- Big seasonal bonuses
Config.SeasonalBonuses.seasons[1].bonuses.Elite.discount = 0.40
]]

-- ============================================
-- EXAMPLE 5: Custom Tier Examples
-- ============================================

--[[
Config.CustomTiers.tiers = {
    -- Merchant Tier
    {
        name = 'Merchant',
        label = 'Merchant Guild Citizenship',
        price = 200.0,
        benefits = {
            'All Basic benefits',
            'Reduced market stall fees (15%)',
            'Merchant guild access',
            'Priority trading permits',
            'Extended shop hours'
        },
        color = '#cd7f32',
        badge = '💰',
        requiredJob = nil, -- Available to all
        requiredLevel = nil
    },
    
    -- Lawman Tier
    {
        name = 'Lawman',
        label = 'Law Enforcement Citizenship',
        price = 250.0,
        benefits = {
            'All Premium benefits',
            'Law enforcement authority',
            'Weapon permit included',
            'Free ammunition supplies',
            'Legal protection'
        },
        color = '#4169e1',
        badge = '⭐',
        requiredJob = 'police',
        requiredLevel = 5
    },
    
    -- Rancher Tier
    {
        name = 'Rancher',
        label = 'Rancher Citizenship',
        price = 300.0,
        benefits = {
            'All Premium benefits',
            'Land ownership rights (up to 3 properties)',
            'Livestock trading license',
            'Agricultural subsidies (20%)',
            'Ranch equipment discounts'
        },
        color = '#8b4513',
        badge = '🐄',
        requiredJob = nil,
        requiredLevel = nil
    },
    
    -- Politician Tier
    {
        name = 'Politician',
        label = 'Political Citizenship',
        price = 1000.0,
        benefits = {
            'All Elite benefits',
            'Voting rights in territory decisions',
            'Can run for public office',
            'VIP government access',
            'Political immunity (limited)',
            'Priority law enforcement'
        },
        color = '#800020',
        badge = '🎩',
        requiredJob = nil,
        requiredLevel = 10
    }
}
]]

-- ============================================
-- EXAMPLE 6: Family Package Examples
-- ============================================

--[[
Config.FamilyTiers.packages = {
    -- Small Family
    {
        name = 'Family Basic',
        label = 'Small Family Citizenship',
        minMembers = 2,
        maxMembers = 4,
        pricePerMember = 40.0,
        benefits = {
            'All Basic benefits',
            '20% family discount',
            'Shared property ownership',
            'Family bond recognition'
        },
        color = '#8b6f47',
        badge = '👨‍👩‍👧'
    },
    
    -- Large Family
    {
        name = 'Family Premium',
        label = 'Large Family Citizenship',
        minMembers = 3,
        maxMembers = 8,
        pricePerMember = 100.0,
        benefits = {
            'All Premium benefits',
            '30% family discount',
            'Family estate access',
            'Generational benefits',
            'Family business permits'
        },
        color = '#b8860b',
        badge = '👨‍👩‍👧‍👦⭐'
    },
    
    -- Clan/Gang
    {
        name = 'Family Elite',
        label = 'Clan Citizenship',
        minMembers = 5,
        maxMembers = 15,
        pricePerMember = 350.0,
        benefits = {
            'All Elite benefits',
            '40% group discount',
            'Clan territory rights',
            'Private security access',
            'Political influence',
            'Clan business advantages'
        },
        color = '#ffd700',
        badge = '👥👑'
    }
}
]]

-- ============================================
-- EXAMPLE 7: Seasonal Bonus Customization
-- ============================================

--[[
-- Winter Holiday Special
Config.SeasonalBonuses.seasons[1] = {
    name = 'winter',
    label = 'Winter Holiday Celebration',
    startMonth = 12,
    endMonth = 2,
    bonuses = {
        Basic = {
            discount = 0.15,
            bonus = 'Free winter coat and supplies'
        },
        Premium = {
            discount = 0.25,
            bonus = 'Premium winter estate access + holiday bonus'
        },
        Elite = {
            discount = 0.40,
            bonus = 'Elite winter mansion + unlimited firewood + holiday feast'
        }
    },
    badge = '🎄'
}

-- Summer Festival
Config.SeasonalBonuses.seasons[3] = {
    name = 'summer',
    label = 'Summer Rodeo Festival',
    startMonth = 6,
    endMonth = 8,
    bonuses = {
        Basic = {
            discount = 0.10,
            bonus = 'Festival entry pass'
        },
        Premium = {
            discount = 0.20,
            bonus = 'VIP festival pass + free food vouchers'
        },
        Elite = {
            discount = 0.35,
            bonus = 'Private festival box + unlimited access + prize horse'
        }
    },
    badge = '🎪'
}
]]

-- ============================================
-- EXAMPLE 8: Property Integration Setup
-- ============================================

--[[
-- Strict property ownership
Config.PropertyIntegration = {
    enabled = true,
    framework = 'rsg-housing',
    features = {
        purchaseRequirement = true, -- Must have citizenship
        tierDiscounts = true,
        tierLimits = true
    },
    discounts = {
        Basic = 0.0,
        Premium = 0.15, -- 15% off
        Elite = 0.30 -- 30% off
    },
    propertyLimits = {
        none = 0, -- Non-citizens: 0 properties
        Basic = 1, -- Can own 1 property
        Premium = 5, -- Can own 5 properties
        Elite = 20 -- Can own 20 properties
    },
    taxReduction = {
        Basic = 0.0,
        Premium = 0.20, -- 20% less tax
        Elite = 0.50 -- 50% less tax
    }
}

-- In your housing script:
-- local canBuy = exports['tlw_idcard']:CanPurchaseProperty(source)
-- local discount = exports['tlw_idcard']:GetPropertyDiscount(source)
-- local finalPrice = basePrice * (1 - discount)
]]

-- ============================================
-- EXAMPLE 9: Job Integration Setup
-- ============================================

--[[
-- Government jobs require citizenship
Config.JobIntegration = {
    enabled = true,
    framework = 'rsg-core',
    features = {
        jobRequirements = true,
        jobBonuses = true,
        governmentJobs = {
            'police', 'sheriff', 'deputy',
            'doctor', 'surgeon',
            'judge', 'lawyer',
            'mayor', 'clerk',
            'banker', 'accountant'
        },
        tierJobBonuses = {
            Basic = 0.05, -- 5% pay bonus
            Premium = 0.15, -- 15% pay bonus
            Elite = 0.25 -- 25% pay bonus
        }
    },
    restrictedJobs = true,
    jobTierRequirements = {
        -- Entry level
        police = 'Basic',
        doctor = 'Basic',
        clerk = 'Basic',
        
        -- Mid level
        sheriff = 'Premium',
        surgeon = 'Premium',
        lawyer = 'Premium',
        banker = 'Premium',
        
        -- High level
        judge = 'Elite',
        mayor = 'Elite',
        accountant = 'Elite'
    }
}

-- In your job script:
-- local canTake, reason = exports['tlw_idcard']:CanTakeJob(source, 'police')
-- local bonus = exports['tlw_idcard']:GetJobBonus(source)
-- local payWithBonus = basePay * (1 + bonus)
]]

-- ============================================
-- EXAMPLE 10: Multi-Language Setup
-- ============================================

--[[
-- Add more languages
Config.MultiLanguage = {
    enabled = true,
    defaultLanguage = 'en',
    availableLanguages = {
        {code = 'en', label = 'English', flag = '🇺🇸'},
        {code = 'es', label = 'Español', flag = '🇪🇸'},
        {code = 'fr', label = 'Français', flag = '🇫🇷'},
        {code = 'de', label = 'Deutsch', flag = '🇩🇪'},
        {code = 'pt', label = 'Português', flag = '🇵🇹'},
        {code = 'it', label = 'Italiano', flag = '🇮🇹'},
        {code = 'ru', label = 'Русский', flag = '🇷🇺'},
        {code = 'pl', label = 'Polski', flag = '🇵🇱'},
        {code = 'nl', label = 'Nederlands', flag = '🇳🇱'},
        {code = 'sv', label = 'Svenska', flag = '🇸🇪'}
    },
    allowPlayerSelection = true,
    savePreference = true
}

-- Create corresponding locale files:
-- locales/it.lua, locales/ru.lua, etc.
]]

-- ============================================
-- For more examples and documentation:
-- - docs/v3/V3_FEATURES.md (complete feature details)
-- - docs/technical/API_GUIDE.md (integration examples)
-- - docs/v3/V3_INSTALLATION.md (setup guide)
-- ============================================
