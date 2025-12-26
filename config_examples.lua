--[[
    CONFIGURATION EXAMPLES
    The Land of Wolves - IDCard System
    
    This file contains various configuration examples for different scenarios.
    Copy these to your config.lua and modify as needed.
]]--

-- ============================================================================
-- EXAMPLE 1: Multiple Locations Setup
-- ============================================================================

--[[
-- For servers with multiple towns, set up photographers and offices in each:

Config.PhotographerLocations = {
    -- Valentine
    {
        name = "Valentine Photographer",
        coords = vector3(-173.61, 627.16, 114.09),
        heading = 90.0,
        blip = true
    },
    -- Saint Denis
    {
        name = "Saint Denis Photographer",
        coords = vector3(2736.35, -1226.26, 49.37),
        heading = 180.0,
        blip = true
    },
    -- Blackwater
    {
        name = "Blackwater Photographer",
        coords = vector3(-813.48, -1277.43, 43.63),
        heading = 270.0,
        blip = true
    },
    -- Rhodes
    {
        name = "Rhodes Photographer",
        coords = vector3(1228.89, -1293.54, 76.03),
        heading = 0.0,
        blip = true
    }
}

Config.GovernmentOffices = {
    -- Valentine Town Hall
    {
        name = "Valentine Clerk Office",
        coords = vector3(-275.96, 780.13, 118.50),
        heading = 180.0,
        blip = true
    },
    -- Saint Denis City Hall
    {
        name = "Saint Denis Immigration Office",
        coords = vector3(2518.29, -1308.92, 48.96),
        heading = 90.0,
        blip = true
    },
    -- Blackwater Government Building
    {
        name = "Blackwater Federal Office",
        coords = vector3(-760.85, -1268.38, 43.83),
        heading = 0.0,
        blip = true
    }
}
]]--


-- ============================================================================
-- EXAMPLE 2: Economy Adjustments
-- ============================================================================

--[[
-- For hardcore RP servers with higher prices:

Config.PhotoFee = 50.0          -- Higher photo cost
Config.ApplicationFee = 150.0   -- Significant citizenship fee
Config.Cooldowns = {
    photo = 300,        -- 5 minutes between photos
    application = 3600  -- 1 hour between applications (prevent spam)
}

-- For more casual/accessible servers:

Config.PhotoFee = 10.0
Config.ApplicationFee = 25.0
Config.Cooldowns = {
    photo = 30,         -- 30 seconds
    application = 120   -- 2 minutes
}

-- For completely free (testing or specific events):

Config.PhotoFee = 0.0
Config.ApplicationFee = 0.0
Config.Cooldowns = {
    photo = 0,
    application = 0
}
]]--


-- ============================================================================
-- EXAMPLE 3: Custom Territory Branding
-- ============================================================================

--[[
-- For different server themes:

-- Wild West Outlaws
Config.TerritoryName = "The Badlands Territory"
Config.GovernorName = "Sheriff of the Badlands"

-- Native American Theme
Config.TerritoryName = "The Sacred Lands"
Config.GovernorName = "Tribal Council"

-- Mining Town
Config.TerritoryName = "New Prosperity Mining Territory"
Config.GovernorName = "Mining Commissioner"

-- Ranching Community
Config.TerritoryName = "Heartland Ranch Territory"
Config.GovernorName = "Ranchers Association"

-- Confederate Territory
Config.TerritoryName = "The Southern Territory"
Config.GovernorName = "Territorial Governor"
]]--


-- ============================================================================
-- EXAMPLE 4: Discord Webhook Customization
-- ============================================================================

--[[
-- Professional server setup:
Config.Discord = {
    enabled = true,
    webhook = 'https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE',
    botName = 'Immigration Services',
    avatar = 'https://i.imgur.com/your-avatar.png',
    color = 3066993  -- Green color
}

-- Outlaw/Dark theme:
Config.Discord = {
    enabled = true,
    webhook = 'https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE',
    botName = 'The Land of Wolves - Territorial Court',
    avatar = 'https://i.imgur.com/wolf-avatar.png',
    color = 8388608  -- Dark red
}

-- Disable Discord (process applications in-game only):
Config.Discord = {
    enabled = false,
    webhook = '',
    botName = '',
    avatar = '',
    color = 0
}
]]--


-- ============================================================================
-- EXAMPLE 5: Custom Locale for Different Languages
-- ============================================================================

--[[
-- Spanish Example:
Config.Locale = {
    photographer_prompt = 'Tomar Foto de Identificación',
    photographer_busy = 'El fotógrafo está ocupado con otro cliente',
    photographer_cooldown = 'Debe esperar antes de tomar otra foto',
    photographer_insufficient_funds = 'Necesita $%s para tomar una foto',
    photographer_success = '¡Foto tomada! Recibió una Placa Fotográfica.',
    
    government_prompt = 'Solicitar Ciudadanía',
    government_no_photo = 'Necesita una Placa Fotográfica para solicitar ciudadanía',
    government_cooldown = 'Debe esperar antes de enviar otra solicitud',
    government_insufficient_funds = 'Necesita $%s para la tarifa de solicitud',
    government_success = '¡Solicitud enviada! La Oficina del Gobernador revisará su dignidad...',
    government_pending_received = 'Recibió un Permiso de Residente. Espere aprobación para ciudadanía completa.',
    
    approval_success = '¡Ahora es reconocido como Ciudadano de La Tierra de los Lobos!',
    approval_admin_success = 'Ciudadanía aprobada para %s',
    approval_not_found = 'Jugador no encontrado o no tiene solicitud pendiente',
    
    card_title = 'LA TIERRA DE LOS LOBOS',
    card_subtitle = 'IDENTIFICACIÓN TERRITORIAL',
    card_pending = 'PERMISO DE RESIDENTE',
    card_pending_subtitle = 'PENDIENTE DE CIUDADANÍA COMPLETA',
    card_approved = 'APROBADO - CIUDADANO',
    
    form_title = 'Solicitud de Ciudadanía',
    form_subtitle = 'La Tierra de los Lobos - Oficina del Gobernador Territorial',
    form_submit = 'Enviar Solicitud',
    form_cancel = 'Cancelar',
    form_validation_error = 'Por favor complete todos los campos requeridos',
}

-- French Example:
Config.Locale = {
    photographer_prompt = 'Prendre une Photo d\'Identité',
    government_prompt = 'Demander la Citoyenneté',
    -- ... etc
}
]]--


-- ============================================================================
-- EXAMPLE 6: Form Fields Customization
-- ============================================================================

--[[
-- Extended form with more fields:
Config.FormFields = {
    {name = 'fullname', label = 'Full Name', type = 'text', required = true},
    {name = 'birthdate', label = 'Date of Birth', type = 'date', required = true},
    {name = 'birthplace', label = 'Birthplace', type = 'text', required = true},
    {name = 'height', label = 'Height (in feet)', type = 'text', required = false},
    {name = 'weight', label = 'Weight (in lbs)', type = 'text', required = false},
    {name = 'eyecolor', label = 'Eye Color', type = 'text', required = false},
    {name = 'occupation', label = 'Occupation', type = 'text', required = true},
    {name = 'criminal_record', label = 'Criminal Record', type = 'textarea', required = false},
    {name = 'reason', label = 'Reason for Immigration', type = 'textarea', required = true},
    {name = 'sponsor', label = 'Citizen Sponsor (if any)', type = 'text', required = false}
}

-- Minimal form:
Config.FormFields = {
    {name = 'fullname', label = 'Full Name', type = 'text', required = true},
    {name = 'birthdate', label = 'Date of Birth', type = 'date', required = true},
    {name = 'reason', label = 'Why do you seek citizenship?', type = 'textarea', required = true}
}
]]--


-- ============================================================================
-- EXAMPLE 7: Blip Customization
-- ============================================================================

--[[
-- Different blip styles:

-- Minimal blips (no map icons, only when close):
Config.Blips = {
    photographer = {
        sprite = 1012738501,
        color = 'BLIP_MODIFIER_MP_COLOR_32',
        scale = 0.0,  -- Hidden on map
        prompt = 'Photographer'
    },
    government = {
        sprite = -570356389,
        color = 'BLIP_MODIFIER_MP_COLOR_8',
        scale = 0.0,  -- Hidden on map
        prompt = 'Government Office'
    }
}

-- Larger, more visible blips:
Config.Blips = {
    photographer = {
        sprite = 1012738501,
        color = 'BLIP_MODIFIER_MP_COLOR_32',
        scale = 0.5,  -- Larger
        prompt = '📷 PHOTOGRAPHER'
    },
    government = {
        sprite = -570356389,
        color = 'BLIP_MODIFIER_MP_COLOR_8',
        scale = 0.5,  -- Larger
        prompt = '📋 CITIZENSHIP OFFICE'
    }
}
]]--


-- ============================================================================
-- EXAMPLE 8: Admin Permission Levels
-- ============================================================================

--[[
-- Different permission setups:

-- For servers using custom ACE:
Config.AdminAce = 'idcard.admin'

-- Then in server.cfg:
-- add_ace group.moderator idcard.admin allow
-- add_ace group.admin idcard.admin allow

-- For servers with tiered permissions:
Config.AdminAce = 'admin.level2'

-- For public servers (anyone can approve - NOT RECOMMENDED):
Config.AdminAce = ''  -- Empty string allows anyone

-- For specific job-based (requires additional code):
-- You would need to modify the command check to validate job
-- Example: if Player.PlayerData.job.name == 'government' then
]]--


-- ============================================================================
-- EXAMPLE 9: Debug Mode Setup
-- ============================================================================

--[[
-- During development:
Config.Debug = true  -- Shows all server/client prints

-- Production:
Config.Debug = false  -- Silent operation

-- Conditional debug (in server.cfg):
setr tlw_debug "true"

-- Then in config.lua:
Config.Debug = GetConvar('tlw_debug', 'false') == 'true'
]]--


-- ============================================================================
-- EXAMPLE 10: Integration with Job Systems
-- ============================================================================

--[[
-- If you want only government job players to handle approvals:

-- In server/main.lua, modify the approval command:

RSGCore.Commands.Add('approveid', 'Approve citizenship', {{name='id', help='Player ID'}}, true, function(source, args)
    local Player = RSGCore.Functions.GetPlayer(source)
    
    -- Check if player has government job
    if Player.PlayerData.job.name ~= 'government' then
        RSGCore.Functions.Notify(source, 'You must be a government employee', 'error')
        return
    end
    
    -- Check job grade (optional - only high ranking)
    if Player.PlayerData.job.grade.level < 3 then
        RSGCore.Functions.Notify(source, 'Insufficient government clearance', 'error')
        return
    end
    
    -- Continue with normal approval logic...
end, Config.AdminAce)
]]--


-- ============================================================================
-- Notes
-- ============================================================================

--[[
    Remember:
    
    1. Always backup config.lua before making changes
    2. Test configuration changes on a development server first
    3. Restart the resource after config changes (restart tlw_idcard)
    4. Check F8 console for any errors after restart
    5. Verify coordinates using /getcoords or similar commands
    6. Test the full flow: photo -> application -> approval
    
    For custom modifications beyond these examples, refer to:
    - README.md for general information
    - INSTALL.md for setup instructions
    - Source code comments for technical details
]]--
