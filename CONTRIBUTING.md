# 🤝 Contributing to The Land of Wolves - IDCard System

Thank you for considering contributing to this project! This document provides guidelines and instructions for contributing.

---

## 📋 Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [How Can I Contribute?](#how-can-i-contribute)
3. [Development Setup](#development-setup)
4. [Coding Standards](#coding-standards)
5. [Pull Request Process](#pull-request-process)
6. [Reporting Bugs](#reporting-bugs)
7. [Suggesting Features](#suggesting-features)

---

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of:
- Experience level
- Background
- Identity

### Expected Behavior

- Be respectful and constructive in discussions
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment or discriminatory language
- Trolling or insulting comments
- Publishing others' private information
- Any conduct that would be inappropriate in a professional setting

---

## 🚀 How Can I Contribute?

### 1. Reporting Bugs

Found a bug? Please help us fix it!

**Before submitting:**
- Check existing issues to avoid duplicates
- Verify it's actually a bug (not a configuration issue)
- Test with the latest version

**Submit via:**
- [GitHub Issues](https://github.com/iboss21/LXR-IDCard/issues)

**Include:**
- Clear, descriptive title
- Steps to reproduce
- Expected vs actual behavior
- Server/client console logs
- Your configuration (remove sensitive data like webhook URLs)
- RedM/RSG-Core versions

**Template:**
```markdown
## Bug Description
Brief description of the issue

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. See error

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- RedM Version: [e.g., 1.0.0]
- RSG-Core Version: [e.g., latest]
- Script Version: [e.g., 1.0.0]

## Console Logs
```
Paste relevant logs here
```

## Screenshots
If applicable, add screenshots
```

### 2. Suggesting Features

Have an idea? We'd love to hear it!

**Before suggesting:**
- Check existing feature requests
- Consider if it fits the script's purpose
- Think about implementation complexity

**Submit via:**
- [GitHub Issues](https://github.com/iboss21/LXR-IDCard/issues) with `[FEATURE]` tag

**Include:**
- Clear description of the feature
- Use cases (why is it needed?)
- Potential implementation approach
- Mockups or examples (if applicable)

**Template:**
```markdown
## Feature Description
Clear description of the proposed feature

## Use Case
Why is this feature needed? What problem does it solve?

## Proposed Implementation
How do you envision this working?

## Examples
Any examples from other scripts or mockups

## Additional Context
Any other relevant information
```

### 3. Improving Documentation

Documentation is crucial! You can help by:
- Fixing typos or unclear instructions
- Adding examples
- Translating to other languages
- Creating video tutorials
- Writing guides for specific scenarios

### 4. Code Contributions

Want to contribute code? Awesome!

**Good first contributions:**
- Bug fixes
- Performance optimizations
- Adding configuration options
- UI/UX improvements
- Additional locale translations

**Major contributions:**
- New features
- Architectural changes
- Breaking changes

*For major contributions, please open an issue first to discuss!*

---

## 💻 Development Setup

### Prerequisites

- RedM server (local test server recommended)
- Text editor (VS Code recommended)
- Basic knowledge of:
  - Lua
  - HTML/CSS/JavaScript
  - SQL
  - RedM/FiveM development

### Setup Steps

1. **Fork the repository**
   ```bash
   # Click "Fork" on GitHub, then clone your fork:
   git clone https://github.com/YOUR_USERNAME/LXR-IDCard.git
   cd LXR-IDCard
   ```

2. **Create a test server**
   ```bash
   # Set up a local RedM server with:
   # - RSG-Core
   # - rsg-inventory
   # - ox_lib
   # - ox_target
   # - oxmysql
   ```

3. **Install the script**
   ```bash
   # Copy to your server's resources folder
   # Follow INSTALL.md setup instructions
   ```

4. **Enable debug mode**
   ```lua
   -- In config.lua
   Config.Debug = true
   ```

5. **Create a test branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

### Development Workflow

1. Make your changes
2. Test thoroughly (see Testing section)
3. Commit with clear messages
4. Push to your fork
5. Create a pull request

---

## 📏 Coding Standards

### Lua Code Style

**Formatting:**
```lua
-- Use 4 spaces for indentation (not tabs)
-- Proper spacing around operators
local variable = value + 10

-- Descriptive variable names
local playerMoney = Player.PlayerData.money.cash  -- Good
local pm = Player.PlayerData.money.cash           -- Avoid

-- Comments for complex logic
-- Check if player has required items before processing
if hasRequiredItems then
    -- Process transaction
end
```

**Functions:**
```lua
-- Clear function names describing what they do
local function CalculateApplicationFee(baseAmount, multiplier)
    return baseAmount * multiplier
end

-- Use local functions when possible
local function HelperFunction()
    -- ...
end
```

**Error Handling:**
```lua
-- Always validate inputs
local function ProcessApplication(source, data)
    if not source then return end
    
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then 
        print('^1[ERROR] Player not found^7')
        return 
    end
    
    -- Continue processing...
end
```

### JavaScript Code Style

**Modern ES6+ syntax:**
```javascript
// Use const/let, not var
const formData = { ... };
let currentState = 'idle';

// Arrow functions
const processData = (data) => {
    // ...
};

// Template literals
const message = `Player ${name} has applied`;
```

**Comments:**
```javascript
// Single-line comments for brief explanations

/**
 * Multi-line comments for complex functions
 * @param {Object} data - The data to process
 * @returns {Boolean} Success status
 */
function processForm(data) {
    // ...
}
```

### CSS Code Style

**Organization:**
```css
/* Group related styles */
/* ==================== FORM STYLES ==================== */

/* Use meaningful class names */
.form-submit-button { }  /* Good */
.btn1 { }                /* Avoid */

/* Consistent formatting */
.selector {
    property: value;
    another-property: value;
}

/* Comments for complex sections */
/* Stamp animation with spring physics */
@keyframes stampAppear { ... }
```

### SQL Code Style

```sql
-- Uppercase keywords
SELECT * FROM table_name WHERE condition = 'value';

-- Proper indentation for complex queries
INSERT INTO tlw_id_applications 
    (citizenid, data, status) 
VALUES 
    (?, ?, ?);
```

---

## 🔄 Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] Tested on a local server
- [ ] No console errors
- [ ] Documentation updated (if needed)
- [ ] CHANGELOG.md updated (for features/fixes)
- [ ] No merge conflicts with main branch

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
Describe how you tested your changes:
- [ ] Tested on local server
- [ ] Verified no console errors
- [ ] Tested all affected features

## Screenshots
If applicable, add screenshots

## Checklist
- [ ] My code follows the style guidelines
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have updated the documentation accordingly
- [ ] My changes generate no new warnings
- [ ] I have tested my changes thoroughly
```

### Review Process

1. Maintainer will review your PR
2. May request changes or ask questions
3. Once approved, will be merged to main branch
4. Your contribution will be credited in CHANGELOG.md

---

## 🧪 Testing Guidelines

### Manual Testing Checklist

**Photo Taking:**
- [ ] Can take photo at photographer location
- [ ] Money is deducted correctly
- [ ] Photo plate item is received
- [ ] Cooldown works as expected

**Application Submission:**
- [ ] Can open form at government office
- [ ] All form fields work
- [ ] Validation works (required fields)
- [ ] Money is deducted correctly
- [ ] Photo plate is consumed
- [ ] Pending ID card is received
- [ ] Discord webhook is sent (if enabled)

**Admin Actions:**
- [ ] `/approveid` works correctly
- [ ] `/denyid` works correctly
- [ ] Pending ID upgrades to citizen ID
- [ ] Player receives notification

**UI/UX:**
- [ ] Form displays correctly
- [ ] ID card displays correctly
- [ ] Animations work smoothly
- [ ] Can close with ESC key
- [ ] No visual glitches

**Database:**
- [ ] Data saves correctly
- [ ] Status updates work
- [ ] No SQL errors

### Performance Testing

- [ ] No lag when opening UI
- [ ] Reasonable resource usage (< 0.02ms idle)
- [ ] No memory leaks
- [ ] Works with 50+ players online

---

## 🌍 Localization

### Adding a New Language

1. **In `config.lua`, add locale:**
```lua
Config.Locales = {
    ['en'] = {
        photographer_prompt = 'Take Mugshot Photo',
        -- ... all strings
    },
    ['es'] = {
        photographer_prompt = 'Tomar Foto de Identificación',
        -- ... all strings translated
    }
}

Config.Locale = Config.Locales['en']  -- Default
```

2. **Ensure all strings are translated**
3. **Test in-game to verify display**
4. **Submit as PR with language clearly marked**

---

## 📦 Release Process

### Version Numbering

We use [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes

Example: `1.2.3` = Major.Minor.Patch

### Creating a Release

1. Update version in `fxmanifest.lua`
2. Update `CHANGELOG.md` with changes
3. Create release tag: `git tag v1.2.3`
4. Push tags: `git push origin --tags`
5. Create GitHub release with notes

---

## 💡 Tips for Contributors

### Good Practices

- **Small, focused PRs** are easier to review than large ones
- **One feature/fix per PR** when possible
- **Test edge cases** not just happy paths
- **Ask questions** if you're unsure about implementation
- **Be patient** with review process

### Resources

- [Lua 5.4 Reference](https://www.lua.org/manual/5.4/)
- [RedM Natives Reference](https://alloc8or.re/rdr3/nativedb/)
- [RSG-Core Documentation](https://github.com/Rexshack-RedM/rsg-core)
- [ox_lib Documentation](https://overextended.dev/ox_lib)

---

## 🎖️ Recognition

All contributors will be:
- Listed in CHANGELOG.md
- Credited in README.md (for significant contributions)
- Thanked in release notes

---

## 📬 Contact

- **Issues**: [GitHub Issues](https://github.com/iboss21/LXR-IDCard/issues)
- **Discussions**: [GitHub Discussions](https://github.com/iboss21/LXR-IDCard/discussions)

---

**Thank you for contributing to The Land of Wolves IDCard System! 🐺**

Your contributions help make this script better for the entire RedM community.
