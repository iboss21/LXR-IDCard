# ⚡ Quick Start Guide

**Get The Land of Wolves IDCard System running in 10 minutes!**

---

## 📦 What You Need

- RedM server with RSG-Core
- MySQL database
- These resources installed:
  - `rsg-core`
  - `rsg-inventory`
  - `ox_lib`
  - `ox_target`
  - `oxmysql`

---

## 🚀 5-Step Installation

### Step 1: Download & Install (2 minutes)

```bash
# Navigate to your resources folder
cd resources

# Clone the repository
git clone https://github.com/iboss21/LXR-IDCard.git tlw_idcard

# Or download and extract ZIP, rename folder to "tlw_idcard"
```

### Step 2: Add Items (3 minutes)

Open `rsg-inventory/config.lua` and add these items:

```lua
['photo_plate'] = {
    name = 'photo_plate',
    label = 'Photo Plate',
    weight = 100,
    type = 'item',
    image = 'photo_plate.png',
    unique = true,
    useable = false,
    description = 'A photographic plate for identification'
},

['id_card_pending'] = {
    name = 'id_card_pending',
    label = 'Resident Permit',
    weight = 50,
    type = 'item',
    image = 'id_pending.png',
    unique = true,
    useable = true,
    description = 'A resident permit pending full citizenship approval'
},

['id_card_citizen'] = {
    name = 'id_card_citizen',
    label = 'Citizenship Card',
    weight = 50,
    type = 'item',
    image = 'id_citizen.png',
    unique = true,
    useable = true,
    description = 'Official Citizenship Card of The Land of Wolves'
},
```

### Step 3: Register Usable Items (1 minute)

Open `rsg-inventory/server/main.lua` and add:

```lua
RSGCore.Functions.CreateUseableItem('id_card_pending', function(source, item)
    TriggerClientEvent('tlw_idcard:client:showPendingID', source, item)
end)

RSGCore.Functions.CreateUseableItem('id_card_citizen', function(source, item)
    TriggerClientEvent('tlw_idcard:client:showCitizenID', source, item)
end)
```

### Step 4: Configure (2 minutes)

Open `tlw_idcard/config.lua` and set:

1. **Locations** (use `/getcoords` command in-game):
```lua
Config.PhotographerLocations = {
    {
        name = "Valentine Photographer",
        coords = vector3(-173.61, 627.16, 114.09),  -- YOUR COORDS HERE
        heading = 90.0,
        blip = true
    },
}

Config.GovernmentOffices = {
    {
        name = "Valentine Town Hall",
        coords = vector3(-275.96, 780.13, 118.50),  -- YOUR COORDS HERE
        heading = 180.0,
        blip = true
    },
}
```

2. **Discord Webhook** (optional):
```lua
Config.Discord = {
    enabled = true,
    webhook = 'YOUR_DISCORD_WEBHOOK_URL_HERE',  -- Paste your webhook
    ...
}
```

### Step 5: Start the Resource (1 minute)

Add to `server.cfg`:
```cfg
ensure tlw_idcard
```

Restart your server or use:
```
refresh
ensure tlw_idcard
```

---

## ✅ Test It!

1. **Join your server**
2. **Go to photographer location** (check map for blip)
3. **Take a photo** (costs $20)
4. **Go to government office** (check map for blip)
5. **Submit application** (costs $50)
6. **Receive Resident Permit**
7. **Admin approves**: `/approveid [your_server_id]`
8. **Use ID card** from inventory to see the beautiful UI!

---

## 🎨 Item Images (Optional)

For a complete experience, add these images to `rsg-inventory/html/images/`:
- `photo_plate.png` - Camera icon
- `id_pending.png` - Document icon
- `id_citizen.png` - Official seal document icon

*(Script works without images, they just won't display in inventory)*

---

## 🔧 Common Issues

### "Items not showing in inventory"
- Did you restart `rsg-inventory` after adding items?
- Try: `restart rsg-inventory`

### "Can't use ID cards"
- Did you register usable items in inventory server file?
- Did you restart `rsg-inventory`?

### "NUI not opening"
- Check F8 console for errors
- Clear RedM cache: `%localappdata%\RedM\FiveM Application Data\cache`

### "Database errors"
- Make sure `oxmysql` is running
- Check your MySQL connection string in `server.cfg`

---

## 🎮 How to Use (For Players)

### Getting Citizenship:

1. **Visit Photographer** → Take mugshot photo ($20)
2. **Visit Government Office** → Submit application ($50)
3. **Wait for Admin** → Application review
4. **Get Approved** → Receive Citizenship Card
5. **Show ID** → Use from inventory anytime!

### For Admins:

```
/approveid [player_server_id]   # Approve citizenship
/denyid [player_server_id]      # Deny citizenship
```

---

## 📚 Need More Help?

**Full documentation available:**
- 📖 [Full Installation Guide](INSTALL.md) - Detailed setup
- 🔧 [Troubleshooting Guide](../guides/TROUBLESHOOTING.md) - Fix common issues
- 🎨 [UI_PREVIEW.md](UI_PREVIEW.md) - Customize the design
- ⚙️ [config_examples.lua](config_examples.lua) - Configuration scenarios

**Join the community:**
- 🐛 Report bugs: [GitHub Issues](https://github.com/iboss21/LXR-IDCard/issues)
- 💬 Get help: [GitHub Discussions](https://github.com/iboss21/LXR-IDCard/discussions)

---

## 🎉 You're Done!

Your server now has a premium, immersive citizenship ID card system!

**What's Next?**
- Customize locations to match your server
- Adjust fees to your economy
- Set up Discord webhook for admin notifications
- Add custom item images
- Customize the wolf branding to your server's theme

---

**The Land of Wolves - Where only the strong survive** 🐺

*Made with ❤️ for the RedM roleplay community*
