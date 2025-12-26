# 🐺 The Land of Wolves - ID Card System

**An immersive, premium-quality citizenship ID card system for RedM servers using RSG-Core framework.**

[![Framework](https://img.shields.io/badge/Framework-RSG--Core-blue)](https://github.com/Rexshack-RedM/rsg-core)
[![Version](https://img.shields.io/badge/version-3.0.0-green)]()
[![RedM](https://img.shields.io/badge/RedM-Compatible-red)]()

> **Version 3.0** - Enhanced with advanced features and integrations! 🎉

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

**🆕 NEW ROADMAP FEATURES** (v2.0):
- **📸 Camera Integration**: Real player mugshots on ID cards
- **👥 ID Inspection**: Players can inspect each other's IDs
- **🔄 ID Replacement**: Lost/stolen ID replacement system ($150, 24hr cooldown)
- **📅 Expiration & Renewal**: 30-day ID validity with renewal system
- **⭐ Citizenship Tiers**: Basic ($50), Premium ($150), Elite ($500) with unique benefits
- **📊 Statistics Dashboard**: Admin dashboard tracking all system metrics

**🎉 NEW v3.0 FEATURES**:
- **🎥 Actual Webcam Integration**: Real player photos using HTML5 webcam API
- **🎨 Photo Filters & Editing**: Professional photo editing with 5 filters
- **🎴 Multiple ID Designs**: Tier-specific card templates (up to 4 designs per tier)
- **👨‍👩‍👧‍👦 Family Tier Packages**: Discounted citizenship for families (20% off)
- **🍂 Seasonal Bonuses**: Special bonuses based on seasons (5-25% discounts)
- **📈 Advanced Statistics**: Charts, graphs, and data exports (CSV/JSON)
- **🌍 Multi-Language Support**: 5 languages (EN, ES, FR, DE, PT)
- **⚙️ Custom Tier Creation**: Create unlimited custom tiers via config
- **🔌 Tier Perks API**: Integration API for shops, jobs, and properties
- **💼 Job System Integration**: Job requirements and pay bonuses by tier
- **🏠 Property Integration**: Property ownership limits and discounts by tier
- **⚖️ Criminal Records**: Criminal history affects citizenship approval

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

**Basic Flow:**
1. Visit a **Photographer** (map blip) and take a mugshot ($20)
2. Go to **Government Office** (map blip) and submit citizenship application
3. **Choose your tier**: Basic ($50), Premium ($150), or Elite ($500) 🆕
4. Receive **Resident Permit** (pending approval)
5. Wait for admin to review application
6. Once approved, permit upgrades to **Citizenship Card** with official stamp
7. Use ID card from inventory to show your status

**🆕 New Features:**

**📸 Mugshot Photos**
- Real camera system captures your character
- Photo appears on your ID card
- Replaces generic placeholder

**👥 ID Inspection**
- Target nearby players with ox_target
- Request to inspect their ID
- They can accept or deny your request
- View their full ID information

**🔄 ID Replacement**
- Lost your ID? Visit government office
- Pay $150 replacement fee (higher than original)
- 24-hour cooldown between replacements
- Maximum 5 replacements allowed

**📅 Expiration & Renewal**
- IDs expire after 30 days
- Warning notifications 7 days before expiration
- Renew at government office for $75
- Extends validity for 30 more days

**⭐ Citizenship Tiers**
- **Basic** ($50): Standard rights and services
- **Premium** ($150): Priority service + 10% discounts
- **Elite** ($500): VIP status + 25% discounts + exclusive access
- Upgrade your tier anytime at government office
- Get 50% refund of previous tier when upgrading

### For Admins
1. Receive Discord notification when player applies
2. Review application details including tier selection
3. Use `/approveid [playerid]` to grant citizenship
4. Use `/denyid [playerid]` to reject application
5. **🆕 Use `/idstats` to view comprehensive statistics dashboard**
6. Player's ID automatically upgrades with stamp overlay

**🆕 Statistics Dashboard** includes:
- Total applications, approvals, denials
- Pending applications count
- ID replacements and renewals
- Citizenship tier distribution with charts
- All metrics tracked automatically

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
| `/idstats` | admin | View system statistics dashboard 🆕 |
| `/idlanguage` | all | Change UI language (v3.0) 🆕 |
| `/createtier` | admin | Create custom citizenship tier (v3.0) 🆕 |

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

**v2.0 Features** ✅ (Complete):
- [x] **Camera script integration for real mugshots** ✅
- [x] **ID inspection by nearby players** ✅
- [x] **Lost/stolen ID replacement system** ✅
- [x] **Citizenship expiration/renewal** ✅
- [x] **Multiple citizenship tiers** ✅
- [x] **Statistics dashboard** ✅

**v3.0 Features** ✅ (Complete):
- [x] **Actual webcam integration** ✅
- [x] **Photo filters and editing** ✅
- [x] **Multiple ID card designs per tier** ✅
- [x] **Family tier packages** ✅
- [x] **Seasonal tier bonuses** ✅
- [x] **Advanced statistics (charts, graphs, exports)** ✅
- [x] **Multi-language support** ✅
- [x] **Custom tier creation via config** ✅
- [x] **Tier-specific perks API** ✅
- [x] **Integration with job systems** ✅
- [x] **Integration with property systems** ✅
- [x] **Criminal record integration** ✅

**Future Considerations**:
- [ ] Integration with additional frameworks
- [ ] Mobile-responsive UI improvements
- [ ] AI-powered photo enhancement
- [ ] Blockchain-based verification

📖 **See [ROADMAP_IMPLEMENTATION.md](ROADMAP_IMPLEMENTATION.md) for complete feature documentation**

🔄 **Upgrading? See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for migration instructions**

---

**Made with ❤️ for the RedM roleplay community**  
*The Land of Wolves - Where only the strong survive* 🐺
