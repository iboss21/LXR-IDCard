--[[
    INVENTORY INTEGRATION EXAMPLES
    
    This file contains code snippets to integrate The Land of Wolves IDCard System
    with your rsg-inventory setup.
    
    DO NOT add this entire file to your server! 
    Copy only the relevant sections to the appropriate files.
]]--

-- ============================================================================
-- SECTION 1: Item Definitions
-- Add to: rsg-inventory/config.lua or your items database
-- ============================================================================

RSGShared = RSGShared or {}
RSGShared.Items = RSGShared.Items or {}

-- Photo Plate Item
RSGShared.Items['photo_plate'] = {
    name = 'photo_plate',
    label = 'Photo Plate',
    weight = 100,
    type = 'item',
    image = 'photo_plate.png',
    unique = true,
    useable = false,
    shouldClose = true,
    combinable = nil,
    description = 'A photographic plate for identification purposes. Required for citizenship applications.'
}

-- Pending ID Card
RSGShared.Items['id_card_pending'] = {
    name = 'id_card_pending',
    label = 'Resident Permit',
    weight = 50,
    type = 'item',
    image = 'id_pending.png',
    unique = true,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'A resident permit pending full citizenship approval from The Land of Wolves.'
}

-- Citizen ID Card
RSGShared.Items['id_card_citizen'] = {
    name = 'id_card_citizen',
    label = 'Citizenship Card',
    weight = 50,
    type = 'item',
    image = 'id_citizen.png',
    unique = true,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'Official Citizenship Card of The Land of Wolves. Proof of full citizenship status.'
}


-- ============================================================================
-- SECTION 2: Usable Items Registration
-- Add to: rsg-inventory/server/main.lua (in the usable items section)
-- ============================================================================

-- The Land of Wolves ID Cards
RSGCore.Functions.CreateUseableItem('id_card_pending', function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return end
    
    TriggerClientEvent('tlw_idcard:client:showPendingID', source, item)
end)

RSGCore.Functions.CreateUseableItem('id_card_citizen', function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return end
    
    TriggerClientEvent('tlw_idcard:client:showCitizenID', source, item)
end)


-- ============================================================================
-- SECTION 3: Alternative Method - Using Exports (if your inventory supports it)
-- ============================================================================

-- If your inventory system uses exports instead of direct registration,
-- you can use this approach in tlw_idcard/server/main.lua:

--[[
exports['rsg-inventory']:CreateUsableItem('id_card_pending', function(source, item)
    TriggerClientEvent('tlw_idcard:client:showPendingID', source, item)
end)

exports['rsg-inventory']:CreateUsableItem('id_card_citizen', function(source, item)
    TriggerClientEvent('tlw_idcard:client:showCitizenID', source, item)
end)
]]--


-- ============================================================================
-- SECTION 4: Item Metadata Examples
-- ============================================================================

-- When creating items with metadata, use this format:

--[[
-- Photo Plate with metadata
local photoInfo = {
    citizenid = Player.PlayerData.citizenid,
    firstname = Player.PlayerData.charinfo.firstname,
    lastname = Player.PlayerData.charinfo.lastname,
    timestamp = os.time()
}
exports['rsg-inventory']:AddItem(source, 'photo_plate', 1, nil, photoInfo)

-- ID Card with metadata
local idInfo = {
    citizenid = Player.PlayerData.citizenid,
    fullname = "John Marston",
    birthdate = "01/15/1873",
    birthplace = "Texas",
    occupation = "Rancher",
    issued = "12/26/2025",
    status = "approved" -- or "pending"
}
exports['rsg-inventory']:AddItem(source, 'id_card_citizen', 1, nil, idInfo)
]]--


-- ============================================================================
-- SECTION 5: Item Images
-- ============================================================================

--[[
    Place these image files in your inventory's image directory:
    (Usually: rsg-inventory/html/images/)
    
    Required images:
    - photo_plate.png (128x128px) - Camera or photograph icon
    - id_pending.png (128x128px) - Document/paper icon without seal
    - id_citizen.png (128x128px) - Document with official seal/stamp
    
    You can create these using:
    - Photo editing software (GIMP, Photoshop)
    - AI image generators
    - Icon websites (flaticon.com, etc.)
    - Or use existing inventory item icons as reference
]]--


-- ============================================================================
-- SECTION 6: Inventory Compatibility Notes
-- ============================================================================

--[[
    RSG-Inventory / OX-Inventory Compatibility:
    
    This script is designed to work with rsg-inventory (RSG-Core's fork of ox_inventory).
    If you're using a different inventory system, you may need to adjust:
    
    1. Item adding syntax:
       - RSG: exports['rsg-inventory']:AddItem(source, item, amount, slot, info)
       - QS: exports['qs-inventory']:AddItem(source, item, amount, slot, info)
       - Custom: Check your inventory's documentation
    
    2. Item checking syntax:
       - RSG: exports['rsg-inventory']:HasItem(source, item, amount)
       - Custom: May differ
    
    3. Item removal syntax:
       - RSG: exports['rsg-inventory']:RemoveItem(source, item, amount, slot)
       - Custom: Check documentation
    
    4. Metadata handling:
       - Some inventories use 'info', others use 'metadata'
       - Adjust accordingly in server/main.lua
]]--


-- ============================================================================
-- SECTION 7: Testing Commands (Optional - For Development)
-- ============================================================================

--[[
-- Add these commands temporarily for testing during development
-- Remove them before production!

RegisterCommand('givephoto', function(source, args)
    local Player = RSGCore.Functions.GetPlayer(source)
    if Player then
        exports['rsg-inventory']:AddItem(source, 'photo_plate', 1)
        RSGCore.Functions.Notify(source, 'Photo plate given', 'success')
    end
end)

RegisterCommand('givependingid', function(source, args)
    local Player = RSGCore.Functions.GetPlayer(source)
    if Player then
        local info = {
            fullname = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
            birthdate = '01/01/1873',
            birthplace = 'New Austin',
            occupation = 'Tester',
            issued = os.date('%m/%d/%Y'),
            status = 'pending'
        }
        exports['rsg-inventory']:AddItem(source, 'id_card_pending', 1, nil, info)
        RSGCore.Functions.Notify(source, 'Pending ID given', 'success')
    end
end)
]]--
