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
}

-- Admin permissions
Config.AdminAce = 'admin' -- ACE permission required for approval commands
