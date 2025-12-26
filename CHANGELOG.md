# Changelog

All notable changes to The Land of Wolves - IDCard System will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
