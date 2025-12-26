# Changelog

All notable changes to The Land of Wolves - IDCard System will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

### Planned Features
- Real camera integration for mugshot photos
- Photo preview in Discord webhook
- ID inspection by nearby players
- Lost/stolen ID replacement system
- ID verification for restricted areas/jobs
- Statistics dashboard for admins
- Citizenship expiration/renewal
- Multiple citizenship tiers
- Biometric data (height, weight, eye color)
- Criminal record integration
- Photo gallery for government archives

---

## Version Support

- **Current Version**: 1.0.0
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
