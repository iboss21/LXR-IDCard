# 🔌 API Integration Guide

## Overview

The Land of Wolves IDCard System v3.0 provides a comprehensive API for integration with other scripts. This allows other resources to check citizenship status, apply tier-based perks, and enforce requirements.

---

## 📦 Exported Functions

### Tier Management

#### `GetPlayerTier(source)`
Get a player's current citizenship tier.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `string|nil`: Tier name ('Basic', 'Premium', 'Elite', or custom tier) or nil if no citizenship

**Example:**
```lua
local tier = exports['tlw_idcard']:GetPlayerTier(source)
if tier == 'Elite' then
    -- Grant elite benefits
end
```

---

#### `HasCitizenship(source)`
Check if a player has any form of citizenship.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `boolean`: True if player has citizenship, false otherwise

**Example:**
```lua
local hasCitizen = exports['tlw_idcard']:HasCitizenship(source)
if not hasCitizen then
    -- Deny access or prompt to apply
end
```

---

#### `GetPlayerPerks(source)`
Get all perks associated with a player's tier.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `table`: Table containing all perks for the player's tier

**Example:**
```lua
local perks = exports['tlw_idcard']:GetPlayerPerks(source)
print('Shop discount: ' .. perks.shopDiscounts)
print('Job bonus: ' .. perks.jobPayBonus)
```

---

### Shop Integration

#### `GetShopDiscount(source)`
Get the shop discount percentage for a player's tier.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `number`: Discount percentage (0.0 to 1.0)

**Example:**
```lua
local basePrice = 100
local discount = exports['tlw_idcard']:GetShopDiscount(source)
local finalPrice = basePrice * (1 - discount)

-- If Elite tier (25% discount): finalPrice = 75
TriggerClientEvent('shop:purchase', source, finalPrice)
```

---

### Job Integration

#### `CanTakeJob(source, jobName)`
Check if a player meets the requirements to take a specific job.

**Parameters:**
- `source` (number): Player's server ID
- `jobName` (string): Name of the job

**Returns:**
- `boolean`: True if player can take the job
- `string|nil`: Error reason if cannot take job

**Example:**
```lua
RegisterNetEvent('myjob:hire', function(jobName)
    local source = source
    local canTake, reason = exports['tlw_idcard']:CanTakeJob(source, jobName)
    
    if not canTake then
        if reason == 'job_citizenship_required' then
            TriggerClientEvent('notify', source, 'You need citizenship to work this job', 'error')
        elseif reason == 'job_tier_required' then
            TriggerClientEvent('notify', source, 'You need a higher citizenship tier for this job', 'error')
        end
        return
    end
    
    -- Continue with hiring process
end)
```

---

#### `GetJobBonus(source)`
Get the job pay bonus percentage for a player's tier.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `number`: Bonus percentage (0.0 to 1.0)

**Example:**
```lua
local basePay = 100
local bonus = exports['tlw_idcard']:GetJobBonus(source)
local finalPay = basePay * (1 + bonus)

-- If Premium tier (5% bonus): finalPay = 105
Player.Functions.AddMoney('cash', finalPay)
```

---

### Property Integration

#### `CanPurchaseProperty(source)`
Check if a player is allowed to purchase property.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `boolean`: True if player can purchase
- `string|nil`: Error reason if cannot purchase

**Example:**
```lua
RegisterNetEvent('housing:purchase', function(propertyId)
    local source = source
    local canPurchase, reason = exports['tlw_idcard']:CanPurchaseProperty(source)
    
    if not canPurchase then
        TriggerClientEvent('notify', source, 'You need citizenship to purchase property', 'error')
        return
    end
    
    -- Continue with purchase
end)
```

---

#### `GetPropertyDiscount(source)`
Get the property purchase discount for a player's tier.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `number`: Discount percentage (0.0 to 1.0)

**Example:**
```lua
local propertyPrice = 5000
local discount = exports['tlw_idcard']:GetPropertyDiscount(source)
local finalPrice = propertyPrice * (1 - discount)

-- If Elite tier (25% discount): finalPrice = 3750
```

---

#### `GetPropertyLimit(source)`
Get the maximum number of properties a player can own based on tier.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `number`: Maximum properties allowed

**Example:**
```lua
local currentProperties = GetPlayerPropertyCount(source)
local limit = exports['tlw_idcard']:GetPropertyLimit(source)

if currentProperties >= limit then
    TriggerClientEvent('notify', source, 'You have reached your property limit', 'error')
    return
end
```

---

#### `GetPropertyTaxReduction(source)`
Get the property tax reduction for a player's tier.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `number`: Tax reduction percentage (0.0 to 1.0)

**Example:**
```lua
local baseTax = 100
local reduction = exports['tlw_idcard']:GetPropertyTaxReduction(source)
local finalTax = baseTax * (1 - reduction)

-- If Premium tier (15% reduction): finalTax = 85
```

---

#### `GetHousingDiscount(source)`
Get the housing-related discount for a player's tier.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `number`: Discount percentage (0.0 to 1.0)

**Example:**
```lua
local discount = exports['tlw_idcard']:GetHousingDiscount(source)
-- Apply to housing-related purchases
```

---

### Criminal Records

#### `GetCriminalRecordCount(source)`
Get the number of crimes on a player's record.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `number`: Number of crimes

**Example:**
```lua
local crimeCount = exports['tlw_idcard']:GetCriminalRecordCount(source)
if crimeCount > 5 then
    -- Deny citizenship application
end
```

---

#### `CanGetTierWithRecord(source, tier)`
Check if a player's criminal record allows them to get a specific tier.

**Parameters:**
- `source` (number): Player's server ID
- `tier` (string): Tier name to check

**Returns:**
- `boolean`: True if player can get the tier
- `string|nil`: Error reason if cannot get tier

**Example:**
```lua
local canGet, reason = exports['tlw_idcard']:CanGetTierWithRecord(source, 'Elite')
if not canGet then
    TriggerClientEvent('notify', source, 'Your criminal record prevents Elite citizenship', 'error')
end
```

---

### Seasonal Features

#### `GetCurrentSeason()`
Get information about the current season.

**Parameters:** None

**Returns:**
- `table|nil`: Season data table or nil if no active season

**Example:**
```lua
local season = exports['tlw_idcard']:GetCurrentSeason()
if season then
    print('Current season: ' .. season.name)
    print('Badge: ' .. season.badge)
end
```

---

#### `GetSeasonalBonus(tier)`
Get seasonal bonus information for a specific tier.

**Parameters:**
- `tier` (string): Tier name

**Returns:**
- `table|nil`: Bonus data or nil if no active season

**Example:**
```lua
local bonus = exports['tlw_idcard']:GetSeasonalBonus('Elite')
if bonus then
    print('Discount: ' .. (bonus.discount * 100) .. '%')
    print('Bonus item: ' .. bonus.bonus)
end
```

---

#### `ApplySeasonalDiscount(price, tier)`
Apply seasonal discount to a price.

**Parameters:**
- `price` (number): Base price
- `tier` (string): Player's tier

**Returns:**
- `number`: Discounted price

**Example:**
```lua
local basePrice = 150
local tier = exports['tlw_idcard']:GetPlayerTier(source)
local finalPrice = exports['tlw_idcard']:ApplySeasonalDiscount(basePrice, tier)
```

---

### Other Features

#### `CanUseFastTravel(source)`
Check if a player can use fast travel based on their tier.

**Parameters:**
- `source` (number): Player's server ID

**Returns:**
- `boolean`: True if fast travel is allowed

**Example:**
```lua
if exports['tlw_idcard']:CanUseFastTravel(source) then
    -- Allow fast travel
end
```

---

## 🎯 Common Integration Patterns

### Shop Script Integration

```lua
-- In your shop script's purchase event
RegisterNetEvent('myshop:purchase', function(itemId, basePrice)
    local source = source
    
    -- Check citizenship for restricted items
    if RestrictedItems[itemId] then
        if not exports['tlw_idcard']:HasCitizenship(source) then
            TriggerClientEvent('notify', source, 'Citizenship required', 'error')
            return
        end
    end
    
    -- Apply citizenship discount
    local discount = exports['tlw_idcard']:GetShopDiscount(source)
    local finalPrice = basePrice * (1 - discount)
    
    -- Apply seasonal discount if applicable
    local tier = exports['tlw_idcard']:GetPlayerTier(source)
    if tier then
        finalPrice = exports['tlw_idcard']:ApplySeasonalDiscount(finalPrice, tier)
    end
    
    -- Process purchase
    if Player.Functions.RemoveMoney('cash', finalPrice) then
        Player.Functions.AddItem(itemId, 1)
        TriggerClientEvent('notify', source, 'Purchase successful!', 'success')
    end
end)
```

---

### Job Script Integration

```lua
-- In your job script
RegisterNetEvent('myjob:applyForJob', function(jobName)
    local source = source
    local Player = GetPlayer(source)
    
    -- Check if citizenship is required
    local canTake, reason = exports['tlw_idcard']:CanTakeJob(source, jobName)
    
    if not canTake then
        local message = 'You do not meet the requirements for this job'
        if reason == 'job_citizenship_required' then
            message = 'This job requires citizenship'
        elseif reason == 'job_tier_required' then
            message = 'This job requires a higher citizenship tier'
        end
        TriggerClientEvent('notify', source, message, 'error')
        return
    end
    
    -- Hire player
    Player.Functions.SetJob(jobName, 0)
    TriggerClientEvent('notify', source, 'You have been hired!', 'success')
end)

-- Modify pay calculation
function CalculateJobPay(source, basePay)
    local bonus = exports['tlw_idcard']:GetJobBonus(source)
    return basePay * (1 + bonus)
end
```

---

### Property Script Integration

```lua
-- In your property script
RegisterNetEvent('property:purchase', function(propertyId, basePrice)
    local source = source
    local Player = GetPlayer(source)
    
    -- Check citizenship requirement
    local canPurchase, reason = exports['tlw_idcard']:CanPurchaseProperty(source)
    if not canPurchase then
        TriggerClientEvent('notify', source, 'Citizenship required to own property', 'error')
        return
    end
    
    -- Check property limit
    local currentProperties = GetPlayerPropertyCount(source)
    local limit = exports['tlw_idcard']:GetPropertyLimit(source)
    
    if currentProperties >= limit then
        TriggerClientEvent('notify', source, 'You have reached your property limit. Upgrade your citizenship tier for more properties.', 'error')
        return
    end
    
    -- Apply discount
    local discount = exports['tlw_idcard']:GetPropertyDiscount(source)
    local finalPrice = basePrice * (1 - discount)
    
    -- Process purchase
    if Player.Functions.RemoveMoney('cash', finalPrice) then
        -- Add property to player
        TriggerClientEvent('notify', source, string.format('Property purchased for $%d (%.0f%% citizen discount)', finalPrice, discount * 100), 'success')
    end
end)

-- Calculate property tax
function CalculatePropertyTax(source, baseTax)
    local reduction = exports['tlw_idcard']:GetPropertyTaxReduction(source)
    return baseTax * (1 - reduction)
end
```

---

### Criminal System Integration

```lua
-- In your police/lawman script
RegisterNetEvent('police:applyCitizenship', function()
    local source = source
    
    -- Check criminal record
    local crimeCount = exports['tlw_idcard']:GetCriminalRecordCount(source)
    
    if crimeCount > 0 then
        TriggerClientEvent('notify', source, 
            string.format('Warning: You have %d crime(s) on your record. This may affect your citizenship application.', crimeCount), 
            'error', 
            10000
        )
    end
    
    -- Check if eligible for specific tiers
    local tiers = {'Basic', 'Premium', 'Elite'}
    for _, tier in ipairs(tiers) do
        local canGet, reason = exports['tlw_idcard']:CanGetTierWithRecord(source, tier)
        if not canGet then
            print(string.format('Player cannot get %s tier due to criminal record', tier))
        end
    end
end)
```

---

## 🔐 Security Best Practices

1. **Always validate on server-side:**
   ```lua
   -- ❌ Bad: Checking on client
   if exports['tlw_idcard']:HasCitizenship() then
       -- Client can manipulate this
   end
   
   -- ✅ Good: Check on server
   RegisterNetEvent('myevent:doSomething', function()
       local source = source
       if exports['tlw_idcard']:HasCitizenship(source) then
           -- Server-side validation
       end
   end)
   ```

2. **Handle nil returns:**
   ```lua
   local tier = exports['tlw_idcard']:GetPlayerTier(source)
   if tier then
       -- Player has citizenship
   else
       -- Player doesn't have citizenship
   end
   ```

3. **Cache results for performance:**
   ```lua
   -- Cache tier for multiple checks
   local tier = exports['tlw_idcard']:GetPlayerTier(source)
   if tier then
       local shopDiscount = exports['tlw_idcard']:GetShopDiscount(source)
       local jobBonus = exports['tlw_idcard']:GetJobBonus(source)
       -- Use cached values
   end
   ```

---

## 📝 Notes

- All exported functions are server-side only
- Always check return values for nil
- Tier names are case-sensitive
- Custom tiers are supported
- Functions return immediately (not async)

---

## 🐛 Error Handling

```lua
-- Proper error handling example
local success, tier = pcall(function()
    return exports['tlw_idcard']:GetPlayerTier(source)
end)

if success and tier then
    -- Use tier
else
    print('Error getting player tier or player has no citizenship')
end
```

---

## 📞 Support

For integration issues or questions:
- GitHub Issues: [Report Issue](https://github.com/iboss21/LXR-IDCard/issues)
- Documentation: See V3_FEATURES.md for detailed feature info

---

**Version**: 3.0.0  
**Last Updated**: December 2024
