local RSGCore = exports['rsg-core']:GetCoreObject()
local playerCooldowns = {}

-- Debug print function
local function DebugPrint(message)
    if Config.Debug then
        print('^3[TLW-IDCard]^7 ' .. message)
    end
end

-- Helper function to check cooldown
local function IsOnCooldown(source, cooldownType)
    if not playerCooldowns[source] then
        playerCooldowns[source] = {}
    end
    
    if playerCooldowns[source][cooldownType] then
        local timeLeft = playerCooldowns[source][cooldownType] - os.time()
        if timeLeft > 0 then
            return true, timeLeft
        end
    end
    
    return false, 0
end

-- Helper function to set cooldown
local function SetCooldown(source, cooldownType, duration)
    if not playerCooldowns[source] then
        playerCooldowns[source] = {}
    end
    playerCooldowns[source][cooldownType] = os.time() + duration
end

-- Initialize database
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS tlw_id_applications (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizenid VARCHAR(50) NOT NULL,
            data LONGTEXT NOT NULL,
            status VARCHAR(20) DEFAULT 'pending',
            approved_by VARCHAR(50),
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_citizenid (citizenid),
            INDEX idx_status (status)
        )
    ]])
    DebugPrint('Database initialized successfully')
end)

-- Take Photo Event
RegisterNetEvent('tlw_idcard:server:takePhoto', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check cooldown
    local onCooldown, timeLeft = IsOnCooldown(src, 'photo')
    if onCooldown then
        RSGCore.Functions.Notify(src, string.format(Config.Locale.photographer_cooldown .. ' (%ds)', timeLeft), 'error')
        return
    end
    
    -- Check if player has enough money
    if Player.PlayerData.money.cash < Config.PhotoFee then
        RSGCore.Functions.Notify(src, string.format(Config.Locale.photographer_insufficient_funds, Config.PhotoFee), 'error')
        return
    end
    
    -- Remove money
    Player.Functions.RemoveMoney('cash', Config.PhotoFee)
    
    -- Add photo item with metadata
    local info = {
        citizenid = Player.PlayerData.citizenid,
        firstname = Player.PlayerData.charinfo.firstname,
        lastname = Player.PlayerData.charinfo.lastname,
        timestamp = os.time()
    }
    
    exports['rsg-inventory']:AddItem(src, Config.Items.photo, 1, nil, info)
    RSGCore.Functions.Notify(src, Config.Locale.photographer_success, 'success')
    
    -- Set cooldown
    SetCooldown(src, 'photo', Config.Cooldowns.photo)
    
    DebugPrint('Photo taken by ' .. Player.PlayerData.name)
end)

-- Submit Application Event
RegisterNetEvent('tlw_idcard:server:submitApplication', function(formData)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check cooldown
    local onCooldown, timeLeft = IsOnCooldown(src, 'application')
    if onCooldown then
        RSGCore.Functions.Notify(src, string.format(Config.Locale.government_cooldown .. ' (%ds)', timeLeft), 'error')
        return
    end
    
    -- Check if player has photo plate
    local hasPhoto = exports['rsg-inventory']:HasItem(src, Config.Items.photo, 1)
    if not hasPhoto then
        RSGCore.Functions.Notify(src, Config.Locale.government_no_photo, 'error')
        return
    end
    
    -- Check if player has enough money
    if Player.PlayerData.money.cash < Config.ApplicationFee then
        RSGCore.Functions.Notify(src, string.format(Config.Locale.government_insufficient_funds, Config.ApplicationFee), 'error')
        return
    end
    
    -- Remove money and photo
    Player.Functions.RemoveMoney('cash', Config.ApplicationFee)
    exports['rsg-inventory']:RemoveItem(src, Config.Items.photo, 1)
    
    -- Prepare application data
    local applicationData = {
        citizenid = Player.PlayerData.citizenid,
        steamid = GetPlayerIdentifierByType(src, 'steam') or 'Unknown',
        license = GetPlayerIdentifierByType(src, 'license') or 'Unknown',
        playername = Player.PlayerData.name,
        charinfo = Player.PlayerData.charinfo,
        formdata = formData,
        timestamp = os.date('%Y-%m-%d %H:%M:%S')
    }
    
    -- Save to database
    MySQL.insert('INSERT INTO tlw_id_applications (citizenid, data, status) VALUES (?, ?, ?)', {
        Player.PlayerData.citizenid,
        json.encode(applicationData),
        'pending'
    })
    
    -- Send Discord webhook
    if Config.Discord.enabled and Config.Discord.webhook ~= 'YOUR_WEBHOOK_URL_HERE' then
        local embed = {
            {
                title = '🐺 New Citizenship Application',
                color = Config.Discord.color,
                fields = {
                    {name = 'Player Name', value = Player.PlayerData.name, inline = true},
                    {name = 'Citizen ID', value = Player.PlayerData.citizenid, inline = true},
                    {name = 'Server ID', value = tostring(src), inline = true},
                    {name = 'Character Name', value = formData.fullname or 'N/A', inline = true},
                    {name = 'Date of Birth', value = formData.birthdate or 'N/A', inline = true},
                    {name = 'Birthplace', value = formData.birthplace or 'N/A', inline = true},
                    {name = 'Occupation', value = formData.occupation or 'N/A', inline = true},
                    {name = 'Reason for Immigration', value = formData.reason or 'N/A', inline = false},
                    {name = 'Steam ID', value = applicationData.steamid, inline = false}
                },
                footer = {
                    text = 'Use /approveid ' .. src .. ' to approve this application'
                },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
            }
        }
        
        PerformHttpRequest(Config.Discord.webhook, function(err, text, headers) 
            DebugPrint('Discord webhook sent: ' .. tostring(err))
        end, 'POST', json.encode({
            username = Config.Discord.botName,
            avatar_url = Config.Discord.avatar,
            embeds = embed
        }), {['Content-Type'] = 'application/json'})
    end
    
    -- Give pending ID card
    local cardInfo = {
        citizenid = Player.PlayerData.citizenid,
        fullname = formData.fullname,
        birthdate = formData.birthdate,
        birthplace = formData.birthplace,
        occupation = formData.occupation,
        issued = os.date('%m/%d/%Y'),
        status = 'pending'
    }
    
    exports['rsg-inventory']:AddItem(src, Config.Items.idPending, 1, nil, cardInfo)
    
    RSGCore.Functions.Notify(src, Config.Locale.government_success, 'primary', 5000)
    RSGCore.Functions.Notify(src, Config.Locale.government_pending_received, 'success', 5000)
    
    -- Set cooldown
    SetCooldown(src, 'application', Config.Cooldowns.application)
    
    DebugPrint('Application submitted by ' .. Player.PlayerData.name)
end)

-- Get ID Card Data
RSGCore.Functions.CreateCallback('tlw_idcard:server:getCardData', function(source, cb, itemData)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then 
        cb(nil)
        return 
    end
    
    local cardData = {
        citizenid = Player.PlayerData.citizenid,
        fullname = itemData.info.fullname or (Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname),
        birthdate = itemData.info.birthdate or Player.PlayerData.charinfo.birthdate or 'Unknown',
        birthplace = itemData.info.birthplace or Player.PlayerData.charinfo.birthplace or 'Unknown',
        occupation = itemData.info.occupation or 'Unemployed',
        issued = itemData.info.issued or os.date('%m/%d/%Y'),
        status = itemData.info.status or 'pending'
    }
    
    cb(cardData)
end)

-- Admin Approve Command
RSGCore.Commands.Add('approveid', 'Approve a citizenship application', {{name = 'id', help = 'Player Server ID'}}, true, function(source, args)
    local targetId = tonumber(args[1])
    
    if not targetId then
        RSGCore.Functions.Notify(source, 'Invalid player ID', 'error')
        return
    end
    
    local TargetPlayer = RSGCore.Functions.GetPlayer(targetId)
    
    if not TargetPlayer then
        RSGCore.Functions.Notify(source, Config.Locale.approval_not_found, 'error')
        return
    end
    
    -- Check if player has pending ID
    local hasPendingID = exports['rsg-inventory']:HasItem(targetId, Config.Items.idPending, 1)
    
    if not hasPendingID then
        RSGCore.Functions.Notify(source, 'Player does not have a pending ID card', 'error')
        return
    end
    
    -- Get the pending ID card info
    local pendingCard = exports['rsg-inventory']:GetItemByName(targetId, Config.Items.idPending)
    
    if not pendingCard then
        RSGCore.Functions.Notify(source, 'Could not retrieve pending ID card data', 'error')
        return
    end
    
    -- Remove pending ID
    exports['rsg-inventory']:RemoveItem(targetId, Config.Items.idPending, 1)
    
    -- Create citizen ID with same data but approved status
    local citizenInfo = pendingCard.info or {}
    citizenInfo.status = 'approved'
    citizenInfo.approved_date = os.date('%m/%d/%Y')
    
    -- Give citizen ID
    exports['rsg-inventory']:AddItem(targetId, Config.Items.idCitizen, 1, nil, citizenInfo)
    
    -- Update database
    local AdminPlayer = RSGCore.Functions.GetPlayer(source)
    MySQL.update('UPDATE tlw_id_applications SET status = ?, approved_by = ? WHERE citizenid = ? AND status = ?', {
        'approved',
        AdminPlayer and AdminPlayer.PlayerData.citizenid or 'Console',
        TargetPlayer.PlayerData.citizenid,
        'pending'
    })
    
    -- Notify both players
    RSGCore.Functions.Notify(targetId, Config.Locale.approval_success, 'success', 7000)
    RSGCore.Functions.Notify(source, string.format(Config.Locale.approval_admin_success, TargetPlayer.PlayerData.name), 'success')
    
    DebugPrint('Citizenship approved for ' .. TargetPlayer.PlayerData.name .. ' by admin ' .. (AdminPlayer and AdminPlayer.PlayerData.name or 'Console'))
end, Config.AdminAce)

-- Admin Deny Command (optional)
RSGCore.Commands.Add('denyid', 'Deny a citizenship application', {{name = 'id', help = 'Player Server ID'}}, true, function(source, args)
    local targetId = tonumber(args[1])
    
    if not targetId then
        RSGCore.Functions.Notify(source, 'Invalid player ID', 'error')
        return
    end
    
    local TargetPlayer = RSGCore.Functions.GetPlayer(targetId)
    
    if not TargetPlayer then
        RSGCore.Functions.Notify(source, 'Player not found', 'error')
        return
    end
    
    -- Remove pending ID
    exports['rsg-inventory']:RemoveItem(targetId, Config.Items.idPending, 1)
    
    -- Update database
    MySQL.update('UPDATE tlw_id_applications SET status = ? WHERE citizenid = ? AND status = ?', {
        'denied',
        TargetPlayer.PlayerData.citizenid,
        'pending'
    })
    
    -- Notify both players
    RSGCore.Functions.Notify(targetId, 'Your citizenship application has been denied. You may reapply.', 'error', 7000)
    RSGCore.Functions.Notify(source, 'Application denied for ' .. TargetPlayer.PlayerData.name, 'success')
    
    DebugPrint('Citizenship denied for ' .. TargetPlayer.PlayerData.name)
end, Config.AdminAce)

-- Clean up cooldowns on player drop
AddEventHandler('playerDropped', function()
    local src = source
    if playerCooldowns[src] then
        playerCooldowns[src] = nil
    end
end)
