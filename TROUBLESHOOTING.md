# 🔧 Troubleshooting Guide

Common issues and solutions for The Land of Wolves IDCard System.

---

## 📋 Table of Contents

1. [Installation Issues](#installation-issues)
2. [Item Problems](#item-problems)
3. [UI/NUI Issues](#uinui-issues)
4. [Database Problems](#database-problems)
5. [Discord Webhook Issues](#discord-webhook-issues)
6. [Performance Issues](#performance-issues)
7. [Script Errors](#script-errors)

---

## 🔨 Installation Issues

### Resource Not Starting

**Symptom**: Resource doesn't appear in F8 console on server start

**Solutions**:
1. Check `server.cfg` has `ensure tlw_idcard` (not `start`)
2. Verify folder name is correct (no spaces, special characters)
3. Check fxmanifest.lua for syntax errors
4. Ensure all dependencies are installed and started before this resource

**Check**:
```bash
# In F8 console:
ensure tlw_idcard

# Or check resource status:
restart tlw_idcard
```

### Missing Dependencies Error

**Symptom**: Error messages about missing exports or libraries

**Solutions**:
```lua
-- Ensure these are in server.cfg BEFORE tlw_idcard:
ensure rsg-core
ensure rsg-inventory
ensure ox_lib
ensure ox_target
ensure oxmysql
ensure tlw_idcard
```

### Database Connection Failed

**Symptom**: "MySQL connection error" in console

**Solutions**:
1. Verify oxmysql is properly configured
2. Check `server.cfg` MySQL connection string:
```cfg
set mysql_connection_string "mysql://user:password@localhost/database?charset=utf8mb4"
```
3. Ensure database exists and user has permissions
4. Test MySQL connection with another resource

---

## 🎁 Item Problems

### Items Not Appearing in Inventory

**Symptom**: Photo plate or ID cards don't show up after actions

**Solutions**:

1. **Check items are registered** in `rsg-inventory/config.lua`:
```lua
RSGShared.Items['photo_plate'] = { ... }
RSGShared.Items['id_card_pending'] = { ... }
RSGShared.Items['id_card_citizen'] = { ... }
```

2. **Verify item images exist**:
   - Path: `rsg-inventory/html/images/`
   - Files: `photo_plate.png`, `id_pending.png`, `id_citizen.png`

3. **Check inventory weight limits**:
   - Player might be at max weight
   - Try with empty inventory for testing

4. **Restart inventory resource**:
```
restart rsg-inventory
```

### Items Not Usable

**Symptom**: Can't use ID cards from inventory

**Solutions**:

1. **Register usable items** in `rsg-inventory/server/main.lua`:
```lua
RSGCore.Functions.CreateUseableItem('id_card_pending', function(source, item)
    TriggerClientEvent('tlw_idcard:client:showPendingID', source, item)
end)

RSGCore.Functions.CreateUseableItem('id_card_citizen', function(source, item)
    TriggerClientEvent('tlw_idcard:client:showCitizenID', source, item)
end)
```

2. **Check item configuration**:
```lua
useable = true  -- Must be true
shouldClose = true
```

3. **Restart both resources**:
```
restart rsg-inventory
restart tlw_idcard
```

### Wrong Item Metadata

**Symptom**: ID card shows wrong information

**Solutions**:
1. Clear old items from inventory
2. Resubmit application with correct data
3. Check database for corrupt records:
```sql
SELECT * FROM tlw_id_applications WHERE citizenid = 'YOUR_CITIZEN_ID';
```

---

## 🖥️ UI/NUI Issues

### NUI Not Showing

**Symptom**: Form or ID card doesn't display when triggered

**Solutions**:

1. **Check F8 console for errors**:
   - Look for JavaScript errors
   - Check for missing files

2. **Verify file structure**:
```
tlw_idcard/
├── html/
│   ├── index.html
│   ├── style.css
│   ├── script.js
│   └── assets/
```

3. **Clear FiveM cache**:
   - Close FiveM/RedM completely
   - Delete cache folder: `%localappdata%\RedM\FiveM Application Data\cache`
   - Restart game

4. **Test in browser**:
   - Open `html/index.html` in Chrome
   - Open DevTools (F12) to check for errors
   - Test form submission

### NUI Not Closing

**Symptom**: UI stays open, can't close with ESC

**Solutions**:

1. **Emergency close**: Type in F8 console:
```lua
SetNuiFocus(false, false)
```

2. **Check JavaScript**: Ensure close callback exists in `script.js`:
```javascript
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeUI();
    }
});
```

3. **Verify NUI callback**:
```lua
-- In client/main.lua
RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)
```

### UI Elements Not Displaying Correctly

**Symptom**: Broken layout, missing styles

**Solutions**:

1. **Check Google Fonts loading**:
   - Requires internet connection
   - Or download fonts locally (see UI_PREVIEW.md)

2. **Browser compatibility**:
   - RedM uses CEF (Chromium)
   - Test in Chrome for accurate preview

3. **CSS cache issue**:
   - Modify `style.css` (add a comment)
   - Restart resource

### Stamp Animation Not Working

**Symptom**: Stamp appears instantly without animation

**Solutions**:

1. **Check status in data**:
```javascript
// In script.js
if (data.data.status === 'approved') {
    stampOverlay.classList.remove('hidden');
}
```

2. **Verify CSS animation**:
```css
.stamp-overlay:not(.hidden) .stamp {
    animation: stampAppear 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
```

---

## 💾 Database Problems

### Table Not Created

**Symptom**: SQL errors about missing table

**Solutions**:

1. **Manual table creation**:
```sql
CREATE TABLE IF NOT EXISTS tlw_id_applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50) NOT NULL,
    data LONGTEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    approved_by VARCHAR(50),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_citizenid (citizenid),
    INDEX idx_status (status)
);
```

2. **Check MySQL permissions**:
```sql
GRANT ALL PRIVILEGES ON your_database.* TO 'your_user'@'localhost';
FLUSH PRIVILEGES;
```

### Data Not Saving

**Symptom**: Applications disappear after restart

**Solutions**:

1. **Enable debug mode** in `config.lua`:
```lua
Config.Debug = true
```

2. **Check server console** for SQL errors

3. **Verify oxmysql version**:
   - Update to latest: `ensure oxmysql`

4. **Test query manually**:
```lua
-- In F8 server console
MySQL.query('SELECT * FROM tlw_id_applications', {}, function(result)
    print(json.encode(result))
end)
```

---

## 📢 Discord Webhook Issues

### Webhook Not Sending

**Symptom**: No messages in Discord channel

**Solutions**:

1. **Verify webhook URL**:
   - Must be full URL: `https://discord.com/api/webhooks/...`
   - Check it's not the placeholder: `YOUR_WEBHOOK_URL_HERE`

2. **Test webhook manually**:
```bash
curl -X POST -H "Content-Type: application/json" \
-d '{"content":"Test message"}' \
YOUR_WEBHOOK_URL
```

3. **Enable Discord in config**:
```lua
Config.Discord = {
    enabled = true,  -- Must be true
    webhook = 'https://discord.com/api/webhooks/YOUR_REAL_WEBHOOK',
    ...
}
```

4. **Check server firewall**:
   - Server must allow outbound HTTPS (port 443)

### Webhook Format Issues

**Symptom**: Messages appear but look wrong

**Solutions**:

1. **Check embed structure** in `server/main.lua`
2. **Validate JSON**:
   - Use [Discord Webhook Tester](https://discohook.org/)
3. **Check color code**:
```lua
color = 8388608  -- Must be integer, not hex string
```

---

## ⚡ Performance Issues

### High Resource Usage

**Symptom**: Server lag, high ms on resource

**Solutions**:

1. **Check for infinite loops**:
   - Review any modified code
   - Look for `while true` without `Wait()`

2. **Optimize ox_target zones**:
```lua
-- Use larger radius instead of multiple small zones
radius = 3.0  -- Instead of checking every frame
```

3. **Reduce blip count**:
```lua
Config.PhotographerLocations = {
    -- Only add essential locations
}
```

### UI Lag

**Symptom**: NUI slow to open or close

**Solutions**:

1. **Optimize CSS animations**:
```css
/* Use GPU-accelerated properties */
transform: translateZ(0);
will-change: transform, opacity;
```

2. **Reduce image sizes** (if using custom assets)

3. **Simplify DOM structure** in `index.html`

---

## ❌ Script Errors

### "Attempt to call nil value" Error

**Symptom**: Lua error in console

**Solutions**:

1. **Check export names**:
```lua
local RSGCore = exports['rsg-core']:GetCoreObject()  -- Correct export name
```

2. **Verify resource dependencies** are started

3. **Check function spelling**:
```lua
RSGCore.Functions.GetPlayer(source)  -- Case-sensitive
```

### "No such export" Error

**Symptom**: Can't access inventory functions

**Solutions**:

1. **Verify inventory name**:
```lua
exports['rsg-inventory']:AddItem(...)  -- Must match resource name
```

2. **Check inventory version compatibility**

3. **Try alternative method**:
```lua
-- If export doesn't exist, use TriggerEvent
TriggerEvent('inventory:server:AddItem', ...)
```

### Money Not Deducting

**Symptom**: Player isn't charged fees

**Solutions**:

1. **Check money type**:
```lua
Player.Functions.RemoveMoney('cash', amount)  -- 'cash' or 'money'
```

2. **Verify player object**:
```lua
local Player = RSGCore.Functions.GetPlayer(source)
if not Player then return end  -- Add this check
```

3. **Debug money amount**:
```lua
print('Player cash:', Player.PlayerData.money.cash)
```

---

## 🐛 General Debugging Steps

### Enable Debug Mode

In `config.lua`:
```lua
Config.Debug = true
```

This will print detailed logs to console.

### Check Console Logs

**Server Console** (F8 on server):
- SQL errors
- Server-side script errors
- Debug prints

**Client Console** (F8 in-game):
- NUI errors
- Client-side script errors
- JavaScript errors

### Test Components Individually

1. **Test photo taking**:
   - Go to photographer
   - Check if money deducts
   - Check if item is added

2. **Test application**:
   - Give yourself photo: `/givephoto` (if you added test command)
   - Try submitting form
   - Check database

3. **Test approval**:
   - Use `/approveid [your_id]`
   - Check if item updates

### Common Command for Testing

Add to `server/main.lua` temporarily:
```lua
RegisterCommand('idtest', function(source, args)
    local Player = RSGCore.Functions.GetPlayer(source)
    print('Player:', Player.PlayerData.name)
    print('Cash:', Player.PlayerData.money.cash)
    print('Has photo:', exports['rsg-inventory']:HasItem(source, 'photo_plate', 1))
end)
```

---

## 📞 Still Need Help?

If you've tried everything and still have issues:

1. **Gather information**:
   - Server console logs
   - Client console logs (F8)
   - Steps to reproduce the issue
   - Your config.lua (remove webhook URL)

2. **Check for conflicts**:
   - Disable other ID/document scripts
   - Test with minimal resources

3. **Ask for help**:
   - GitHub Issues: [Create an issue](https://github.com/iboss21/LXR-IDCard/issues)
   - Include all gathered information
   - Be specific about the problem

4. **Community support**:
   - RSG-Core Discord
   - RedM development communities

---

## 🔄 Common Fix Checklist

Before asking for help, try this checklist:

- [ ] All dependencies installed and started
- [ ] Items registered in inventory config
- [ ] Usable items registered
- [ ] Item images exist in inventory images folder
- [ ] Database table exists
- [ ] MySQL connection working
- [ ] Config.lua properly configured
- [ ] Resource restarted after changes
- [ ] Cache cleared (if NUI issue)
- [ ] F8 console checked for errors
- [ ] Debug mode enabled and checked logs
- [ ] Tested with minimal server (no other scripts)

---

**Remember**: Most issues are configuration-related. Double-check all setup steps in INSTALL.md!
