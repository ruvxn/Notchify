# Notchify - Quick Start Guide

Get Notchify running in 5 minutes!

## Prerequisites Check

Before you begin, make sure you have:

- ✅ Mac running macOS 14.0 (Sonoma) or later
- ✅ Xcode 15.0 or later installed
- ✅ Apple Developer account (free tier works)

## Step-by-Step Setup

### 1. Create Xcode Project (2 minutes)

Open Xcode and create a new project:

```
File → New → Project
Select: macOS → App
Product Name: Notchify
Interface: SwiftUI
Language: Swift
```

Save it in this repository's root folder.

### 2. Add Source Files (1 minute)

In Xcode's Project Navigator:

1. Right-click on `Notchify` folder
2. Select **"Add Files to Notchify..."**
3. Select these folders:
   - `App/`
   - `Views/`
   - `ViewModels/`
   - `Models/`
   - `Utilities/`
   - `Supporting Files/`
4. Make sure **"Create groups"** is selected
5. Click **Add**

### 3. Configure Info.plist (30 seconds)

1. In Project Settings → Build Settings
2. Search for "Info.plist File"
3. Set to: `Notchify/Supporting Files/Info.plist`

### 4. Set Deployment Target (15 seconds)

1. Select your project in Navigator
2. Go to **Build Settings**
3. Search for "macOS Deployment Target"
4. Set to **14.0** or later

### 5. Configure Signing (30 seconds)

1. Go to **Signing & Capabilities** tab
2. Select your **Team**
3. Check **"Automatically manage signing"**

### 6. Build & Run! (1 minute)

Press **⌘R** or click the **Play** button.

## What to Expect

### First Launch Sequence

1. **Welcome Screen** appears
   - Shows app features
   - Click **Next**

2. **Screen Size Selection**
   - Choose your Mac model:
     - 14-inch MacBook Pro
     - 16-inch MacBook Pro
     - No Notch / Other Mac
   - Click **Next**

3. **Permissions Setup**
   - Grant Calendar access (optional)
   - Grant Notification access (optional)
   - Ollama connection check (optional)
   - Click **Continue**

4. **Completion Screen**
   - Shows quick tips
   - Click **Launch App**

5. **Notch Interface Appears**
   - Look at the top center of your screen
   - You should see a small bar at the notch location
   - Hover over it to expand
   - Click outside to collapse

### Menu Bar

Look for the Notchify icon in your menu bar (top-right corner):

- Click it to access Settings
- Toggle notch visibility
- Quit the app

## Troubleshooting

### Build Errors

**"No such module 'SwiftUI'"**
```
Fix: Build Settings → macOS Deployment Target → Set to 14.0+
```

**"Cannot find 'NotchWindowManager'"**
```
Fix: Make sure all files are added to target
Check: File Inspector → Target Membership
```

**Info.plist errors**
```
Fix: Build Settings → Info.plist File → Set correct path
```

### Runtime Issues

**Window doesn't appear**
```
1. Check Console.app for errors
2. Verify Info.plist has LSUIElement = YES
3. Try restarting Xcode
```

**Onboarding doesn't show**
```
Reset UserDefaults:
defaults delete com.yourcompany.Notchify
```

**Permissions not granted**
```
1. Open System Settings → Privacy & Security
2. Manually grant Calendar/Notification access
3. Restart the app
```

## Quick Commands

### Reset Onboarding
```bash
defaults delete com.yourcompany.Notchify isOnboardingComplete
```

### Reset All Settings
```bash
defaults delete com.yourcompany.Notchify
```

### View App Logs
```bash
log stream --predicate 'processImagePath contains "Notchify"' --level debug
```

## Testing the App

### Test Onboarding Flow

1. Complete onboarding once
2. Reset: `defaults delete com.yourcompany.Notchify isOnboardingComplete`
3. Restart app
4. Go through onboarding again

### Test Expand/Collapse

1. Hover mouse over the notch area
2. Window should smoothly expand
3. Move mouse away
4. Window should collapse

### Test Settings

1. Click menu bar icon → Settings
2. Change Mac Model
3. Window should resize
4. Toggle Launch at Login
5. Click Close

### Test Different Screen Sizes

1. Open Settings
2. Try each Mac model option:
   - 14-inch (170pt × 32pt)
   - 16-inch (200pt × 37pt)
   - No Notch (200pt × 32pt)
3. Verify notch resizes correctly

## What's Working

✅ Onboarding flow
✅ Screen size selection
✅ Notch window positioning
✅ Expand/collapse animations
✅ Settings panel
✅ Permission management
✅ Menu bar integration

## What's Not Implemented Yet

⏳ Media player controls (placeholder shown)
⏳ Calendar event display (placeholder shown)
⏳ Notification monitoring (placeholder shown)
⏳ AI chat with Ollama (placeholder shown)

## Next Development Steps

### Phase 2: Implement Media Player

Create `MediaPlayerViewModel.swift`:
```swift
import MediaPlayer

class MediaPlayerViewModel: ObservableObject {
    @Published var nowPlaying: MPMediaItem?
    @Published var isPlaying = false

    // Implementation coming soon...
}
```

### Phase 3: Implement Calendar

Create `CalendarViewModel.swift`:
```swift
import EventKit

class CalendarViewModel: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var events: [EKEvent] = []

    // Implementation coming soon...
}
```

### Phase 4: Implement Notifications

Create `NotificationViewModel.swift`:
```swift
import UserNotifications

class NotificationViewModel: ObservableObject {
    @Published var notifications: [UNNotification] = []

    // Implementation coming soon...
}
```

### Phase 5: Implement Ollama Chat

Create `OllamaChatViewModel.swift`:
```swift
class OllamaChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private let baseURL = "http://localhost:11434"

    // Implementation coming soon...
}
```

## Resources

- 📖 [Full README](README.md) - Complete documentation
- 🛠️ [Setup Guide](SETUP.md) - Detailed Xcode setup
- 📊 [Project Status](PROJECT_STATUS.md) - Current progress
- 💬 [GitHub Issues](https://github.com/yourusername/Notchify/issues) - Get help

## Tips for Development

### Use SwiftUI Previews

Most views have preview support:

```swift
#Preview {
    WelcomeView()
        .frame(width: 600, height: 500)
}
```

Click **Resume** in the preview panel to see live updates.

### Debug Window Positioning

Add print statements to `NotchWindowManager`:

```swift
print("Window frame: \(window.frame)")
print("Screen size: \(screen.frame)")
```

### Test on Different Macs

If you have access to multiple Macs:

- Test on 14" MacBook Pro
- Test on 16" MacBook Pro
- Test on Mac without notch
- Verify dimensions are correct

## Common Customizations

### Change Notch Dimensions

Edit [NotchDimensions.swift](Notchify/Models/NotchDimensions.swift):

```swift
static let macBook14 = CGSize(width: 170, height: 32)
static let macBook16 = CGSize(width: 200, height: 37)
```

### Change Expansion Multipliers

```swift
static let expandedWidthMultiplier: CGFloat = 3.0  // Try 4.0
static let expandedHeightMultiplier: CGFloat = 8.0 // Try 10.0
```

### Change Animation Speed

Edit [NotchWindowManager.swift](Notchify/Utilities/NotchWindowManager.swift):

```swift
context.duration = 0.3  // Change to 0.5 for slower
```

## Success Criteria

You'll know everything is working when:

1. ✅ Onboarding flow completes without errors
2. ✅ Notch window appears at screen top
3. ✅ Hovering expands the window smoothly
4. ✅ Tabs switch correctly (even though they show placeholders)
5. ✅ Settings panel opens and saves changes
6. ✅ Menu bar icon is visible and functional

## Getting Help

If you're stuck:

1. Check [SETUP.md](SETUP.md) for detailed instructions
2. Review [PROJECT_STATUS.md](PROJECT_STATUS.md) for known issues
3. Open an issue on GitHub with:
   - Xcode version
   - macOS version
   - Error messages
   - Steps to reproduce

---

**Ready to build?** Run `⌘R` in Xcode and let's go! 🚀
