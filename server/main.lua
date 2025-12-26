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

-- Phase 6: Statistics tracking helper
local function IncrementStatistic(metricType)
    if not Config.Statistics.enabled then return end
    if not Config.Statistics.trackMetrics[metricType] then return end
    
    MySQL.query([[
        INSERT INTO tlw_id_statistics (metric_type, metric_value, date)
        VALUES (?, 1, CURDATE())
        ON DUPLICATE KEY UPDATE metric_value = metric_value + 1
    ]], {metricType})
end

-- Phase 4: Helper to calculate expiration date
local function CalculateExpirationDate()
    if not Config.Expiration.enabled then return nil end
    return os.date('%Y-%m-%d %H:%M:%S', os.time() + Config.Expiration.duration)
end

-- Phase 4: Helper to check if ID is expired
local function IsIDExpired(expirationDate)
    if not Config.Expiration.enabled or not expirationDate then return false end
    local expTime = os.time({year=expirationDate:sub(1,4), month=expirationDate:sub(6,7), day=expirationDate:sub(9,10)})
    return os.time() > expTime
end

-- Initialize database
CreateThread(function()
    -- Main applications table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS tlw_id_applications (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizenid VARCHAR(50) NOT NULL,
            data LONGTEXT NOT NULL,
            status VARCHAR(20) DEFAULT 'pending',
            approved_by VARCHAR(50),
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            tier VARCHAR(20) DEFAULT 'Basic',
            expiration_date DATETIME,
            INDEX idx_citizenid (citizenid),
            INDEX idx_status (status)
        )
    ]])
    
    -- Phase 3: Replacement tracking table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS tlw_id_replacements (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizenid VARCHAR(50) NOT NULL,
            reason VARCHAR(50) DEFAULT 'lost',
            fee DECIMAL(10,2),
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_citizenid (citizenid)
        )
    ]])
    
    -- Phase 4: Renewal tracking table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS tlw_id_renewals (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizenid VARCHAR(50) NOT NULL,
            old_expiration DATETIME,
            new_expiration DATETIME,
            fee DECIMAL(10,2),
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_citizenid (citizenid)
        )
    ]])
    
    -- Phase 6: Statistics table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS tlw_id_statistics (
            id INT AUTO_INCREMENT PRIMARY KEY,
            metric_type VARCHAR(50) NOT NULL,
            metric_value INT DEFAULT 0,
            date DATE DEFAULT CURRENT_DATE,
            UNIQUE KEY unique_metric_date (metric_type, date),
            INDEX idx_metric_type (metric_type),
            INDEX idx_date (date)
        )
    ]])
    
    DebugPrint('Database initialized successfully')
end)

-- Take Photo Event (Phase 1: Enhanced with camera data)
RegisterNetEvent('tlw_idcard:server:takePhoto', function(photoData)
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
    
    -- Add photo item with metadata (including photo data from Phase 1)
    local info = {
        citizenid = Player.PlayerData.citizenid,
        firstname = Player.PlayerData.charinfo.firstname,
        lastname = Player.PlayerData.charinfo.lastname,
        timestamp = os.time(),
        photodata = photoData or nil -- Phase 1: Store photo data if available
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
        timestamp = os.date('%Y-%m-%d %H:%M:%S'),
        tier = formData.tier or 'Basic', -- Phase 5: Store selected tier
        expiration = CalculateExpirationDate() -- Phase 4: Calculate expiration
    }
    
    -- Phase 5: Adjust fee based on tier
    local selectedTier = formData.tier or 'Basic'
    local tierConfig = nil
    for _, tier in ipairs(Config.Tiers.tiers) do
        if tier.name == selectedTier then
            tierConfig = tier
            break
        end
    end
    
    -- Save to database with tier and expiration
    MySQL.insert('INSERT INTO tlw_id_applications (citizenid, data, status, tier, expiration_date) VALUES (?, ?, ?, ?, ?)', {
        Player.PlayerData.citizenid,
        json.encode(applicationData),
        'pending',
        selectedTier,
        applicationData.expiration
    })
    
    -- Phase 6: Track statistics
    IncrementStatistic('applications')
    
    -- Send Discord webhook
    if Config.Discord.enabled and Config.Discord.webhook ~= 'YOUR_WEBHOOK_URL_HERE' then
        local tierInfo = tierConfig and ('\nTier: ' .. tierConfig.label .. ' ($' .. tierConfig.price .. ')') or ''
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
                    {name = 'Citizenship Tier', value = selectedTier .. tierInfo, inline = true},
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
    
    -- Give pending ID card with tier and expiration info
    local cardInfo = {
        citizenid = Player.PlayerData.citizenid,
        fullname = formData.fullname,
        birthdate = formData.birthdate,
        birthplace = formData.birthplace,
        occupation = formData.occupation,
        issued = os.date('%m/%d/%Y'),
        status = 'pending',
        tier = selectedTier, -- Phase 5
        expiration = applicationData.expiration -- Phase 4
    }
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

-- Phase 2: ID Inspection System
RegisterNetEvent('tlw_idcard:server:requestInspection', function(targetId)
    if not Config.Inspection.enabled then return end
    
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local TargetPlayer = RSGCore.Functions.GetPlayer(targetId)
    
    if not Player or not TargetPlayer then return end
    
    -- Send request to target player
    TriggerClientEvent('tlw_idcard:client:receiveInspectionRequest', targetId, Player.PlayerData.name, src)
end)

RegisterNetEvent('tlw_idcard:server:acceptInspection', function(requesterId)
    if not Config.Inspection.enabled then return end
    
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Get the player's ID card
    local citizenCard = exports['rsg-inventory']:GetItemByName(src, Config.Items.idCitizen)
    local pendingCard = exports['rsg-inventory']:GetItemByName(src, Config.Items.idPending)
    
    local cardData = nil
    if citizenCard then
        cardData = citizenCard.info
    elseif pendingCard then
        cardData = pendingCard.info
    end
    
    if cardData then
        TriggerClientEvent('tlw_idcard:client:showInspectionResult', requesterId, cardData)
    end
end)

RegisterNetEvent('tlw_idcard:server:denyInspection', function(requesterId)
    if not Config.Inspection.enabled then return end
    
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if Player then
        RSGCore.Functions.Notify(requesterId, Config.Locale.inspection_denied, 'error')
    end
end)

-- Phase 3: ID Replacement System
RegisterNetEvent('tlw_idcard:server:requestReplacement', function()
    if not Config.Replacement.enabled then return end
    
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check cooldown
    local onCooldown, timeLeft = IsOnCooldown(src, 'replacement')
    if onCooldown then
        local hours = math.floor(timeLeft / 3600)
        RSGCore.Functions.Notify(src, string.format(Config.Locale.replacement_cooldown, hours .. ' hours'), 'error')
        return
    end
    
    -- Check if player has enough money
    if Player.PlayerData.money.cash < Config.Replacement.fee then
        RSGCore.Functions.Notify(src, string.format(Config.Locale.replacement_insufficient_funds, Config.Replacement.fee), 'error')
        return
    end
    
    -- Check max replacements
    if Config.Replacement.maxReplacements > 0 then
        local result = MySQL.scalar.await('SELECT COUNT(*) FROM tlw_id_replacements WHERE citizenid = ?', {Player.PlayerData.citizenid})
        if result and result >= Config.Replacement.maxReplacements then
            RSGCore.Functions.Notify(src, Config.Locale.replacement_max_reached, 'error')
            return
        end
    end
    
    -- Get existing ID data
    local citizenCard = exports['rsg-inventory']:GetItemByName(src, Config.Items.idCitizen)
    local pendingCard = exports['rsg-inventory']:GetItemByName(src, Config.Items.idPending)
    
    local cardInfo = nil
    local itemType = nil
    
    if citizenCard then
        cardInfo = citizenCard.info
        itemType = Config.Items.idCitizen
        exports['rsg-inventory']:RemoveItem(src, Config.Items.idCitizen, 1)
    elseif pendingCard then
        cardInfo = pendingCard.info
        itemType = Config.Items.idPending
        exports['rsg-inventory']:RemoveItem(src, Config.Items.idPending, 1)
    else
        RSGCore.Functions.Notify(src, Config.Locale.replacement_no_previous, 'error')
        return
    end
    
    -- Remove money
    Player.Functions.RemoveMoney('cash', Config.Replacement.fee)
    
    -- Give new ID with same info
    cardInfo.issued = os.date('%m/%d/%Y')
    cardInfo.replacement = (cardInfo.replacement or 0) + 1
    exports['rsg-inventory']:AddItem(src, itemType, 1, nil, cardInfo)
    
    -- Track in database
    if Config.Replacement.trackInDatabase then
        MySQL.insert('INSERT INTO tlw_id_replacements (citizenid, fee) VALUES (?, ?)', {
            Player.PlayerData.citizenid,
            Config.Replacement.fee
        })
    end
    
    -- Set cooldown
    SetCooldown(src, 'replacement', Config.Replacement.cooldown)
    
    -- Track statistics
    IncrementStatistic('replacements')
    
    RSGCore.Functions.Notify(src, Config.Locale.replacement_success, 'success')
    DebugPrint('ID replaced for ' .. Player.PlayerData.name)
end)

-- Phase 4: ID Renewal System
RegisterNetEvent('tlw_idcard:server:requestRenewal', function()
    if not Config.Expiration.enabled then return end
    
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check if player has citizen ID
    local citizenCard = exports['rsg-inventory']:GetItemByName(src, Config.Items.idCitizen)
    if not citizenCard then
        RSGCore.Functions.Notify(src, 'You need a citizen ID to renew', 'error')
        return
    end
    
    -- Check if ID is expired or close to expiration
    local expirationDate = citizenCard.info.expiration
    if not IsIDExpired(expirationDate) then
        local expTime = os.time({year=expirationDate:sub(1,4), month=expirationDate:sub(6,7), day=expirationDate:sub(9,10)})
        local daysLeft = math.floor((expTime - os.time()) / 86400)
        
        if daysLeft > Config.Expiration.warningDays then
            RSGCore.Functions.Notify(src, Config.Locale.renewal_not_expired, 'error')
            return
        end
    end
    
    -- Check if player has enough money
    if Player.PlayerData.money.cash < Config.Expiration.renewalFee then
        RSGCore.Functions.Notify(src, string.format(Config.Locale.renewal_insufficient_funds, Config.Expiration.renewalFee), 'error')
        return
    end
    
    -- Remove money
    Player.Functions.RemoveMoney('cash', Config.Expiration.renewalFee)
    
    -- Remove old ID
    exports['rsg-inventory']:RemoveItem(src, Config.Items.idCitizen, 1)
    
    -- Calculate new expiration
    local newExpiration = CalculateExpirationDate()
    
    -- Give renewed ID
    local cardInfo = citizenCard.info
    cardInfo.expiration = newExpiration
    cardInfo.renewed = (cardInfo.renewed or 0) + 1
    cardInfo.last_renewed = os.date('%m/%d/%Y')
    exports['rsg-inventory']:AddItem(src, Config.Items.idCitizen, 1, nil, cardInfo)
    
    -- Track in database
    MySQL.insert('INSERT INTO tlw_id_renewals (citizenid, old_expiration, new_expiration, fee) VALUES (?, ?, ?, ?)', {
        Player.PlayerData.citizenid,
        expirationDate,
        newExpiration,
        Config.Expiration.renewalFee
    })
    
    -- Track statistics
    IncrementStatistic('renewals')
    
    RSGCore.Functions.Notify(src, Config.Locale.renewal_success, 'success')
    DebugPrint('ID renewed for ' .. Player.PlayerData.name)
end)

-- Phase 5: Tier Upgrade System
RegisterNetEvent('tlw_idcard:server:upgradeTier', function(newTierName)
    if not Config.Tiers.enabled then return end
    
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Get citizen ID
    local citizenCard = exports['rsg-inventory']:GetItemByName(src, Config.Items.idCitizen)
    if not citizenCard then
        RSGCore.Functions.Notify(src, 'You need a citizen ID to upgrade tiers', 'error')
        return
    end
    
    -- Find new tier config
    local newTierConfig = nil
    local newTierIndex = 0
    for i, tier in ipairs(Config.Tiers.tiers) do
        if tier.name == newTierName then
            newTierConfig = tier
            newTierIndex = i
            break
        end
    end
    
    if not newTierConfig then
        RSGCore.Functions.Notify(src, 'Invalid tier selected', 'error')
        return
    end
    
    -- Get current tier
    local currentTier = citizenCard.info.tier or 'Basic'
    local currentTierIndex = 0
    local currentTierConfig = nil
    for i, tier in ipairs(Config.Tiers.tiers) do
        if tier.name == currentTier then
            currentTierIndex = i
            currentTierConfig = tier
            break
        end
    end
    
    -- Check if upgrading or downgrading
    if newTierIndex <= currentTierIndex then
        RSGCore.Functions.Notify(src, 'You already have this tier or higher', 'error')
        return
    end
    
    -- Calculate cost with potential refund
    local cost = newTierConfig.price
    if Config.Tiers.upgradeRefund and currentTierConfig then
        cost = cost - (currentTierConfig.price * 0.5) -- 50% refund on upgrade
    end
    
    -- Check if player has enough money
    if Player.PlayerData.money.cash < cost then
        RSGCore.Functions.Notify(src, string.format('You need $%s to upgrade to %s', cost, newTierConfig.label), 'error')
        return
    end
    
    -- Remove money
    Player.Functions.RemoveMoney('cash', cost)
    
    -- Remove old ID
    exports['rsg-inventory']:RemoveItem(src, Config.Items.idCitizen, 1)
    
    -- Give upgraded ID
    local cardInfo = citizenCard.info
    cardInfo.tier = newTierName
    cardInfo.tier_upgraded = os.date('%m/%d/%Y')
    exports['rsg-inventory']:AddItem(src, Config.Items.idCitizen, 1, nil, cardInfo)
    
    -- Update database
    MySQL.update('UPDATE tlw_id_applications SET tier = ? WHERE citizenid = ?', {
        newTierName,
        Player.PlayerData.citizenid
    })
    
    RSGCore.Functions.Notify(src, string.format(Config.Locale.tier_upgrade_success, newTierConfig.label), 'success')
    DebugPrint('Tier upgraded for ' .. Player.PlayerData.name .. ' to ' .. newTierName)
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
    
    -- Phase 6: Track statistics
    IncrementStatistic('approvals')
    
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
    
    -- Phase 6: Track statistics
    IncrementStatistic('denials')
    
    -- Notify both players
    RSGCore.Functions.Notify(targetId, 'Your citizenship application has been denied. You may reapply.', 'error', 7000)
    RSGCore.Functions.Notify(source, 'Application denied for ' .. TargetPlayer.PlayerData.name, 'success')
    
    DebugPrint('Citizenship denied for ' .. TargetPlayer.PlayerData.name)
end, Config.AdminAce)

-- Phase 6: Statistics Dashboard Command
RSGCore.Commands.Add(Config.Statistics.adminCommand or 'idstats', 'View ID card system statistics', {}, true, function(source, args)
    if not Config.Statistics.enabled then
        RSGCore.Functions.Notify(source, 'Statistics system is disabled', 'error')
        return
    end
    
    -- Get statistics from database
    local stats = {}
    
    -- Get daily metrics
    local metrics = MySQL.query.await([[
        SELECT metric_type, SUM(metric_value) as total
        FROM tlw_id_statistics
        GROUP BY metric_type
    ]])
    
    if metrics then
        for _, metric in ipairs(metrics) do
            stats[metric.metric_type] = metric.total
        end
    end
    
    -- Get tier distribution
    if Config.Statistics.trackMetrics.tierDistribution then
        local tierDist = MySQL.query.await([[
            SELECT tier, COUNT(*) as count
            FROM tlw_id_applications
            WHERE status = 'approved'
            GROUP BY tier
        ]])
        
        if tierDist then
            stats.tierDistribution = {}
            for _, tier in ipairs(tierDist) do
                stats.tierDistribution[tier.tier] = tier.count
            end
        end
    end
    
    -- Get pending applications count
    local pending = MySQL.scalar.await('SELECT COUNT(*) FROM tlw_id_applications WHERE status = ?', {'pending'})
    stats.pending = pending or 0
    
    -- Send statistics to client
    TriggerClientEvent('tlw_idcard:client:showStatistics', source, stats)
end, Config.AdminAce)

-- Clean up cooldowns on player drop
AddEventHandler('playerDropped', function()
    local src = source
    if playerCooldowns[src] then
        playerCooldowns[src] = nil
    end
end)
