local RSGCore = exports['rsg-core']:GetCoreObject()
local isShowingCard = false

-- Debug print function
local function DebugPrint(message)
    if Config.Debug then
        print('^3[TLW-IDCard]^7 ' .. message)
    end
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
                        TriggerServerEvent('tlw_idcard:server:takePhoto')
                    end
                }
            }
        })
    end
end)

-- Setup ox_target zones for government offices
CreateThread(function()
    for i, location in pairs(Config.GovernmentOffices) do
        exports.ox_target:addSphereZone({
            coords = location.coords,
            radius = 2.0,
            debug = Config.Debug,
            options = {
                {
                    name = 'tlw_government_' .. i,
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
