local RSGCore = exports['rsg-core']:GetCoreObject()
local isShowingCard = false
local isTakingPhoto = false
local currentCamera = nil
local inspectionTarget = nil

-- Debug print function
local function DebugPrint(message)
    if Config.Debug then
        print('^3[TLW-IDCard]^7 ' .. message)
    end
end

-- Phase 1: Camera Functions
local function TakePhotoWithCamera()
    if isTakingPhoto then return end
    isTakingPhoto = true
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    
    -- Calculate camera position in front of player
    local forwardVector = GetEntityForwardVector(playerPed)
    local cameraCoords = vector3(
        playerCoords.x + (forwardVector.x * Config.Camera.offsetForward),
        playerCoords.y + (forwardVector.y * Config.Camera.offsetForward),
        playerCoords.z + Config.Camera.offsetUp
    )
    
    -- Create camera
    currentCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(currentCamera, cameraCoords.x, cameraCoords.y, cameraCoords.z)
    PointCamAtCoord(currentCamera, playerCoords.x, playerCoords.y, playerCoords.z + 0.6)
    SetCamFov(currentCamera, Config.Camera.fov)
    SetCamActive(currentCamera, true)
    RenderScriptCams(true, true, 500, true, true)
    
    -- Notify player
    RSGCore.Functions.Notify(Config.Locale.camera_smile, 'primary', 3000)
    
    -- Wait for photo duration
    Wait(Config.Camera.duration)
    
    -- In a real implementation, you would capture the screen here
    -- For now, we'll generate a placeholder identifier
    local photoData = nil
    if Config.Camera.storeAsBase64 then
        -- This would be replaced with actual screen capture
        photoData = 'mugshot_' .. GetPlayerServerId(PlayerId()) .. '_' .. os.time()
    end
    
    -- Cleanup camera
    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(currentCamera, false)
    currentCamera = nil
    isTakingPhoto = false
    
    -- Notify success
    RSGCore.Functions.Notify(Config.Locale.camera_success, 'success')
    
    return photoData
end

-- Phase 2: ID Inspection Functions
local function RequestIDInspection(targetPlayer)
    if not Config.Inspection.enabled then return end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    local targetCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(targetPlayer)))
    local distance = #(playerCoords - targetCoords)
    
    if distance > Config.Inspection.maxDistance then
        RSGCore.Functions.Notify(Config.Locale.inspection_too_far, 'error')
        return
    end
    
    TriggerServerEvent('tlw_idcard:server:requestInspection', targetPlayer)
end

local function ShowOtherPlayerID(cardData)
    if isShowingCard then return end
    
    isShowingCard = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showCard',
        data = cardData,
        locale = Config.Locale,
        territory = Config.TerritoryName,
        governor = Config.GovernorName,
        isInspection = true
    })
end

-- Create blips for locations
CreateThread(function()
    -- Photographer blips
    for _, location in pairs(Config.PhotographerLocations) do
        if location.blip then
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, location.coords.x, location.coords.y, location.coords.z)
            SetBlipSprite(blip, Config.Blips.photographer.sprite, true)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.Blips.photographer.prompt)
            Citizen.InvokeNative(0x662D364ABF16DE2F, blip, Config.Blips.photographer.color)
        end
    end
    
    -- Government office blips
    for _, location in pairs(Config.GovernmentOffices) do
        if location.blip then
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, location.coords.x, location.coords.y, location.coords.z)
            SetBlipSprite(blip, Config.Blips.government.sprite, true)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.Blips.government.prompt)
            Citizen.InvokeNative(0x662D364ABF16DE2F, blip, Config.Blips.government.color)
        end
    end
end)

-- Setup ox_target zones for photographers
CreateThread(function()
    for i, location in pairs(Config.PhotographerLocations) do
        exports.ox_target:addSphereZone({
            coords = location.coords,
            radius = 2.0,
            debug = Config.Debug,
            options = {
                {
                    name = 'tlw_photographer_' .. i,
                    label = Config.Locale.photographer_prompt .. ' ($' .. Config.PhotoFee .. ')',
                    icon = 'fa-solid fa-camera',
                    onSelect = function()
                        if Config.Camera.enabled then
                            local photoData = TakePhotoWithCamera()
                            TriggerServerEvent('tlw_idcard:server:takePhoto', photoData)
                        else
                            TriggerServerEvent('tlw_idcard:server:takePhoto')
                        end
                    end
                }
            }
        })
    end
end)

-- Setup ox_target zones for government offices
CreateThread(function()
    for i, location in pairs(Config.GovernmentOffices) do
        local options = {
            {
                name = 'tlw_government_apply_' .. i,
                label = Config.Locale.government_prompt .. ' ($' .. Config.ApplicationFee .. ')',
                icon = 'fa-solid fa-file-signature',
                canInteract = function()
                    return exports['rsg-inventory']:HasItem(Config.Items.photo, 1)
                end,
                onSelect = function()
                    OpenApplicationForm()
                end
            }
        }
        
        -- Phase 3: Add replacement option
        if Config.Replacement.enabled then
            table.insert(options, {
                name = 'tlw_government_replace_' .. i,
                label = Config.Locale.replacement_prompt .. ' ($' .. Config.Replacement.fee .. ')',
                icon = 'fa-solid fa-id-card',
                canInteract = function()
                    return exports['rsg-inventory']:HasItem(Config.Items.idCitizen, 1) or 
                           exports['rsg-inventory']:HasItem(Config.Items.idPending, 1)
                end,
                onSelect = function()
                    TriggerServerEvent('tlw_idcard:server:requestReplacement')
                end
            })
        end
        
        -- Phase 4: Add renewal option
        if Config.Expiration.enabled then
            table.insert(options, {
                name = 'tlw_government_renew_' .. i,
                label = Config.Locale.renewal_prompt .. ' ($' .. Config.Expiration.renewalFee .. ')',
                icon = 'fa-solid fa-rotate',
                canInteract = function()
                    return exports['rsg-inventory']:HasItem(Config.Items.idCitizen, 1)
                end,
                onSelect = function()
                    TriggerServerEvent('tlw_idcard:server:requestRenewal')
                end
            })
        end
        
        -- Phase 5: Add tier upgrade option
        if Config.Tiers.enabled and Config.Tiers.allowUpgrade then
            table.insert(options, {
                name = 'tlw_government_upgrade_' .. i,
                label = Config.Locale.tier_upgrade_prompt,
                icon = 'fa-solid fa-arrow-up',
                canInteract = function()
                    return exports['rsg-inventory']:HasItem(Config.Items.idCitizen, 1)
                end,
                onSelect = function()
                    OpenTierUpgradeMenu()
                end
            })
        end
        
        exports.ox_target:addSphereZone({
            coords = location.coords,
            radius = 2.0,
            debug = Config.Debug,
            options = options
        })
    end
end)

-- Open Application Form
function OpenApplicationForm()
    DebugPrint('Opening application form')
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openForm',
        locale = Config.Locale,
        fields = Config.FormFields
    })
end

-- Show ID Card
function ShowIDCard(itemData)
    if isShowingCard then return end
    
    DebugPrint('Showing ID card')
    
    RSGCore.Functions.TriggerCallback('tlw_idcard:server:getCardData', function(cardData)
        if not cardData then 
            DebugPrint('Failed to get card data')
            return 
        end
        
        isShowingCard = true
        
        -- Play animation
        local playerPed = PlayerPedId()
        TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_WRITE_NOTEBOOK'), 0, true, false, false, false)
        
        -- Show card UI
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'showCard',
            data = cardData,
            locale = Config.Locale,
            territory = Config.TerritoryName,
            governor = Config.GovernorName
        })
        
        -- Play sound if enabled
        if Config.Sounds.enabled then
            -- You can add custom sound here if you have audio files
            -- PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true)
        end
    end, itemData)
end

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    DebugPrint('Closing NUI')
    SetNuiFocus(false, false)
    
    if isShowingCard then
        -- Stop animation
        local playerPed = PlayerPedId()
        ClearPedTasks(playerPed)
        isShowingCard = false
    end
    
    cb('ok')
end)

RegisterNUICallback('submitApplication', function(data, cb)
    DebugPrint('Submitting application')
    SetNuiFocus(false, false)
    TriggerServerEvent('tlw_idcard:server:submitApplication', data)
    cb('ok')
end)

-- Usable Item Events (register these in rsg-inventory or call from inventory)
RegisterNetEvent('tlw_idcard:client:showPendingID', function(itemData)
    ShowIDCard(itemData)
end)

RegisterNetEvent('tlw_idcard:client:showCitizenID', function(itemData)
    ShowIDCard(itemData)
end)

-- Exports for other resources
exports('ShowIDCard', ShowIDCard)
exports('OpenApplicationForm', OpenApplicationForm)

-- Phase 5: Tier Upgrade Menu
function OpenTierUpgradeMenu()
    local options = {}
    
    for _, tier in ipairs(Config.Tiers.tiers) do
        table.insert(options, {
            title = tier.label,
            description = 'Price: $' .. tier.price .. '\n' .. table.concat(tier.benefits, '\n'),
            icon = tier.badge,
            onSelect = function()
                TriggerServerEvent('tlw_idcard:server:upgradeTier', tier.name)
            end
        })
    end
    
    lib.registerContext({
        id = 'tier_upgrade_menu',
        title = 'Citizenship Tier Upgrade',
        options = options
    })
    
    lib.showContext('tier_upgrade_menu')
end

-- Phase 2: Nearby Player ID Inspection with ox_target
CreateThread(function()
    if not Config.Inspection.enabled then return end
    
    exports.ox_target:addGlobalPlayer({
        {
            name = 'tlw_inspect_id',
            label = Config.Locale.inspection_prompt,
            icon = 'fa-solid fa-eye',
            distance = Config.Inspection.maxDistance,
            canInteract = function(entity, distance, coords)
                -- Check if target player is showing their ID
                if Config.Inspection.requireIDInHand then
                    -- This would need additional tracking of who is showing ID
                    return distance <= Config.Inspection.maxDistance
                end
                return true
            end,
            onSelect = function(data)
                local targetPlayer = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                if targetPlayer and targetPlayer > 0 then
                    RequestIDInspection(targetPlayer)
                end
            end
        }
    })
end)

-- Phase 2: Handle inspection requests
RegisterNetEvent('tlw_idcard:client:receiveInspectionRequest', function(requesterName, requesterId)
    if not Config.Inspection.enabled then return end
    
    if Config.Inspection.allowDenial then
        local alert = lib.alertDialog({
            header = 'ID Inspection Request',
            content = string.format(Config.Locale.inspection_request_received, requesterName),
            centered = true,
            cancel = true,
            labels = {
                confirm = 'Allow',
                cancel = 'Deny'
            }
        })
        
        if alert == 'confirm' then
            TriggerServerEvent('tlw_idcard:server:acceptInspection', requesterId)
        else
            TriggerServerEvent('tlw_idcard:server:denyInspection', requesterId)
        end
    else
        -- Auto-accept if denial not allowed
        TriggerServerEvent('tlw_idcard:server:acceptInspection', requesterId)
    end
end)

-- Phase 2: Show inspection result
RegisterNetEvent('tlw_idcard:client:showInspectionResult', function(cardData)
    ShowOtherPlayerID(cardData)
end)

-- Phase 4: Check ID expiration when showing
RegisterNetEvent('tlw_idcard:client:checkExpiration', function(expirationDate, daysLeft)
    if not Config.Expiration.enabled then return end
    
    if daysLeft <= 0 then
        RSGCore.Functions.Notify(Config.Locale.expiration_expired, 'error', 5000)
        if not Config.Expiration.allowExpiredUse then
            return -- Don't show expired ID
        end
    elseif daysLeft <= Config.Expiration.warningDays then
        RSGCore.Functions.Notify(string.format(Config.Locale.expiration_warning, daysLeft), 'primary', 5000)
    end
end)

-- Phase 6: Statistics Dashboard Display
RegisterNetEvent('tlw_idcard:client:showStatistics', function(stats)
    if not Config.Statistics.enabled then return end
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showStatistics',
        data = stats,
        locale = Config.Locale
    })
end)
