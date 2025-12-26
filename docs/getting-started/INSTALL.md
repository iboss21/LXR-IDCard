# The Land of Wolves - ID Card System

An immersive, beautifully designed citizenship ID card system for RedM servers using RSG-Core framework. This script creates a multi-stage roleplay experience where players must earn their citizenship through a comprehensive application process.

![The Land of Wolves](https://img.shields.io/badge/Framework-RSG--Core-blue)
![Version](https://img.shields.io/badge/version-1.0.0-green)
![RedM](https://img.shields.io/badge/RedM-Compatible-red)

## 🐺 Features

### Core Gameplay
- **Multi-Stage Process**: Photo taking → Application submission → Admin review → Citizenship approval
- **Beautiful Western-Themed UI**: Aged parchment design with wolf motifs and Victorian borders
- **Discord Integration**: Automatic webhook notifications for admin review
- **Database Persistence**: All applications stored in MySQL database
- **Two-Tier System**: 
  - `Resident Permit` (pending approval - no stamp)
  - `Citizenship Card` (approved - with animated red stamp)

### Immersive Details
- **Wolf Theme**: "The Land of Wolves" branding with wolf emblems and claw mark accents
- **Animated Stamp**: Dramatic stamp reveal for approved citizens
- **Paper Hold Animation**: Players hold paper when showing ID
- **Sound Effects Ready**: Infrastructure for paper rustle and stamp sounds
- **Blips & Targeting**: ox_target integration with configurable locations

### Admin Tools
- `/approveid [serverid]` - Approve citizenship application
- `/denyid [serverid]` - Deny citizenship application
- Discord webhook with all player information and approval commands

## 📋 Requirements

- [RSG-Core](https://github.com/Rexshack-RedM/rsg-core)
- [rsg-inventory](https://github.com/Rexshack-RedM/rsg-inventory) (or compatible ox_inventory fork)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [oxmysql](https://github.com/overextended/oxmysql)

## 🔧 Installation

### 1. Download and Install
```bash
cd resources
git clone https://github.com/iboss21/LXR-IDCard.git tlw_idcard
```

### 2. Add Items to Inventory
Add these items to your `rsg-inventory/config.lua` or items database:

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

### 3. Register Usable Items
Add to your `rsg-inventory/server/main.lua` or wherever you register usable items:

```lua
RSGCore.Functions.CreateUseableItem('id_card_pending', function(source, item)
    TriggerClientEvent('tlw_idcard:client:showPendingID', source, item)
end)

RSGCore.Functions.CreateUseableItem('id_card_citizen', function(source, item)
    TriggerClientEvent('tlw_idcard:client:showCitizenID', source, item)
end)
```

### 4. Configure Script
Edit `config.lua`:
- Set photographer and government office locations
- Configure fees (photo fee, application fee)
- Add your Discord webhook URL
- Customize locale/text
- Adjust cooldowns

### 5. Add to server.cfg
```
ensure tlw_idcard
```

### 6. Create Item Images
Add these images to your inventory images folder:
- `photo_plate.png` - Camera/photograph icon
- `id_pending.png` - Document without stamp
- `id_citizen.png` - Document with official stamp/seal

## 🎮 Usage

### For Players

1. **Take a Photo**
   - Visit a photographer location (check map for blips)
   - Pay the photo fee ($20 default)
   - Receive a Photo Plate item

2. **Submit Application**
   - Go to a Government Office (check map for blips)
   - Must have Photo Plate in inventory
   - Fill out the citizenship application form
   - Pay application fee ($50 default)
   - Receive Resident Permit (pending status)

3. **Wait for Approval**
   - Application sent to Discord for admin review
   - Admins will approve or deny

4. **Show Your ID**
   - Use the ID card from inventory
   - Beautiful NUI display opens
   - Approved citizens see the official stamp

### For Admins

1. **Review Applications**
   - Check Discord webhook for new applications
   - Review player information

2. **Approve/Deny**
   - `/approveid [playerid]` - Approve citizenship
   - `/denyid [playerid]` - Deny citizenship
   
3. **Player Receives Notification**
   - Pending card automatically upgraded to citizen card
   - Player sees success notification

## ⚙️ Configuration

### Location Setup
```lua
Config.PhotographerLocations = {
    {
        name = "Saint Denis Photographer",
        coords = vector3(x, y, z),
        heading = 90.0,
        blip = true
    },
}

Config.GovernmentOffices = {
    {
        name = "Valentine Clerk Office",
        coords = vector3(x, y, z),
        heading = 180.0,
        blip = true
    },
}
```

### Discord Webhook
```lua
Config.Discord = {
    enabled = true,
    webhook = 'https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE',
    botName = 'The Land of Wolves - Immigration',
    color = 8388608 -- Dark red
}
```

### Fees & Cooldowns
```lua
Config.PhotoFee = 20.0
Config.ApplicationFee = 50.0

Config.Cooldowns = {
    photo = 60, -- 1 minute
    application = 300 -- 5 minutes
}
```

## 🎨 Customization

### UI Theming
Edit `html/style.css` to customize:
- Colors (search for color codes)
- Fonts (currently using Google Fonts: Cinzel Decorative, Cinzel, IM Fell English)
- Layout dimensions
- Animation timings

### Locale/Text
All text is configurable in `config.lua` under `Config.Locale`:
```lua
Config.Locale = {
    photographer_prompt = 'Take Mugshot Photo',
    government_prompt = 'Submit Citizenship Application',
    card_title = 'THE LAND OF WOLVES',
    -- ... etc
}
```

### Territory Branding
Change the territory name:
```lua
Config.TerritoryName = "Your Territory Name"
Config.GovernorName = "Your Governor Title"
```

## 🔒 Permissions

Admin commands require the ACE permission:
```lua
Config.AdminAce = 'admin' -- Change if needed
```

Add to your `server.cfg`:
```
add_ace group.admin command.approveid allow
add_ace group.admin command.denyid allow
```

## 📊 Database

The script automatically creates this table:
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
)
```

## 🐛 Debugging

Enable debug mode in `config.lua`:
```lua
Config.Debug = true
```

This will print detailed logs to server/client console.

## 📝 Credits

**Script Development**: The Land of Wolves Team  
**Framework**: RSG-Core  
**UI Design**: Custom wolf-themed western aesthetic  
**Inspired by**: Red Dead Redemption 2 immersive roleplay

## 📄 License

This project is open source and available for modification and redistribution.

## 🤝 Support

For issues, suggestions, or contributions:
- Open an issue on GitHub
- Join our Discord community
- Submit pull requests for improvements

## 🚀 Future Features (Planned)

- [ ] Photo capture integration with camera scripts
- [ ] Mugshot preview in Discord webhook
- [ ] ID card inspection by other players (nearby)
- [ ] Lost/stolen ID replacement system
- [ ] ID verification for restricted areas/jobs
- [ ] Statistics tracking (total citizens, pending, denied)
- [ ] Citizenship expiration/renewal system
- [ ] Multiple citizenship tiers (resident, citizen, honored citizen)

---

**Made with ❤️ for the RedM roleplay community**  
*The Land of Wolves - Where only the strong survive* 🐺
