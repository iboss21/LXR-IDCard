-- v3.0 Client-Side Features
local RSGCore = exports['rsg-core']:GetCoreObject()
local isEditingPhoto = false
local currentPhotoData = nil

-- ============================================
-- WEBCAM INTEGRATION (v3.0)
-- ============================================

function CaptureWebcamPhoto()
    if not Config.Webcam.enabled then
        return TakePhotoWithCamera() -- Fallback to in-game camera
    end
    
    -- Send NUI request to open webcam interface
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openWebcam',
        config = {
            resolution = Config.Webcam.resolution,
            quality = Config.Webcam.quality,
            countdown = Config.Webcam.countdown,
            retakeAllowed = Config.Webcam.retakeAllowed,
            maxRetakes = Config.Webcam.maxRetakes
        },
        locale = Config.Locale
    })
end

-- NUI Callback for webcam photo
RegisterNUICallback('webcamPhotoTaken', function(data, cb)
    SetNuiFocus(false, false)
    
    if data.success then
        currentPhotoData = data.photoData
        
        -- Open photo editor if enabled
        if Config.PhotoEditing.enabled then
            OpenPhotoEditor(currentPhotoData)
        else
            -- Send photo to server
            TriggerServerEvent('tlw_idcard:server:savePhoto', currentPhotoData)
        end
    else
        -- Fallback to in-game camera
        if Config.Webcam.fallbackToCamera then
            RSGCore.Functions.Notify(Config.Locale.webcam_failed, 'error')
            TakePhotoWithCamera()
        end
    end
    
    cb('ok')
end)

-- ============================================
-- PHOTO EDITING (v3.0)
-- ============================================

function OpenPhotoEditor(photoData)
    if not Config.PhotoEditing.enabled then return end
    
    isEditingPhoto = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openPhotoEditor',
        photoData = photoData,
        config = Config.PhotoEditing,
        locale = Config.Locale
    })
end

-- NUI Callback for photo editing complete
RegisterNUICallback('photoEditComplete', function(data, cb)
    SetNuiFocus(false, false)
    isEditingPhoto = false
    
    if data.confirmed then
        currentPhotoData = data.editedPhoto
        TriggerServerEvent('tlw_idcard:server:savePhoto', currentPhotoData)
    end
    
    cb('ok')
end)

-- ============================================
-- CARD DESIGN SELECTION (v3.0)
-- ============================================

function OpenCardDesignSelector(tier)
    if not Config.CardDesigns.enabled then return end
    
    local designs = Config.CardDesigns.designs[tier]
    if not designs then return end
    
    local options = {}
    for _, design in ipairs(designs) do
        table.insert(options, {
            title = design.label,
            description = 'Select this design for your ID card',
            icon = 'id-card',
            onSelect = function()
                TriggerServerEvent('tlw_idcard:server:selectCardDesign', design.name)
            end
        })
    end
    
    lib.registerContext({
        id = 'card_design_menu',
        title = Config.Locale.card_design_select,
        options = options
    })
    
    lib.showContext('card_design_menu')
end

RegisterNetEvent('tlw_idcard:client:openDesignSelector', function(tier)
    OpenCardDesignSelector(tier)
end)

-- ============================================
-- LANGUAGE SELECTION (v3.0)
-- ============================================

function OpenLanguageSelector()
    if not Config.MultiLanguage.enabled then return end
    
    local options = {}
    for _, lang in ipairs(Config.MultiLanguage.availableLanguages) do
        table.insert(options, {
            title = lang.flag .. ' ' .. lang.label,
            description = 'Select ' .. lang.label,
            icon = 'language',
            onSelect = function()
                TriggerServerEvent('tlw_idcard:server:changeLanguage', lang.code)
            end
        })
    end
    
    lib.registerContext({
        id = 'language_menu',
        title = Config.Locale.language_select,
        options = options
    })
    
    lib.showContext('language_menu')
end

RegisterNetEvent('tlw_idcard:client:languageChanged', function(language, label)
    CurrentLocale = language
    RSGCore.Functions.Notify(string.format(Config.Locale.language_changed, label), 'success')
end)

-- Command to change language
RegisterCommand('idlanguage', function()
    OpenLanguageSelector()
end, false)

-- ============================================
-- FAMILY TIER CREATION (v3.0)
-- ============================================

function OpenFamilyTierMenu()
    if not Config.FamilyTiers.enabled then return end
    
    local options = {}
    for _, package in ipairs(Config.FamilyTiers.packages) do
        table.insert(options, {
            title = package.label,
            description = string.format('$%.2f per member (%d-%d members)', 
                package.pricePerMember, package.minMembers, package.maxMembers),
            icon = 'users',
            onSelect = function()
                OpenFamilyMemberSelector(package)
            end
        })
    end
    
    lib.registerContext({
        id = 'family_tier_menu',
        title = Config.Locale.family_tier_prompt,
        options = options
    })
    
    lib.showContext('family_tier_menu')
end

function OpenFamilyMemberSelector(package)
    -- This would integrate with a family/gang system
    -- For now, show a simple input for player IDs
    local input = lib.inputDialog('Select Family Members', {
        {
            type = 'multi-select',
            label = 'Family Members',
            description = string.format('Select %d-%d members', package.minMembers, package.maxMembers),
            required = true,
            options = GetNearbyPlayers() -- Would need implementation
        }
    })
    
    if input then
        TriggerServerEvent('tlw_idcard:server:createFamilyPackage', package.name, input[1])
    end
end

-- ============================================
-- SEASONAL BONUS DISPLAY (v3.0)
-- ============================================

function ShowSeasonalBonus()
    if not Config.SeasonalBonuses.enabled then return end
    
    local season = exports['tlw_idcard']:GetCurrentSeason()
    if season then
        RSGCore.Functions.Notify(
            string.format(Config.Locale.seasonal_bonus_active, season.label .. ' ' .. season.badge),
            'inform',
            5000
        )
    end
end

-- Check for seasonal bonuses on resource start
CreateThread(function()
    Wait(5000) -- Wait 5 seconds after resource start
    ShowSeasonalBonus()
end)

-- ============================================
-- ADVANCED STATISTICS UI (v3.0)
-- ============================================

RegisterNetEvent('tlw_idcard:client:showAdvancedStatistics', function(statsData)
    if not Config.AdvancedStatistics.enabled then return end
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showAdvancedStatistics',
        data = statsData,
        config = Config.AdvancedStatistics,
        locale = Config.Locale
    })
end)

-- NUI Callback for statistics export
RegisterNUICallback('exportStatistics', function(data, cb)
    TriggerServerEvent('tlw_idcard:server:exportStatistics', data.format, data.dateRange)
    cb('ok')
end)

-- ============================================
-- TIER PERKS NOTIFICATIONS (v3.0)
-- ============================================

RegisterNetEvent('tlw_idcard:client:perkActivated', function(perkName, value)
    if not Config.TierPerks.enabled then return end
    
    RSGCore.Functions.Notify(
        string.format(Config.Locale.perk_activated, perkName),
        'success',
        3000
    )
end)

-- ============================================
-- CRIMINAL RECORD DISPLAY (v3.0)
-- ============================================

function ShowCriminalRecordWarning(crimeCount)
    if not Config.CriminalRecords.enabled then return end
    if not Config.CriminalRecords.features.showOnID then return end
    
    if crimeCount > 0 then
        RSGCore.Functions.Notify(Config.Locale.criminal_record_warning, 'error', 5000)
    end
end

-- ============================================
-- CUSTOM TIER UPDATES (v3.0)
-- ============================================

RegisterNetEvent('tlw_idcard:client:updateCustomTiers', function(tiers)
    Config.Tiers.tiers = tiers
end)

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

function GetNearbyPlayers()
    local players = {}
    local myCoords = GetEntityCoords(PlayerPedId())
    
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local ped = GetPlayerPed(player)
            local coords = GetEntityCoords(ped)
            local distance = #(myCoords - coords)
            
            if distance < 10.0 then
                local serverId = GetPlayerServerId(player)
                table.insert(players, {
                    value = serverId,
                    label = GetPlayerName(player)
                })
            end
        end
    end
    
    return players
end

print('^2[TLW-IDCard v3.0]^7 Client features loaded successfully')
