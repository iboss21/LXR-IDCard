Config = {}

-- The Land of Wolves Territory Settings
Config.TerritoryName = "The Land of Wolves"
Config.GovernorName = "Territorial Governor"

-- Photographer Locations (add multiple if needed)
Config.PhotographerLocations = {
    {
        name = "Saint Denis Photographer",
        coords = vector3(2736.35, -1226.26, 49.37), -- Saint Denis example
        heading = 90.0,
        blip = true
    },
    -- Add more locations as needed
}

-- Government Office Locations
Config.GovernmentOffices = {
    {
        name = "Valentine Clerk Office",
        coords = vector3(-275.96, 780.13, 118.50), -- Valentine example
        heading = 180.0,
        blip = true
    },
    -- Add more locations as needed
}

-- Items
Config.Items = {
    photo = 'photo_plate',
    idPending = 'id_card_pending',
    idCitizen = 'id_card_citizen'
}

-- Fees
Config.PhotoFee = 20.0
Config.ApplicationFee = 50.0

-- Camera Settings (Phase 1: Real Mugshots)
Config.Camera = {
    enabled = true, -- Enable real camera mugshots
    fov = 30.0, -- Field of view for camera
    offsetForward = 0.5, -- Distance in front of player
    offsetUp = 0.6, -- Height adjustment
    duration = 5000, -- Duration to display camera view (ms)
    useWebcam = false, -- Use player's actual webcam (requires external script)
    storeAsBase64 = true -- Store photo as base64 in metadata
}

-- Discord Integration
Config.Discord = {
    enabled = true,
    webhook = 'YOUR_WEBHOOK_URL_HERE',
    botName = 'The Land of Wolves - Immigration',
    avatar = '', -- Optional avatar URL
    color = 8388608 -- Dark red
}

-- Application Form Fields
Config.FormFields = {
    {name = 'fullname', label = 'Full Name', type = 'text', required = true},
    {name = 'birthdate', label = 'Date of Birth', type = 'date', required = true},
    {name = 'birthplace', label = 'Birthplace', type = 'text', required = true},
    {name = 'occupation', label = 'Occupation', type = 'text', required = true},
    {name = 'reason', label = 'Reason for Immigration', type = 'textarea', required = true}
}

-- Animations
Config.Animations = {
    showCard = {
        dict = 'WORLD_HUMAN_WRITE_NOTEBOOK', -- Paper hold animation
        anim = 'WORLD_HUMAN_WRITE_NOTEBOOK',
        duration = -1
    }
}

-- Sounds
Config.Sounds = {
    enabled = true,
    paperRustle = 'paper_rustle',
    stampSound = 'stamp_sound'
}

-- Blips
Config.Blips = {
    photographer = {
        sprite = 1012738501, -- Camera icon
        color = 'BLIP_MODIFIER_MP_COLOR_32',
        scale = 0.2,
        prompt = 'Photographer'
    },
    government = {
        sprite = -570356389, -- Document icon
        color = 'BLIP_MODIFIER_MP_COLOR_8',
        scale = 0.2,
        prompt = 'Government Office'
    }
}

-- Cooldowns (in seconds)
Config.Cooldowns = {
    photo = 60, -- 1 minute between photos
    application = 300, -- 5 minutes between applications
    replacement = 86400 -- 24 hours between replacements (Phase 3)
}

-- ID Inspection Settings (Phase 2)
Config.Inspection = {
    enabled = true,
    maxDistance = 3.0, -- Maximum distance to inspect someone's ID
    requireIDInHand = true, -- Target player must be showing their ID
    allowDenial = true -- Target player can deny inspection request
}

-- ID Replacement Settings (Phase 3)
Config.Replacement = {
    enabled = true,
    fee = 150.0, -- Replacement fee (higher than original)
    cooldown = 86400, -- 24 hours cooldown (in seconds)
    trackInDatabase = true, -- Track replacement history
    maxReplacements = 5 -- Maximum replacements per player (0 = unlimited)
}

-- Expiration and Renewal Settings (Phase 4)
Config.Expiration = {
    enabled = true,
    duration = 2592000, -- 30 days in seconds (30 * 24 * 60 * 60)
    renewalFee = 75.0, -- Fee to renew expired ID
    warningDays = 7, -- Days before expiration to show warning
    allowExpiredUse = false -- Can expired IDs be shown?
}

-- Citizenship Tiers (Phase 5)
Config.Tiers = {
    enabled = true,
    tiers = {
        {
            name = 'Basic',
            label = 'Basic Citizenship',
            price = 50.0,
            benefits = {
                'Basic territorial rights',
                'Access to public services',
                'Standard voting rights'
            },
            color = '#8b6f47',
            badge = '📋'
        },
        {
            name = 'Premium',
            label = 'Premium Citizenship',
            price = 150.0,
            benefits = {
                'All Basic benefits',
                'Priority in government offices',
                'Reduced fines and fees (10% discount)',
                'Access to premium locations'
            },
            color = '#b8860b',
            badge = '⭐'
        },
        {
            name = 'Elite',
            label = 'Elite Citizenship',
            price = 500.0,
            benefits = {
                'All Premium benefits',
                'VIP status in all territories',
                'Significant fee reductions (25% discount)',
                'Access to exclusive areas',
                'Priority law enforcement response'
            },
            color = '#ffd700',
            badge = '👑'
        }
    },
    allowUpgrade = true, -- Allow upgrading from lower to higher tier
    upgradeRefund = true -- Refund portion of previous tier when upgrading
}

-- Statistics Dashboard (Phase 6)
Config.Statistics = {
    enabled = true,
    adminCommand = 'idstats', -- Command to open statistics dashboard
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

-- Debug mode
Config.Debug = false

-- Locale
Config.Locale = {
    -- Photographer
    photographer_prompt = 'Take Mugshot Photo',
    photographer_busy = 'The photographer is busy with another customer',
    photographer_cooldown = 'You must wait before taking another photo',
    photographer_insufficient_funds = 'You need $%s to take a photo',
    photographer_success = 'Photo taken! You received a Photo Plate.',
    
    -- Government Office
    government_prompt = 'Submit Citizenship Application',
    government_no_photo = 'You need a Photo Plate to apply for citizenship',
    government_cooldown = 'You must wait before submitting another application',
    government_insufficient_funds = 'You need $%s for the application fee',
    government_success = 'Application submitted! The Governor\'s Office will review your worthiness...',
    government_pending_received = 'You received a Resident Permit. Await approval for full citizenship.',
    
    -- Approval
    approval_success = 'You are now recognized as a Citizen of The Land of Wolves!',
    approval_admin_success = 'Citizenship approved for %s',
    approval_not_found = 'Player not found or has no pending application',
    
    -- ID Card
    card_title = 'THE LAND OF WOLVES',
    card_subtitle = 'TERRITORIAL IDENTIFICATION',
    card_pending = 'RESIDENT PERMIT',
    card_pending_subtitle = 'PENDING FULL CITIZENSHIP',
    card_approved = 'APPROVED - CITIZEN',
    
    -- Camera (Phase 1)
    camera_preparing = 'Preparing camera...',
    camera_smile = 'Hold still for your mugshot!',
    camera_success = 'Photo captured successfully!',
    
    -- Inspection (Phase 2)
    inspection_prompt = 'Inspect ID Card',
    inspection_request_sent = 'Inspection request sent to %s',
    inspection_request_received = '%s wants to inspect your ID. Accept?',
    inspection_denied = 'ID inspection was denied',
    inspection_too_far = 'You are too far away to inspect their ID',
    inspection_no_id = 'That person is not showing an ID card',
    
    -- Replacement (Phase 3)
    replacement_prompt = 'Replace Lost/Stolen ID',
    replacement_success = 'ID card replaced successfully!',
    replacement_cooldown = 'You must wait %s before replacing your ID again',
    replacement_max_reached = 'You have reached the maximum number of replacements',
    replacement_insufficient_funds = 'You need $%s to replace your ID',
    replacement_no_previous = 'You have no previous ID to replace',
    
    -- Expiration/Renewal (Phase 4)
    expiration_warning = 'Your ID will expire in %s days!',
    expiration_expired = 'Your ID has expired! Visit a government office to renew it.',
    renewal_prompt = 'Renew Citizenship',
    renewal_success = 'ID renewed successfully! Valid for 30 more days.',
    renewal_insufficient_funds = 'You need $%s to renew your ID',
    renewal_not_expired = 'Your ID is still valid',
    
    -- Tiers (Phase 5)
    tier_basic = 'Basic Citizenship',
    tier_premium = 'Premium Citizenship',
    tier_elite = 'Elite Citizenship',
    tier_upgrade_prompt = 'Upgrade Citizenship Tier',
    tier_upgrade_success = 'Upgraded to %s!',
    tier_benefits = 'Benefits: %s',
    
    -- Form
    form_title = 'Citizenship Application',
    form_subtitle = 'The Land of Wolves - Territorial Governor\'s Office',
    form_submit = 'Submit Application',
    form_cancel = 'Cancel',
    form_validation_error = 'Please fill in all required fields',
    
    -- v3.0 Webcam
    webcam_permission = 'Allow camera access to take your photo',
    webcam_countdown = 'Photo in %s seconds...',
    webcam_retake = 'Retake Photo',
    webcam_confirm = 'Use This Photo',
    webcam_failed = 'Failed to access webcam. Falling back to in-game camera.',
    
    -- v3.0 Photo Editing
    photo_edit_title = 'Edit Your Photo',
    photo_filter = 'Apply Filter',
    photo_brightness = 'Brightness',
    photo_contrast = 'Contrast',
    photo_rotate = 'Rotate',
    photo_done = 'Done Editing',
    
    -- v3.0 Card Designs
    card_design_select = 'Choose ID Card Design',
    card_design_change = 'Change ID Design',
    card_design_changed = 'ID card design changed!',
    
    -- v3.0 Family Tiers
    family_tier_prompt = 'Create Family Citizenship',
    family_member_add = 'Add Family Member',
    family_package_created = 'Family citizenship package created!',
    family_insufficient_members = 'You need at least %s members for this package',
    
    -- v3.0 Seasonal Bonuses
    seasonal_bonus_active = 'Seasonal Bonus Active: %s',
    seasonal_discount_applied = 'Seasonal discount applied: %s%%',
    
    -- v3.0 Advanced Statistics
    stats_export_csv = 'Export to CSV',
    stats_export_json = 'Export to JSON',
    stats_filter_dates = 'Filter by Date Range',
    stats_refresh = 'Refresh Data',
    
    -- v3.0 Multi-Language
    language_select = 'Select Language',
    language_changed = 'Language changed to %s',
    
    -- v3.0 Custom Tiers
    custom_tier_create = 'Create Custom Tier',
    custom_tier_created = 'Custom citizenship tier created!',
    custom_tier_max_reached = 'Maximum custom tiers reached',
    
    -- v3.0 Tier Perks
    perk_activated = 'Tier perk activated: %s',
    perk_shop_discount = 'Shop discount applied: %s%%',
    perk_job_bonus = 'Job pay bonus: +%s%%',
    
    -- v3.0 Job Integration
    job_citizenship_required = 'This job requires citizenship',
    job_tier_required = 'This job requires %s tier or higher',
    job_bonus_active = 'Citizenship job bonus active',
    
    -- v3.0 Property Integration
    property_citizenship_required = 'Citizenship required to purchase property',
    property_discount_applied = 'Citizenship discount applied: %s%%',
    property_limit_reached = 'You have reached your property limit for your tier',
    
    -- v3.0 Criminal Records
    criminal_record_warning = 'Criminal record may affect citizenship approval',
    criminal_record_tier_denied = 'Criminal record prevents %s tier citizenship',
    criminal_appeal_prompt = 'Appeal Criminal Record',
    criminal_appeal_success = 'Criminal record appeal submitted',
}

-- Admin permissions
Config.AdminAce = 'admin' -- ACE permission required for approval commands

-- ============================================
-- v3.0 FEATURES
-- ============================================

-- 1. Actual Webcam Integration (v3.0)
Config.Webcam = {
    enabled = false, -- Enable actual webcam capture
    provider = 'html5', -- 'html5' or 'external' (requires external script)
    resolution = {width = 640, height = 480},
    quality = 0.8, -- JPEG quality (0.1 to 1.0)
    countdown = 3, -- Countdown before capture (seconds)
    retakeAllowed = true, -- Allow players to retake photos
    maxRetakes = 3, -- Maximum retakes allowed
    fallbackToCamera = true -- Fallback to in-game camera if webcam fails
}

-- 2. Photo Filters and Editing (v3.0)
Config.PhotoEditing = {
    enabled = true,
    filters = {
        {name = 'none', label = 'No Filter', css = 'none'},
        {name = 'sepia', label = 'Old West Sepia', css = 'sepia(80%) contrast(120%)'},
        {name = 'grayscale', label = 'Black & White', css = 'grayscale(100%)'},
        {name = 'vintage', label = 'Vintage', css = 'sepia(50%) contrast(110%) brightness(110%)'},
        {name = 'aged', label = 'Aged Photo', css = 'sepia(90%) contrast(130%) brightness(90%)'}
    },
    brightness = {enabled = true, min = 0.5, max = 1.5, default = 1.0},
    contrast = {enabled = true, min = 0.5, max = 1.5, default = 1.0},
    rotation = {enabled = true, angles = {0, 90, 180, 270}},
    crop = {enabled = true, aspectRatio = '1:1'}
}

-- 3. Multiple ID Card Designs per Tier (v3.0)
Config.CardDesigns = {
    enabled = true,
    designs = {
        Basic = {
            {name = 'classic', label = 'Classic Parchment', template = 'classic'},
            {name = 'simple', label = 'Simple Document', template = 'simple'}
        },
        Premium = {
            {name = 'classic', label = 'Classic Parchment', template = 'classic'},
            {name = 'ornate', label = 'Ornate Gold', template = 'ornate'},
            {name = 'leather', label = 'Leather Bound', template = 'leather'}
        },
        Elite = {
            {name = 'classic', label = 'Classic Parchment', template = 'classic'},
            {name = 'ornate', label = 'Ornate Gold', template = 'ornate'},
            {name = 'royal', label = 'Royal Decree', template = 'royal'},
            {name = 'platinum', label = 'Platinum Edition', template = 'platinum'}
        }
    },
    allowChange = true, -- Allow changing design after issuance
    changeFee = 25.0
}

-- 4. Family Tier Packages (v3.0)
Config.FamilyTiers = {
    enabled = true,
    packages = {
        {
            name = 'Family Basic',
            label = 'Family Basic Package',
            minMembers = 2,
            maxMembers = 4,
            pricePerMember = 40.0, -- Discounted from $50
            benefits = {
                'All Basic benefits',
                'Family discount (20% off individual price)',
                'Shared family bond status',
                'Family tier badge on ID'
            },
            color = '#8b6f47',
            badge = '👨‍👩‍👧‍👦'
        },
        {
            name = 'Family Premium',
            label = 'Family Premium Package',
            minMembers = 2,
            maxMembers = 6,
            pricePerMember = 120.0, -- Discounted from $150
            benefits = {
                'All Premium benefits',
                'Family discount (20% off individual price)',
                'Shared family properties access',
                'Family tier badge on ID',
                'Priority family services'
            },
            color = '#b8860b',
            badge = '👨‍👩‍👧‍👦⭐'
        }
    },
    requireFamilyScript = false, -- Requires external family/gang script
    sharedBenefits = true -- Family members share tier benefits
}

-- 5. Seasonal Tier Bonuses (v3.0)
Config.SeasonalBonuses = {
    enabled = true,
    seasons = {
        {
            name = 'winter',
            label = 'Winter Festival',
            startMonth = 12, -- December
            endMonth = 2, -- February
            bonuses = {
                Basic = {discount = 0.10, bonus = 'Winter warmth supplies'},
                Premium = {discount = 0.15, bonus = 'Premium winter gear'},
                Elite = {discount = 0.25, bonus = 'Elite winter estate access'}
            },
            badge = '❄️'
        },
        {
            name = 'spring',
            label = 'Spring Renewal',
            startMonth = 3, -- March
            endMonth = 5, -- May
            bonuses = {
                Basic = {discount = 0.05, bonus = 'Spring planting bonus'},
                Premium = {discount = 0.10, bonus = 'Premium farm access'},
                Elite = {discount = 0.20, bonus = 'Elite ranch privileges'}
            },
            badge = '🌸'
        },
        {
            name = 'summer',
            label = 'Summer Prosperity',
            startMonth = 6, -- June
            endMonth = 8, -- August
            bonuses = {
                Basic = {discount = 0.05, bonus = 'Summer trade bonus'},
                Premium = {discount = 0.10, bonus = 'Premium trading routes'},
                Elite = {discount = 0.20, bonus = 'Elite commerce rights'}
            },
            badge = '☀️'
        },
        {
            name = 'autumn',
            label = 'Autumn Harvest',
            startMonth = 9, -- September
            endMonth = 11, -- November
            bonuses = {
                Basic = {discount = 0.10, bonus = 'Harvest festival access'},
                Premium = {discount = 0.15, bonus = 'Premium harvest rights'},
                Elite = {discount = 0.25, bonus = 'Elite autumn gala'}
            },
            badge = '🍂'
        }
    },
    applyToRenewals = true,
    applyToUpgrades = true
}

-- 6. Advanced Statistics (v3.0)
Config.AdvancedStatistics = {
    enabled = true,
    features = {
        charts = true, -- Enable visual charts
        graphs = true, -- Enable trend graphs
        exports = true, -- Enable data exports
        filtering = true, -- Enable date range filtering
        realtime = true -- Enable real-time updates
    },
    exportFormats = {
        csv = true,
        json = true,
        pdf = false -- Requires external library
    },
    charts = {
        applicationsOverTime = true,
        tierDistribution = true,
        approvalRate = true,
        renewalTrends = true,
        seasonalActivity = true
    },
    refreshInterval = 30000 -- Auto-refresh every 30 seconds (ms)
}

-- 7. Multi-Language Support (v3.0)
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
    allowPlayerSelection = true, -- Let players choose their language
    savePreference = true -- Remember player's language choice
}

-- 8. Custom Tier Creation via Config (v3.0)
Config.CustomTiers = {
    enabled = true,
    allowAdminCreation = true, -- Admins can create tiers in-game
    tiers = {
        -- Example custom tier
        -- {
        --     name = 'Merchant',
        --     label = 'Merchant Citizenship',
        --     price = 200.0,
        --     benefits = {
        --         'All Basic benefits',
        --         'Reduced market fees',
        --         'Merchant guild access',
        --         'Priority trading permits'
        --     },
        --     color = '#cd7f32',
        --     badge = '💰',
        --     requiredJob = 'merchant', -- Optional job requirement
        --     requiredLevel = 5 -- Optional level requirement
        -- }
    },
    maxCustomTiers = 10 -- Maximum number of custom tiers
}

-- 9. Tier-Specific Perks API (v3.0)
Config.TierPerks = {
    enabled = true,
    perks = {
        Basic = {
            shopDiscounts = 0.0,
            jobPayBonus = 0.0,
            housingDiscount = 0.0,
            fastTravel = false,
            customEmotes = {},
            customClothing = {}
        },
        Premium = {
            shopDiscounts = 0.10, -- 10% discount
            jobPayBonus = 0.05, -- 5% pay bonus
            housingDiscount = 0.10,
            fastTravel = true,
            customEmotes = {'premium_wave', 'premium_salute'},
            customClothing = {'premium_badge'}
        },
        Elite = {
            shopDiscounts = 0.25, -- 25% discount
            jobPayBonus = 0.15, -- 15% pay bonus
            housingDiscount = 0.25,
            fastTravel = true,
            customEmotes = {'elite_wave', 'elite_salute', 'elite_bow'},
            customClothing = {'elite_badge', 'elite_sash'}
        }
    },
    exportForOtherScripts = true, -- Export functions for other scripts to check tier
    webhookPerkUsage = false -- Log perk usage to Discord
}

-- 10. Integration with Job Systems (v3.0)
Config.JobIntegration = {
    enabled = true,
    framework = 'rsg-core', -- 'rsg-core', 'qbr-core', 'qbx-core', 'custom'
    features = {
        jobRequirements = true, -- Certain jobs require citizenship
        jobBonuses = true, -- Citizenship tier affects job pay
        governmentJobs = { -- Jobs that require citizenship
            'police', 'doctor', 'judge', 'mayor', 'lawyer'
        },
        tierJobBonuses = {
            Basic = 0.0,
            Premium = 0.05, -- 5% job pay bonus
            Elite = 0.15 -- 15% job pay bonus
        }
    },
    restrictedJobs = true, -- Some jobs require minimum tier
    jobTierRequirements = {
        police = 'Basic',
        doctor = 'Basic',
        judge = 'Premium',
        mayor = 'Elite'
    }
}

-- 11. Integration with Property Systems (v3.0)
Config.PropertyIntegration = {
    enabled = true,
    framework = 'rsg-housing', -- 'rsg-housing', 'qbr-housing', 'custom'
    features = {
        purchaseRequirement = true, -- Require citizenship to buy property
        tierDiscounts = true, -- Tier affects property prices
        tierLimits = true -- Tier affects number of properties
    },
    discounts = {
        Basic = 0.0,
        Premium = 0.10, -- 10% discount on property purchases
        Elite = 0.25 -- 25% discount on property purchases
    },
    propertyLimits = {
        none = 0, -- Non-citizens can't own property
        Basic = 1,
        Premium = 3,
        Elite = 10 -- Elite citizens can own up to 10 properties
    },
    taxReduction = {
        Basic = 0.0,
        Premium = 0.15, -- 15% tax reduction
        Elite = 0.30 -- 30% tax reduction
    }
}

-- 12. Criminal Record Integration (v3.0)
Config.CriminalRecords = {
    enabled = true,
    framework = 'rsg-lawman', -- 'rsg-lawman', 'qbr-policejob', 'custom'
    features = {
        showOnID = true, -- Show criminal status on ID card
        affectApproval = true, -- Criminals may be denied citizenship
        tierRestrictions = true, -- Criminals can't get high tiers
        recordExpiry = true -- Records expire after time
    },
    maxCrimesForCitizenship = 5, -- Max crimes allowed for Basic citizenship
    tierCrimeLimits = {
        Basic = 5,
        Premium = 2,
        Elite = 0 -- Elite tier requires clean record
    },
    crimeTypes = {
        minor = {weight = 1, label = 'Minor Offense'},
        moderate = {weight = 3, label = 'Moderate Crime'},
        serious = {weight = 5, label = 'Serious Crime'},
        felony = {weight = 10, label = 'Felony'}
    },
    recordExpiryDays = 90, -- Records older than 90 days are cleared
    allowAppeals = true, -- Players can appeal criminal record
    appealFee = 100.0
}
