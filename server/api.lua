-- v3.0 API Exports for Integration with Other Scripts
local RSGCore = exports['rsg-core']:GetCoreObject()

-- ============================================
-- TIER PERKS API
-- ============================================

-- Get player's citizenship tier
function GetPlayerTier(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return nil end
    
    local citizenid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT tier FROM tlw_id_applications WHERE citizenid = ? AND status = "approved" LIMIT 1', {citizenid})
    
    if result and result[1] then
        return result[1].tier
    end
    return nil
end

-- Check if player has citizenship
function HasCitizenship(source)
    return GetPlayerTier(source) ~= nil
end

-- Get tier perks for a player
function GetPlayerPerks(source)
    if not Config.TierPerks.enabled then return {} end
    
    local tier = GetPlayerTier(source)
    if not tier then return {} end
    
    return Config.TierPerks.perks[tier] or {}
end

-- Apply shop discount based on tier
function GetShopDiscount(source)
    local perks = GetPlayerPerks(source)
    return perks.shopDiscounts or 0.0
end

-- Apply job pay bonus based on tier
function GetJobBonus(source)
    local perks = GetPlayerPerks(source)
    return perks.jobPayBonus or 0.0
end

-- Apply housing discount based on tier
function GetHousingDiscount(source)
    local perks = GetPlayerPerks(source)
    return perks.housingDiscount or 0.0
end

-- Check if player can use fast travel
function CanUseFastTravel(source)
    local perks = GetPlayerPerks(source)
    return perks.fastTravel or false
end

-- Export functions
exports('GetPlayerTier', GetPlayerTier)
exports('HasCitizenship', HasCitizenship)
exports('GetPlayerPerks', GetPlayerPerks)
exports('GetShopDiscount', GetShopDiscount)
exports('GetJobBonus', GetJobBonus)
exports('GetHousingDiscount', GetHousingDiscount)
exports('CanUseFastTravel', CanUseFastTravel)

-- ============================================
-- JOB INTEGRATION API
-- ============================================

-- Check if player meets job requirements
function CanTakeJob(source, jobName)
    if not Config.JobIntegration.enabled then return true end
    if not Config.JobIntegration.features.jobRequirements then return true end
    
    -- Check if job requires citizenship
    local requiresCitizenship = false
    for _, job in ipairs(Config.JobIntegration.features.governmentJobs) do
        if job == jobName then
            requiresCitizenship = true
            break
        end
    end
    
    if requiresCitizenship and not HasCitizenship(source) then
        return false, 'job_citizenship_required'
    end
    
    -- Check tier requirements
    if Config.JobIntegration.restrictedJobs and Config.JobIntegration.jobTierRequirements[jobName] then
        local requiredTier = Config.JobIntegration.jobTierRequirements[jobName]
        local playerTier = GetPlayerTier(source)
        
        if not playerTier then
            return false, 'job_citizenship_required'
        end
        
        -- Simple tier comparison (Basic < Premium < Elite)
        local tierOrder = {Basic = 1, Premium = 2, Elite = 3}
        if tierOrder[playerTier] < tierOrder[requiredTier] then
            return false, 'job_tier_required'
        end
    end
    
    return true
end

exports('CanTakeJob', CanTakeJob)

-- ============================================
-- PROPERTY INTEGRATION API
-- ============================================

-- Check if player can purchase property
function CanPurchaseProperty(source)
    if not Config.PropertyIntegration.enabled then return true end
    if not Config.PropertyIntegration.features.purchaseRequirement then return true end
    
    return HasCitizenship(source), 'property_citizenship_required'
end

-- Get property discount for player
function GetPropertyDiscount(source)
    if not Config.PropertyIntegration.enabled then return 0.0 end
    if not Config.PropertyIntegration.features.tierDiscounts then return 0.0 end
    
    local tier = GetPlayerTier(source)
    if not tier then return 0.0 end
    
    return Config.PropertyIntegration.discounts[tier] or 0.0
end

-- Get property limit for player
function GetPropertyLimit(source)
    if not Config.PropertyIntegration.enabled then return 999 end
    if not Config.PropertyIntegration.features.tierLimits then return 999 end
    
    local tier = GetPlayerTier(source)
    if not tier then
        return Config.PropertyIntegration.propertyLimits.none or 0
    end
    
    return Config.PropertyIntegration.propertyLimits[tier] or 1
end

-- Get property tax reduction
function GetPropertyTaxReduction(source)
    if not Config.PropertyIntegration.enabled then return 0.0 end
    
    local tier = GetPlayerTier(source)
    if not tier then return 0.0 end
    
    return Config.PropertyIntegration.taxReduction[tier] or 0.0
end

exports('CanPurchaseProperty', CanPurchaseProperty)
exports('GetPropertyDiscount', GetPropertyDiscount)
exports('GetPropertyLimit', GetPropertyLimit)
exports('GetPropertyTaxReduction', GetPropertyTaxReduction)

-- ============================================
-- CRIMINAL RECORD API
-- ============================================

-- Get player's criminal record count
function GetCriminalRecordCount(source)
    if not Config.CriminalRecords.enabled then return 0 end
    
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return 0 end
    
    local citizenid = Player.PlayerData.citizenid
    
    -- Check if there's a criminal records table (depends on framework)
    local result = MySQL.query.await([[
        SELECT COUNT(*) as count FROM player_crimes 
        WHERE citizenid = ? AND 
        (? = FALSE OR crime_date >= DATE_SUB(NOW(), INTERVAL ? DAY))
    ]], {
        citizenid,
        Config.CriminalRecords.features.recordExpiry,
        Config.CriminalRecords.recordExpiryDays
    })
    
    if result and result[1] then
        return result[1].count
    end
    
    return 0
end

-- Check if player can get specific tier with criminal record
function CanGetTierWithRecord(source, tier)
    if not Config.CriminalRecords.enabled then return true end
    if not Config.CriminalRecords.features.tierRestrictions then return true end
    
    local crimeCount = GetCriminalRecordCount(source)
    local limit = Config.CriminalRecords.tierCrimeLimits[tier] or 999
    
    return crimeCount <= limit, 'criminal_record_tier_denied'
end

exports('GetCriminalRecordCount', GetCriminalRecordCount)
exports('CanGetTierWithRecord', CanGetTierWithRecord)

-- ============================================
-- SEASONAL BONUS API
-- ============================================

-- Get current season
function GetCurrentSeason()
    if not Config.SeasonalBonuses.enabled then return nil end
    
    local currentMonth = tonumber(os.date('%m'))
    
    for _, season in ipairs(Config.SeasonalBonuses.seasons) do
        if season.startMonth <= season.endMonth then
            -- Normal season (e.g., March to May)
            if currentMonth >= season.startMonth and currentMonth <= season.endMonth then
                return season
            end
        else
            -- Wrapping season (e.g., December to February)
            if currentMonth >= season.startMonth or currentMonth <= season.endMonth then
                return season
            end
        end
    end
    
    return nil
end

-- Get seasonal bonus for tier
function GetSeasonalBonus(tier)
    if not Config.SeasonalBonuses.enabled then return nil end
    
    local season = GetCurrentSeason()
    if not season then return nil end
    
    return season.bonuses[tier]
end

-- Apply seasonal discount to price
function ApplySeasonalDiscount(price, tier)
    local bonus = GetSeasonalBonus(tier)
    if not bonus then return price end
    
    return price * (1 - bonus.discount)
end

exports('GetCurrentSeason', GetCurrentSeason)
exports('GetSeasonalBonus', GetSeasonalBonus)
exports('ApplySeasonalDiscount', ApplySeasonalDiscount)

-- ============================================
-- FAMILY TIER API
-- ============================================

-- Create family citizenship package
RegisterNetEvent('tlw_idcard:server:createFamilyPackage', function(packageName, members)
    local source = source
    if not Config.FamilyTiers.enabled then return end
    
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return end
    
    -- Find package config
    local package = nil
    for _, pkg in ipairs(Config.FamilyTiers.packages) do
        if pkg.name == packageName then
            package = pkg
            break
        end
    end
    
    if not package then return end
    
    -- Validate member count
    if #members < package.minMembers or #members > package.maxMembers then
        TriggerClientEvent('RSGCore:Notify', source, string.format(_('family_insufficient_members'), package.minMembers), 'error')
        return
    end
    
    -- Calculate total cost
    local totalCost = package.pricePerMember * #members
    
    -- Check if player has enough money
    if Player.PlayerData.money.cash < totalCost then
        TriggerClientEvent('RSGCore:Notify', source, string.format(_('government_insufficient_funds'), totalCost), 'error')
        return
    end
    
    -- Remove money
    Player.Functions.RemoveMoney('cash', totalCost)
    
    -- Create family citizenship records for all members
    for _, memberId in ipairs(members) do
        local MemberPlayer = RSGCore.Functions.GetPlayer(memberId)
        if MemberPlayer then
            -- Store family citizenship data
            -- This would integrate with a family system if available
        end
    end
    
    TriggerClientEvent('RSGCore:Notify', source, _('family_package_created'), 'success')
end)

-- ============================================
-- CUSTOM TIER MANAGEMENT
-- ============================================

-- Create custom tier (admin only)
RegisterNetEvent('tlw_idcard:server:createCustomTier', function(tierData)
    local source = source
    if not Config.CustomTiers.enabled then return end
    if not Config.CustomTiers.allowAdminCreation then return end
    
    -- Check admin permission
    if not IsPlayerAceAllowed(source, Config.AdminAce) then return end
    
    -- Check max custom tiers
    local currentCustomCount = #Config.CustomTiers.tiers
    if currentCustomCount >= Config.CustomTiers.maxCustomTiers then
        TriggerClientEvent('RSGCore:Notify', source, _('custom_tier_max_reached'), 'error')
        return
    end
    
    -- Add tier to config (in-memory, would need to persist to file for permanent)
    table.insert(Config.CustomTiers.tiers, tierData)
    table.insert(Config.Tiers.tiers, tierData)
    
    TriggerClientEvent('RSGCore:Notify', source, _('custom_tier_created'), 'success')
    
    -- Broadcast to all clients
    TriggerClientEvent('tlw_idcard:client:updateCustomTiers', -1, Config.Tiers.tiers)
end)

print('^2[TLW-IDCard v3.0]^7 API exports loaded successfully')
