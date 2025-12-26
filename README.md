# 🐺 The Land of Wolves - ID Card System

**An immersive, premium-quality citizenship ID card system for RedM servers using RSG-Core framework.**

[![Framework](https://img.shields.io/badge/Framework-RSG--Core-blue)](https://github.com/Rexshack-RedM/rsg-core)
[![Version](https://img.shields.io/badge/version-1.0.0-green)]()
[![RedM](https://img.shields.io/badge/RedM-Compatible-red)]()

---

## ✨ Overview

The Land of Wolves IDCard script transforms citizenship into an engaging roleplay experience. Players must photograph themselves, submit detailed applications, and await admin approval before earning full citizenship status—complete with a beautifully animated approval stamp.

### 🎯 Key Features

- **Multi-Stage RP Flow**: Photo → Application → Review → Citizenship
- **Stunning Wolf-Themed UI**: Aged parchment, Victorian gold borders, wolf emblems
- **Discord Integration**: Automated admin notifications with webhook
- **Two-Tier ID System**: Resident Permit (pending) vs Citizenship Card (approved)
- **Animated Stamp Reveal**: Dramatic red approval stamp for citizens
- **Database Persistence**: MySQL storage for all applications
- **Admin Commands**: Easy approval/denial system
- **Fully Configurable**: Locations, fees, text, cooldowns

---

## 📸 Preview

*Coming Soon: Screenshots of the application form and ID cards*

---

## 🚀 Quick Start

### Requirements
- RSG-Core
- rsg-inventory (ox_inventory based)
- ox_lib
- ox_target
- oxmysql

### Installation

1. **Clone the repository**
   ```bash
   cd resources
   git clone https://github.com/iboss21/LXR-IDCard.git tlw_idcard
   ```

2. **Add items to inventory** (see [INSTALL.md](INSTALL.md))

3. **Configure locations and webhook** in `config.lua`

4. **Add to server.cfg**
   ```
   ensure tlw_idcard
   ```

5. **Restart server**

📖 **Full installation guide**: [INSTALL.md](INSTALL.md)

---

## 🎮 How It Works

### For Players
1. Visit a **Photographer** (map blip) and take a mugshot ($20)
2. Go to **Government Office** (map blip) and submit citizenship application ($50)
3. Receive **Resident Permit** (pending approval)
4. Wait for admin to review application
5. Once approved, permit upgrades to **Citizenship Card** with official stamp
6. Use ID card from inventory to show your status

### For Admins
1. Receive Discord notification when player applies
2. Use `/approveid [playerid]` to grant citizenship
3. Use `/denyid [playerid]` to reject application
4. Player's ID automatically upgrades with stamp overlay

---

## ⚙️ Configuration Highlights

```lua
-- Customize locations
Config.PhotographerLocations = { ... }
Config.GovernmentOffices = { ... }

-- Set fees
Config.PhotoFee = 20.0
Config.ApplicationFee = 50.0

-- Discord webhook
Config.Discord.webhook = 'YOUR_WEBHOOK_URL'

-- Customize all text
Config.Locale = { ... }
```

---

## 🎨 UI Design Philosophy

The UI embraces a **dark western frontier aesthetic**:
- **Parchment textures** with aged stains and tears
- **Wolf claw scratch marks** in corners
- **Victorian gold borders** with wolf head motifs
- **Cinzel Decorative** and **IM Fell English** fonts
- **Animated stamp reveal** for approved citizens
- **Responsive design** for various resolutions

---

## 🛠️ Tech Stack

- **Framework**: RSG-Core (RedM)
- **Inventory**: rsg-inventory / ox_inventory
- **UI Library**: ox_lib
- **Targeting**: ox_target
- **Database**: oxmysql
- **Frontend**: HTML5, CSS3 (Google Fonts), Vanilla JS
- **Integration**: Discord Webhooks

---

## 📋 Commands

| Command | Permission | Description |
|---------|-----------|-------------|
| `/approveid [id]` | admin | Approve citizenship application |
| `/denyid [id]` | admin | Deny citizenship application |

---

## 🐛 Troubleshooting

**Items not showing up?**  
Make sure you've added the items to your inventory config and registered usable items.

**NUI not displaying?**  
Check F8 console for errors. Ensure all files are in the correct directories.

**Discord webhook not working?**  
Verify your webhook URL in `config.lua` and ensure it's not set to the placeholder.

Enable debug mode for detailed logs:
```lua
Config.Debug = true
```

---

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request with detailed description

---

## 📄 License

Open source - feel free to modify and redistribute.

---

## 💬 Support & Community

- **Issues**: [GitHub Issues](https://github.com/iboss21/LXR-IDCard/issues)
- **Discussions**: [GitHub Discussions](https://github.com/iboss21/LXR-IDCard/discussions)

---

## 🌟 Showcase

Using this script on your server? Let us know! We'd love to feature your community.

---

## 🔮 Roadmap

- [ ] Camera script integration for real mugshots
- [ ] ID inspection by nearby players
- [ ] Lost/stolen ID replacement system
- [ ] Citizenship expiration/renewal
- [ ] Multiple citizenship tiers
- [ ] Statistics dashboard

---

**Made with ❤️ for the RedM roleplay community**  
*The Land of Wolves - Where only the strong survive* 🐺
