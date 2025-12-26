# 🎨 UI Preview & Design Guide

## The Land of Wolves - IDCard System

This document provides a detailed description of the UI design for those who want to understand or modify the visual appearance.

---

## 🎯 Design Philosophy

The UI is designed to immerse players in the harsh frontier world of "The Land of Wolves" with a focus on:

- **Authenticity**: Aged parchment, Victorian-era typography, period-appropriate styling
- **Brutality**: Wolf claw marks, blood stains, rough textures
- **Prestige**: Gold borders, ornate frames, official seals
- **Functionality**: Clear information hierarchy, easy-to-read forms

---

## 📱 Application Form UI

### Layout
```
┌─────────────────────────────────────────────────┐
│  [Wolf Watermark - Faded in Background]        │
│                                                 │
│           THE LAND OF WOLVES                    │
│      TERRITORIAL GOVERNOR'S OFFICE              │
│           ═══════════════════                   │
│         Citizenship Application                 │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │ Full Name: [________________]             │ │
│  │ Date of Birth: [________________]         │ │
│  │ Birthplace: [________________]            │ │
│  │ Occupation: [________________]            │ │
│  │ Reason for Immigration:                   │ │
│  │ [_________________________________]       │ │
│  │ [_________________________________]       │ │
│  │ [_________________________________]       │ │
│  └───────────────────────────────────────────┘ │
│                                                 │
│      [Cancel]           [Submit Application]    │
│                                                 │
│  By submitting, you acknowledge the harsh laws  │
└─────────────────────────────────────────────────┘
```

### Color Palette
- **Background**: Aged parchment (#F5E6D3 to #E8D4B8 gradient)
- **Primary Text**: Dark brown (#2B1810)
- **Headers**: Rich saddle brown (#5A3A1A)
- **Accents**: Antique gold (#B8860B)
- **Borders**: Saddle brown (#8B6F47)

### Typography
- **Title**: Cinzel Decorative (900 weight) - 42px
- **Subtitle**: Cinzel (600 weight) - 18px
- **Section Headers**: Cinzel (600 weight) - 24px
- **Body Text**: IM Fell English - 16px
- **Inputs**: IM Fell English - 16px

### Visual Effects
- Wolf watermark (🐺) at 400px, 5% opacity
- Gradient background with subtle texture
- Golden borders (8px outer, 3px inner)
- Drop shadows on card (20px blur, 70% opacity)
- Smooth animations (0.3s - 0.4s duration)

---

## 🪪 ID Card Display UI

### Layout
```
┌────────────────────────────────────────────────────────────┐
│ ╔═══════════════════════════════════════════════════════╗ │
│ ║                                                       ║ │
│ ║          THE LAND OF WOLVES                          ║ │
│ ║       TERRITORIAL IDENTIFICATION                     ║ │
│ ║                      🐺                              ║ │
│ ║                                                       ║ │
│ ║   ┌────────────┐   NAME: John Marston               ║ │
│ ║   │            │   DATE OF BIRTH: 01/15/1873        ║ │
│ ║   │  OFFICIAL  │   BIRTHPLACE: Texas                ║ │
│ ║   │  PORTRAIT  │   OCCUPATION: Rancher              ║ │
│ ║   │            │   CITIZEN ID: XXXX-1234            ║ │
│ ║   │            │   ISSUED: 12/26/2025               ║ │
│ ║   └────────────┘                                     ║ │
│ ║                                                       ║ │
│ ║   ───────────────────────────────────────────        ║ │
│ ║        Territorial Governor                          ║ │
│ ║   CITIZEN OF THE LAND OF WOLVES                     ║ │
│ ║                                                       ║ │
│ ║             [APPROVED STAMP - if citizen]            ║ │
│ ╚═══════════════════════════════════════════════════════╝ │
└────────────────────────────────────────────────────────────┘
```

### Card Dimensions
- **Width**: 800px
- **Height**: 500px
- **Aspect Ratio**: 8:5 (similar to credit card)

### Photo Frame
- **Size**: 180px × 240px
- **Border**: 4px saddle brown
- **Shadow**: Inset shadow for depth
- **Background**: Brass/gold gradient (#C9B896 to #A89968)

### Approval Stamp (Citizens Only)
```
     ╔════════════════╗
   ╔═════════════════════╗
  ║     APPROVED         ║
  ║        🐺            ║
  ║      CITIZEN         ║
   ╚═════════════════════╝
     ╚════════════════╝
```

- **Size**: 300px × 300px
- **Color**: Red (#8B0000) at 70-80% opacity
- **Rotation**: -15 degrees
- **Borders**: Triple circle borders (12px, 6px inner rings)
- **Animation**: Scale from 0 to 1.1 to 1, with rotation

---

## 🎬 Animations

### Card Appear
```css
@keyframes cardAppear {
    from: scale(0.8) rotateY(-10deg) opacity(0)
    to: scale(1) rotateY(0) opacity(1)
    duration: 0.5s
}
```

### Stamp Reveal
```css
@keyframes stampAppear {
    0%: scale(0) rotate(-15deg) opacity(0)
    50%: scale(1.1) rotate(-12deg)
    100%: scale(1) rotate(-15deg) opacity(1)
    duration: 0.8s
    easing: cubic-bezier(bounce)
}
```

### Form Slide In
```css
@keyframes slideIn {
    from: translateY(-50px) opacity(0)
    to: translateY(0) opacity(1)
    duration: 0.4s
}
```

---

## 🎨 Texture & Effects Details

### Parchment Texture
- Base: Linear gradient (135deg) from light to medium beige
- Overlay: Grid pattern (20px × 20px) at 50% opacity
- Stains: Subtle darker spots (simulated with opacity)

### Border Effects
- Outer border: 8px gold (#B8860B)
- Middle border: 12px saddle brown (#8B6F47)
- Inner border: 14px gold accent
- Inner card border: 2px gold at 15px inset

### Wolf Elements
- Watermark: 🐺 emoji at 400px, heavily faded
- Emblem: 🐺 emoji at 40px, 80% opacity
- Stamp center: 🐺 emoji at 60px, 70% opacity

### Shadow Hierarchy
```
Level 1 (Card): 0 20px 60px rgba(0,0,0,0.8)
Level 2 (Frame): 0 4px 8px rgba(0,0,0,0.3)
Level 3 (Buttons): 0 4px 6px rgba(0,0,0,0.3)
Level 4 (Hover): 0 6px 12px rgba(0,0,0,0.4)
```

---

## 📐 Responsive Design

The UI is designed for 1920×1080 but scales down responsively:

```css
@media (max-width: 1024px) {
    .form-card, .id-card {
        width: 90%;
        max-width: 800px;
    }
}
```

---

## 🖼️ Asset Requirements (Optional Enhancements)

For servers wanting to enhance the visual experience beyond CSS:

### Background Image
- **File**: `html/assets/background.png`
- **Size**: 1920×1080px
- **Style**: Aged parchment texture with tears, stains, claw marks
- **Format**: PNG with transparency or JPG
- **Usage**: Set as background-image in CSS

### Stamp Overlay
- **File**: `html/assets/stamp.png`
- **Size**: 800×800px
- **Style**: Red distressed "APPROVED - CITIZEN" text in circle
- **Format**: PNG with transparency
- **Details**: Include wolf silhouette, border circles, ink splatter

### Photo Frame
- **File**: `html/assets/frame.png`
- **Size**: 600×800px (portrait orientation)
- **Style**: Tarnished brass/gold with wolf engravings
- **Format**: PNG with transparency
- **Usage**: Overlay on photo section

### Wolf Accents
- **Files**: Various PNG icons
- **Style**: Howling wolf, claw marks, paw prints
- **Format**: PNG with transparency
- **Usage**: Decorative elements throughout UI

---

## 🎛️ Customization Guide

### Changing Colors

To change the color scheme, search and replace in `style.css`:

| Element | Current Color | Find & Replace |
|---------|--------------|----------------|
| Parchment | #F5E6D3 | Search for this hex |
| Gold | #B8860B | Search for this hex |
| Brown | #8B6F47 | Search for this hex |
| Dark Text | #2B1810 | Search for this hex |
| Stamp Red | #8B0000 | Search for rgba(139, 0, 0, ...) |

### Changing Fonts

In `html/index.html`, modify the Google Fonts link:
```html
<link href="https://fonts.googleapis.com/css2?family=YourFont&display=swap">
```

Then update `style.css`:
```css
.main-title {
    font-family: 'YourFont', serif;
}
```

### Adjusting Animations

Modify animation durations in `style.css`:
```css
animation: stampAppear 0.8s cubic-bezier(...);
/* Change 0.8s to your preferred duration */
```

---

## 🔧 Browser Compatibility

The UI uses modern CSS features:
- CSS Grid
- Flexbox
- CSS Animations
- Custom properties (variables)
- Google Fonts

Tested and working on:
- ✅ Chrome/Chromium (RedM uses CEF - Chromium Embedded Framework)
- ✅ Modern browsers (for testing in browser devtools)

---

## 💡 Tips for Testing UI

1. **In-Game**: Use F8 console to check for errors
2. **Browser**: Open `html/index.html` directly in Chrome
3. **DevTools**: Use browser inspector to modify CSS live
4. **Resolution**: Test at 1920×1080 and 1280×720

---

## 📊 Performance Considerations

The UI is optimized for performance:
- Uses CSS animations (GPU accelerated)
- Minimal JavaScript
- No external libraries (vanilla JS)
- Google Fonts are preloaded
- Images are optional (pure CSS works)

Expected impact:
- **Load Time**: < 0.1s
- **Memory**: < 5MB
- **FPS Impact**: Negligible (0-1 FPS)

---

## 🎨 Alternative Style Ideas

Want a different aesthetic? Here are some suggestions:

### Modern Government Office
- Clean white background
- Sans-serif fonts (Roboto, Inter)
- Blue/grey color scheme
- Minimal decorations

### Dystopian/Authoritarian
- Dark backgrounds (black/grey)
- Red accents
- Bold, angular fonts
- Aggressive stamp design

### Luxury/Elite
- Deep burgundy or navy backgrounds
- Gold foil effects
- Serif fonts (Playfair Display)
- Embossed textures

### Minimalist
- White card on transparent background
- Simple borders
- Clean sans-serif fonts
- Subtle shadows only

---

For implementation of any alternative styles, we can provide custom CSS upon request!
