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
    application = 300 -- 5 minutes between applications
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
    
    -- Form
    form_title = 'Citizenship Application',
    form_subtitle = 'The Land of Wolves - Territorial Governor\'s Office',
    form_submit = 'Submit Application',
    form_cancel = 'Cancel',
    form_validation_error = 'Please fill in all required fields',
}

-- Admin permissions
Config.AdminAce = 'admin' -- ACE permission required for approval commands
