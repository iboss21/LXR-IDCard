# 🧪 Testing Checklist

Comprehensive testing checklist for The Land of Wolves IDCard System before deploying to production.

---

## ✅ Pre-Deployment Testing

### 1. Installation Verification

- [ ] All files present in correct directories
- [ ] fxmanifest.lua has no syntax errors
- [ ] Dependencies installed (RSG-Core, rsg-inventory, ox_lib, ox_target, oxmysql)
- [ ] Resource starts without errors (`ensure tlw_idcard`)
- [ ] No errors in server console (F8)
- [ ] No errors in client console (F8)

### 2. Configuration Testing

- [ ] config.lua properly configured
- [ ] Photographer locations set to valid coordinates
- [ ] Government office locations set to valid coordinates
- [ ] Fees set to desired amounts
- [ ] Discord webhook configured (if using)
- [ ] Locale text reviewed and customized
- [ ] Cooldowns set appropriately

### 3. Database Testing

- [ ] MySQL connection working
- [ ] Table `tlw_id_applications` created successfully
- [ ] Can insert test data manually
- [ ] Can query data successfully
- [ ] Indexes created properly

**Test Query:**
```sql
SHOW TABLES LIKE 'tlw_id_applications';
DESCRIBE tlw_id_applications;
SELECT * FROM tlw_id_applications LIMIT 1;
```

### 4. Inventory Integration

- [ ] Items registered in rsg-inventory config
- [ ] Item images exist in inventory images folder
  - [ ] photo_plate.png
  - [ ] id_pending.png
  - [ ] id_citizen.png
- [ ] Usable items registered in inventory server file
- [ ] Items appear in inventory when given
- [ ] Items can be used from inventory

**Test Commands** (add temporarily):
```lua
/givephoto
/givependingid
/givecitizenid
```

---

## 🎮 Gameplay Testing

### A. Photographer Functionality

**Test 1: Taking a Photo**
- [ ] Approach photographer location
- [ ] ox_target prompt appears
- [ ] Prompt shows correct fee amount
- [ ] Click prompt
- [ ] Money deducted from player ($20 default)
- [ ] Photo plate item added to inventory
- [ ] Success notification appears
- [ ] Check inventory to verify photo plate

**Test 2: Insufficient Funds**
- [ ] Remove all money from character
- [ ] Try to take photo
- [ ] Error notification appears
- [ ] No item given
- [ ] No money deducted

**Test 3: Cooldown System**
- [ ] Take a photo successfully
- [ ] Immediately try to take another
- [ ] Cooldown message appears with time remaining
- [ ] Wait for cooldown to expire (60 seconds default)
- [ ] Can take photo again

**Test 4: Multiple Photographers**
- [ ] Visit each photographer location
- [ ] Verify all locations work correctly
- [ ] Blips visible on map (if enabled)

### B. Application Submission

**Test 1: Successful Application**
- [ ] Have photo plate in inventory
- [ ] Have sufficient funds ($50 default)
- [ ] Approach government office
- [ ] ox_target prompt appears
- [ ] Click prompt
- [ ] Application form opens correctly
- [ ] All fields are editable
- [ ] Fill all required fields
- [ ] Click "Submit Application"
- [ ] Form closes
- [ ] Money deducted
- [ ] Photo plate removed from inventory
- [ ] Pending ID card added to inventory
- [ ] Success notification appears

**Test 2: Form Validation**
- [ ] Open form
- [ ] Try to submit with empty fields
- [ ] Validation error appears
- [ ] Form doesn't close
- [ ] Fill one field, leave others empty
- [ ] Validation catches it

**Test 3: No Photo Plate**
- [ ] Remove photo plate from inventory
- [ ] Try to interact with government office
- [ ] Prompt doesn't appear OR error message shows
- [ ] Can't submit application

**Test 4: Insufficient Funds**
- [ ] Have photo plate
- [ ] Remove money
- [ ] Open form and try to submit
- [ ] Error notification appears
- [ ] Application not processed

**Test 5: Cooldown**
- [ ] Submit application successfully
- [ ] Immediately try to submit another
- [ ] Cooldown message appears
- [ ] Wait for cooldown (300 seconds default)
- [ ] Can submit again

**Test 6: Form Cancel**
- [ ] Open form
- [ ] Fill in some data
- [ ] Click "Cancel"
- [ ] Form closes
- [ ] No money deducted
- [ ] Photo plate still in inventory

**Test 7: ESC Key**
- [ ] Open form
- [ ] Press ESC key
- [ ] Form closes properly
- [ ] Can move and play normally

### C. ID Card Display

**Test 1: Pending ID Card**
- [ ] Use pending ID card from inventory
- [ ] UI opens showing card
- [ ] Player name displays correctly
- [ ] Birthdate displays correctly
- [ ] Birthplace displays correctly
- [ ] Occupation displays correctly
- [ ] Citizen ID displays correctly
- [ ] Issued date displays correctly
- [ ] Card shows "RESIDENT PERMIT"
- [ ] Card shows "PENDING FULL CITIZENSHIP"
- [ ] NO stamp visible
- [ ] Player plays hold-paper animation
- [ ] ESC closes the card
- [ ] Animation stops when closed

**Test 2: Citizen ID Card**
- [ ] Get approved (use /approveid)
- [ ] Use citizen ID card from inventory
- [ ] UI opens showing card
- [ ] All info displays correctly
- [ ] Card shows "TERRITORIAL IDENTIFICATION"
- [ ] Card shows "CITIZEN OF THE LAND OF WOLVES"
- [ ] Stamp IS visible
- [ ] Stamp animates in (scales, rotates)
- [ ] Stamp is red and clearly visible
- [ ] ESC closes the card

### D. Admin Commands

**Test 1: Approve Command**
- [ ] Player has pending ID card
- [ ] Admin uses `/approveid [playerid]`
- [ ] Pending ID removed from player inventory
- [ ] Citizen ID added to player inventory
- [ ] Player receives approval notification
- [ ] Admin receives confirmation
- [ ] Database status updated to 'approved'
- [ ] Check database to verify

**Test 2: Deny Command**
- [ ] Player has pending ID card
- [ ] Admin uses `/denyid [playerid]`
- [ ] Pending ID removed from inventory
- [ ] Player receives denial notification
- [ ] Admin receives confirmation
- [ ] Database status updated to 'denied'
- [ ] Player can reapply

**Test 3: Invalid Player ID**
- [ ] Use `/approveid 999999` (invalid ID)
- [ ] Error message appears
- [ ] Nothing breaks

**Test 4: No Pending Application**
- [ ] Player has no pending ID
- [ ] Try `/approveid [playerid]`
- [ ] Error message appears
- [ ] Nothing given to player

**Test 5: Permissions**
- [ ] Non-admin tries `/approveid`
- [ ] Permission denied message
- [ ] Command doesn't execute

### E. Discord Webhook

**Test 1: Webhook Sends**
- [ ] Discord webhook configured in config
- [ ] Player submits application
- [ ] Check Discord channel
- [ ] Message appears within seconds
- [ ] Embed format looks correct

**Test 2: Webhook Content**
- [ ] Player name visible
- [ ] Citizen ID visible
- [ ] Server ID visible
- [ ] Character name matches form input
- [ ] Birthdate matches form input
- [ ] Birthplace matches form input
- [ ] Occupation matches form input
- [ ] Reason matches form input
- [ ] Steam ID visible
- [ ] Footer shows command suggestion
- [ ] Color is correct (dark red)
- [ ] Timestamp is accurate

**Test 3: Webhook Disabled**
- [ ] Set `Config.Discord.enabled = false`
- [ ] Submit application
- [ ] No error in console
- [ ] Application still processes
- [ ] No Discord message sent

---

## 🎨 UI/UX Testing

### Application Form UI

- [ ] Form centers on screen
- [ ] Background is aged parchment style
- [ ] Wolf watermark visible (faded)
- [ ] Title "THE LAND OF WOLVES" displays correctly
- [ ] Gold borders visible
- [ ] All input fields visible and editable
- [ ] Labels properly aligned
- [ ] Textarea for "Reason" is large enough
- [ ] Buttons styled correctly
- [ ] Hover effects work on buttons
- [ ] Form is scrollable if content overflows
- [ ] Custom scrollbar visible (if scrolling)
- [ ] Footer text visible
- [ ] No layout breaks or overlaps
- [ ] Responsive (test at different resolutions)

### ID Card UI

- [ ] Card centers on screen
- [ ] Parchment background visible
- [ ] Multiple gold/brown borders visible
- [ ] Main title "THE LAND OF WOLVES" displays correctly
- [ ] Wolf emblem (🐺) visible
- [ ] Photo placeholder has correct frame
- [ ] Photo frame has ornate border
- [ ] All info rows properly aligned
- [ ] Labels bold and uppercase
- [ ] Values in readable font
- [ ] Footer section visible
- [ ] Governor signature line visible
- [ ] Status text correct (pending vs citizen)
- [ ] Stamp overlay (if citizen) displays correctly
- [ ] Stamp is rotated slightly
- [ ] Stamp has red color with transparency
- [ ] No layout breaks

### Animations

- [ ] Form slides in smoothly (0.4s)
- [ ] Card appears with scale+rotate effect (0.5s)
- [ ] Stamp animates in with bounce (0.8s)
- [ ] Stamp scales from 0 to 1.1 to 1
- [ ] Stamp rotates slightly during animation
- [ ] All animations smooth (no jank)
- [ ] Fade in effect for containers

### Typography

- [ ] Fonts load correctly (Google Fonts)
- [ ] Cinzel Decorative for main titles
- [ ] Cinzel for subtitles and labels
- [ ] IM Fell English for body text
- [ ] All text readable
- [ ] Letter spacing appropriate
- [ ] Text shadows subtle and enhancing

### Colors

- [ ] Parchment background (#F5E6D3, #E8D4B8)
- [ ] Gold accents (#B8860B)
- [ ] Brown borders (#8B6F47)
- [ ] Dark text (#2B1810, #5A3A1A)
- [ ] Red stamp (#8B0000)
- [ ] Colors consistent throughout

---

## ⚡ Performance Testing

### Resource Usage

- [ ] Idle resource usage < 0.02ms
- [ ] Active resource usage < 0.5ms
- [ ] No memory leaks (check over time)
- [ ] Script doesn't cause lag spikes

### Client Performance

- [ ] No FPS drops when opening UI
- [ ] No FPS drops during animations
- [ ] UI closes instantly
- [ ] No lingering effects after closing

### Server Performance

- [ ] Database queries execute quickly (< 100ms)
- [ ] Webhook sends don't block server
- [ ] Multiple simultaneous applications handled

### Stress Testing

- [ ] 10+ players taking photos simultaneously
- [ ] 5+ players submitting applications simultaneously
- [ ] Multiple admins using commands at once
- [ ] Opening/closing UI rapidly
- [ ] Spamming cooldown actions

---

## 🔒 Security Testing

### Input Validation

- [ ] SQL injection prevented (parameterized queries)
- [ ] Form inputs sanitized
- [ ] XSS attacks prevented in NUI
- [ ] Invalid data handled gracefully

### Permission Checks

- [ ] Admin commands require proper ACE
- [ ] Non-admins can't execute admin commands
- [ ] Commands validate target player exists

### Exploits

- [ ] Can't bypass photo requirement
- [ ] Can't bypass money requirement
- [ ] Can't bypass cooldowns
- [ ] Can't duplicate items
- [ ] Can't inject malicious code via forms

---

## 🌐 Compatibility Testing

### Framework Versions

- [ ] Latest RSG-Core
- [ ] Latest rsg-inventory
- [ ] Latest ox_lib
- [ ] Latest ox_target
- [ ] Latest oxmysql

### Browser/CEF

- [ ] NUI works in RedM (CEF/Chromium)
- [ ] No compatibility issues
- [ ] All modern CSS features work

### Multi-Language

- [ ] Locale system works
- [ ] Special characters display correctly
- [ ] RTL languages (if supported)

---

## 📱 Edge Case Testing

### Unusual Scenarios

- [ ] Player disconnects during photo taking
- [ ] Player disconnects while form is open
- [ ] Player disconnects after submitting but before getting ID
- [ ] Database connection lost during operation
- [ ] Discord webhook URL invalid
- [ ] Player at max inventory weight
- [ ] Player already has pending/citizen ID
- [ ] Target player logs out during approval
- [ ] Multiple rapid ESC key presses
- [ ] Alt-tabbing while UI open

### Data Edge Cases

- [ ] Very long name (50+ characters)
- [ ] Special characters in inputs (', ", <, >)
- [ ] Emoji in inputs
- [ ] Empty strings (should be validated)
- [ ] SQL keywords in inputs ("SELECT", "DROP", etc.)

---

## 📊 Final Verification

### Documentation

- [ ] README.md accurate and complete
- [ ] INSTALL.md has all necessary steps
- [ ] Config examples work as described
- [ ] Troubleshooting guide helpful
- [ ] All commands documented

### Code Quality

- [ ] No console errors
- [ ] No console warnings
- [ ] Code follows style guidelines
- [ ] Comments present for complex logic
- [ ] Debug prints can be disabled

### User Experience

- [ ] Process is intuitive
- [ ] Error messages are clear
- [ ] Success feedback is satisfying
- [ ] UI is aesthetically pleasing
- [ ] No confusing steps

---

## ✅ Production Ready Checklist

Before deploying to live server:

- [ ] All tests passed
- [ ] Debug mode disabled (`Config.Debug = false`)
- [ ] Discord webhook configured
- [ ] Database backup created
- [ ] Test commands removed from code
- [ ] Locations set to actual server coordinates
- [ ] Fees adjusted to server economy
- [ ] Cooldowns set appropriately
- [ ] Documentation reviewed
- [ ] Server admin trained on commands
- [ ] Player announcement prepared
- [ ] Rollback plan ready

---

## 📝 Test Results Template

```
Test Date: [Date]
Tester: [Name]
Server: [Test/Production]
Version: [1.0.0]

Installation: ✅ Pass / ❌ Fail
Configuration: ✅ Pass / ❌ Fail
Database: ✅ Pass / ❌ Fail
Photographer: ✅ Pass / ❌ Fail
Application: ✅ Pass / ❌ Fail
ID Display: ✅ Pass / ❌ Fail
Admin Commands: ✅ Pass / ❌ Fail
Discord: ✅ Pass / ❌ Fail
UI/UX: ✅ Pass / ❌ Fail
Performance: ✅ Pass / ❌ Fail
Security: ✅ Pass / ❌ Fail

Issues Found:
1. [Description]
2. [Description]

Notes:
[Additional observations]
```

---

## 🚀 Sign-Off

**Tested By**: ________________  
**Date**: ________________  
**Result**: ✅ Ready for Production / ❌ Needs Work  

---

Remember: **Better to over-test than to rush deployment!**

Good luck! 🐺
