# Changelog

All notable changes to The Land of Wolves - IDCard System will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2025-12-26

### 🚀 Major Release - v3.0 Future Enhancements

This release completes all 12 requested future enhancements, adding advanced features, comprehensive integrations, and extensive customization options.

### ✨ Added

#### 1. Actual Webcam Integration
- HTML5 webcam API for real player photos
- Countdown system (3 seconds default) before photo capture
- Multiple retake functionality (up to 3 retakes)
- Automatic fallback to in-game camera if webcam fails
- Player permission system for camera access
- Configurable resolution (640x480 default) and quality settings
- Privacy-focused: disabled by default

#### 2. Photo Filters and Editing
- Professional photo editing interface
- 5 western-themed filters:
  - Old West Sepia
  - Black & White
  - Vintage
  - Aged Photo
  - No Filter
- Brightness adjustment (50-150%)
- Contrast adjustment (50-150%)
- Image rotation (0°, 90°, 180°, 270°)
- Real-time preview of all edits
- Reset functionality to revert all changes

#### 3. Multiple ID Card Designs per Tier
- Tier-based design options:
  - Basic: 2 designs (Classic, Simple)
  - Premium: 3 designs (Classic, Ornate, Leather)
  - Elite: 4 designs (Classic, Ornate, Royal, Platinum)
- Design change system after issuance ($25 fee)
- ox_lib context menu for design selection
- Unique visual styles per design template

#### 4. Family Tier Packages
- Family citizenship packages with 20% discount
- Two packages:
  - Family Basic: $40/member (2-4 members)
  - Family Premium: $120/member (2-6 members)
- Shared tier benefits across family members
- Family badge display on ID cards
- Optional integration with family/gang scripts

#### 5. Seasonal Tier Bonuses
- Automatic season detection based on real-world months
- Four seasons with unique bonuses:
  - Winter (Dec-Feb): 10-25% discounts
  - Spring (Mar-May): 5-20% discounts
  - Summer (Jun-Aug): 5-20% discounts
  - Autumn (Sep-Nov): 10-25% discounts
- Seasonal badges and bonus items
- Applies to renewals and upgrades
- Configurable per tier

#### 6. Advanced Statistics System
- Complete analytics dashboard overhaul
- 6 key metric cards with animations
- 4 interactive charts:
  - Applications over time (line chart)
  - Tier distribution (doughnut chart)
  - Approval rate (bar chart)
  - Seasonal activity (line chart)
- Data export functionality:
  - CSV export
  - JSON export
- Date range filtering
- Real-time updates (configurable)
- Auto-refresh every 30 seconds
- Beautiful western-themed UI with animations

#### 7. Multi-Language Support
- Comprehensive localization system
- 5 languages included:
  - English (🇺🇸)
  - Spanish (🇪🇸)
  - French (🇫🇷)
  - German (🇩🇪)
  - Portuguese (🇵🇹)
- Player language selection via `/idlanguage` command
- Persistent language preferences
- Easy to add new languages
- Fallback to English for missing translations
- Locale file system in `/locales` directory

#### 8. Custom Tier Creation via Config
- Unlimited custom tier creation
- Config-based tier definition
- Admin command `/createtier` for in-game creation
- Per-tier configuration:
  - Job requirements (optional)
  - Level requirements (optional)
  - Custom colors and badges
  - Unique benefit lists
- Maximum 10 custom tiers limit (configurable)
- Full integration with existing tier system

#### 9. Tier-Specific Perks API
- Comprehensive export API for other scripts
- 15+ exported functions
- Perk types:
  - Shop discounts (0-25%)
  - Job pay bonuses (0-15%)
  - Housing discounts (0-25%)
  - Property tax reductions (0-30%)
  - Fast travel access
  - Custom emotes
  - Custom clothing items
- Server-side only for security
- Cached results for performance
- Complete API documentation in API_GUIDE.md

#### 10. Job System Integration
- Job requirement system
- Citizenship requirements for government jobs
- Tier requirements for specific jobs
- Automatic job pay bonuses by tier
- Framework compatibility:
  - RSG-Core (default)
  - QBR-Core
  - QBX-Core
  - Custom frameworks
- Export functions:
  - `CanTakeJob(source, jobName)`
  - `GetJobBonus(source)`
- Prevents non-citizens from restricted jobs

#### 11. Property System Integration
- Property ownership requirements
- Citizenship required to purchase property
- Tier-based purchase discounts (0-25%)
- Property ownership limits by tier:
  - None: 0 properties
  - Basic: 1 property
  - Premium: 3 properties
  - Elite: 10 properties
- Property tax reductions by tier (0-30%)
- Export functions:
  - `CanPurchaseProperty(source)`
  - `GetPropertyDiscount(source)`
  - `GetPropertyLimit(source)`
  - `GetPropertyTaxReduction(source)`

#### 12. Criminal Record Integration
- Criminal history affects citizenship
- Crime count limits per tier:
  - Basic: 5 crimes max
  - Premium: 2 crimes max
  - Elite: Clean record required
- Criminal status display on ID cards
- Records expire after 90 days (configurable)
- Appeal system for record removal ($100 fee)
- Automatic approval consideration
- Framework compatibility:
  - RSG-Lawman (default)
  - QBR-PoliceJob
  - Custom frameworks
- Export functions:
  - `GetCriminalRecordCount(source)`
  - `CanGetTierWithRecord(source, tier)`

### 📁 New Files

- `server/api.lua` - Complete API export system
- `client/features.lua` - Client-side v3.0 features
- `html/features.html` - New UI components
- `html/features.css` - Styling for new features
- `html/features.js` - JavaScript for new features
- `locales/init.lua` - Locale system initialization
- `locales/en.lua` - English translations
- `locales/es.lua` - Spanish translations
- `V3_FEATURES.md` - Comprehensive feature documentation
- `API_GUIDE.md` - Integration API documentation

### 🔧 Configuration Updates

- Added `Config.Webcam` for webcam integration
- Added `Config.PhotoEditing` for photo editor
- Added `Config.CardDesigns` for multiple designs
- Added `Config.FamilyTiers` for family packages
- Added `Config.SeasonalBonuses` for seasonal system
- Added `Config.AdvancedStatistics` for enhanced stats
- Added `Config.MultiLanguage` for language support
- Added `Config.CustomTiers` for custom tier creation
- Added `Config.TierPerks` for perks API
- Added `Config.JobIntegration` for job system
- Added `Config.PropertyIntegration` for property system
- Added `Config.CriminalRecords` for criminal integration

### 📚 Documentation

- Complete feature documentation in V3_FEATURES.md
- Comprehensive API guide in API_GUIDE.md
- Updated README with v3.0 features
- Updated roadmap showing completed features
- Added integration examples for all features

### 🎨 UI Enhancements

- Webcam capture interface with countdown
- Photo editor with real-time preview
- Advanced statistics dashboard with charts
- Seasonal bonus banner notifications
- Improved button styles and animations
- Responsive design for all new components
- Custom scrollbar styling
- Western-themed animations throughout

### 🔌 API Exports

All functions are server-side and documented in API_GUIDE.md:

**Tier Management:**
- `GetPlayerTier(source)`
- `HasCitizenship(source)`
- `GetPlayerPerks(source)`

**Shop Integration:**
- `GetShopDiscount(source)`

**Job Integration:**
- `CanTakeJob(source, jobName)`
- `GetJobBonus(source)`

**Property Integration:**
- `CanPurchaseProperty(source)`
- `GetPropertyDiscount(source)`
- `GetPropertyLimit(source)`
- `GetPropertyTaxReduction(source)`
- `GetHousingDiscount(source)`

**Criminal Records:**
- `GetCriminalRecordCount(source)`
- `CanGetTierWithRecord(source, tier)`

**Seasonal Features:**
- `GetCurrentSeason()`
- `GetSeasonalBonus(tier)`
- `ApplySeasonalDiscount(price, tier)`

**Other:**
- `CanUseFastTravel(source)`

### 🛡️ Security

- All API functions are server-side only
- Webcam disabled by default for privacy
- Proper validation on all exports
- SQL injection prevention maintained
- Client manipulation prevention

### 🔄 Backward Compatibility

- Fully compatible with v2.0
- No breaking changes to existing functionality
- All new features can be disabled independently
- Existing database schema unchanged
- No migration required from v2.0

### ⚡ Performance

- Minimal performance impact
- Efficient caching for API calls
- Configurable refresh rates
- Optimized database queries
- Lazy loading of features

### 🎮 New Commands

- `/idlanguage` - Change UI language (all players)
- `/createtier` - Create custom tier (admin only)

### 📝 Notes

- All v3.0 features are optional and configurable
- Webcam feature requires HTTPS for production
- Chart.js library required for advanced statistics
- Extensive configuration options available
- Complete API documentation provided

---

## [2.0.0] - 2025-12-26

### 🎉 Major Release - Complete Roadmap Implementation

This release implements all 6 phases from the roadmap, transforming the ID card system into a comprehensive citizenship management solution.

### ✨ Added

#### Phase 1: Camera Script Integration for Real Mugshots
- Camera system for capturing player mugshots with 3D camera positioning
- Photo data storage in item metadata
- Mugshot display on ID cards (replaces placeholder)
- Configurable camera settings (FOV, offset, duration)
- Smooth camera transitions and animations

#### Phase 2: ID Inspection by Nearby Players
- ox_target global player interaction for ID inspection
- Distance-based permission checking (3.0 units default)
- Request/approval system with ox_lib dialogs
- Ability to accept or deny inspection requests
- Same UI for viewing inspected IDs

#### Phase 3: Lost/Stolen ID Replacement System
- ID replacement at government offices ($150 fee)
- 24-hour cooldown between replacements
- Maximum replacement limit (5 default)
- Database tracking of all replacements
- New database table: `tlw_id_replacements`

#### Phase 4: Citizenship Expiration/Renewal
- Automatic 30-day expiration for all IDs
- Expiration date displayed on ID cards
- Warning notifications 7 days before expiration
- Renewal system at government offices ($75 fee)
- Database tracking of renewals
- New database table: `tlw_id_renewals`

#### Phase 5: Multiple Citizenship Tiers
- Three tiers: Basic ($50), Premium ($150), Elite ($500)
- Tier-specific benefits and pricing
- Tier badges on ID cards with icons (📋⭐👑)
- Tier upgrade system with 50% refund
- ox_lib context menu for tier selection

#### Phase 6: Statistics Dashboard
- Admin command `/idstats` to view statistics
- Beautiful dashboard tracking 6 metrics
- Tier distribution visualization with bar charts
- Real-time statistics tracking
- New database table: `tlw_id_statistics`

### 🗄️ Database Changes
- Added `tier` and `expiration_date` columns to `tlw_id_applications`
- Created `tlw_id_replacements` table
- Created `tlw_id_renewals` table
- Created `tlw_id_statistics` table

### 🎨 UI Enhancements
- Photo image display on ID cards
- Tier badge in top-right corner
- Expiration date row
- Complete statistics dashboard
- Color-coded tier indicators

### ⚙️ Configuration
- New `Config.Camera` section
- New `Config.Inspection` section
- New `Config.Replacement` section
- New `Config.Expiration` section
- New `Config.Tiers` section
- New `Config.Statistics` section
- 20+ new locale strings

### 📚 Documentation
- Added `ROADMAP_IMPLEMENTATION.md`
- Added `MIGRATION_GUIDE.md`
- Updated `README.md` for v2.0
- Updated `version.json`

### 🔧 Technical
- 8 new server events
- Enhanced photo system
- Statistics tracking helper
- Expiration calculation helper
- Improved cooldown management

## [1.0.0] - 2025-12-26

### Added
- Initial release of The Land of Wolves ID Card System
- Multi-stage citizenship application process
  - Photographer locations for taking mugshots
  - Government office locations for submitting applications
  - Admin review and approval system
- Beautiful wolf-themed western UI
  - Aged parchment design with wolf claw scratches
  - Victorian gold borders with wolf head motifs
  - Animated stamp reveal for approved citizens
  - Responsive design with custom fonts (Cinzel, IM Fell English)
- Database integration
  - MySQL table for storing applications
  - Persistent citizen records
  - Application status tracking (pending, approved, denied)
- Discord webhook integration
  - Automatic notifications on new applications
  - Detailed player information in embeds
  - Admin command suggestions in footer
- Two-tier ID card system
  - `photo_plate` item for mugshots
  - `id_card_pending` for resident permits (no stamp)
  - `id_card_citizen` for approved citizenship (with stamp)
- Admin commands
  - `/approveid [serverid]` to approve applications
  - `/denyid [serverid]` to deny applications
- Cooldown system
  - Photo taking cooldown (60 seconds default)
  - Application submission cooldown (300 seconds default)
- ox_target integration
  - Interactive zones for photographer
  - Interactive zones for government offices
  - Context-aware prompts (requires photo plate for application)
- Map blips
  - Photographer locations marked with camera icon
  - Government offices marked with document icon
  - Configurable colors and labels
- Animation support
  - Paper hold animation when showing ID
  - Infrastructure for sound effects
- Comprehensive configuration
  - All locations configurable
  - All fees configurable
  - All text/locale configurable
  - Discord settings configurable
  - Cooldowns configurable
- Debug mode for troubleshooting
- Full documentation
  - Detailed README.md
  - Complete INSTALL.md guide
  - Asset documentation
  - Code comments throughout

### Framework Support
- RSG-Core framework integration
- rsg-inventory compatibility
- ox_lib utilities
- ox_target for interactions
- oxmysql for database

### UI/UX
- Smooth fade-in animations
- Stamp reveal animation with rotation
- Form validation
- ESC key to close
- Scrollable content with custom scrollbar
- Responsive layout
- Professional typography

### Security
- Server-side validation for all transactions
- Money checks before processing
- Item checks before allowing actions
- Cooldown system to prevent spam
- Admin permission checks for commands
- SQL injection prevention with parameterized queries

### Performance
- Optimized database queries with indexes
- Efficient ox_target zones
- Minimal client-side loops
- Lazy-loaded UI
- Clean event handlers

## [Unreleased]

### Potential Future Features
- Actual webcam integration for photos
- Photo filters and editing
- Multiple ID card designs per tier
- Family tier packages
- Seasonal tier bonuses
- Advanced statistics filtering and export
- Integration with additional frameworks
- Multi-language support
- Custom tier creation via config
- Tier-specific perks API for other scripts

---

## Version Support

- **Current Version**: 2.0.0
- **RedM Version**: Latest
- **RSG-Core**: Latest
- **Lua Version**: 5.4

## Upgrading

When upgrading to a new version:
1. Always backup your database and config files
2. Read the changelog for breaking changes
3. Update config.lua with any new options
4. Restart the resource
5. Test thoroughly on a development server first

## Support

For issues, please visit: https://github.com/iboss21/LXR-IDCard/issues
