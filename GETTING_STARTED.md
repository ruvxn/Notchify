# 🚀 Getting Started with Notchify

**Welcome!** This guide will help you understand what has been built and how to get started with development.

## 📋 What You Have Now

### ✅ Complete Phase 1 Implementation

**Notchify Phase 1 is 100% complete** with the following features ready to use:

1. **Full Onboarding Flow** ⭐ (Critical Feature)
   - Welcome screen introducing features
   - **Screen size selection** for proper notch dimensions
   - Permission requests (Calendar, Notifications, Ollama)
   - Completion screen with quick tips

2. **Dynamic Notch Window**
   - Positions perfectly at screen top center
   - Adjusts size based on MacBook model (14" vs 16")
   - Smooth expand/collapse animations
   - Hover detection

3. **Settings Panel**
   - Change MacBook model anytime
   - Launch at login toggle
   - Permission management
   - Re-run onboarding option
   - Reset all settings

4. **Menu Bar Integration**
   - Menu bar only app (no dock icon)
   - Quick access to settings
   - Toggle notch visibility
   - Quit option

5. **Modern UI**
   - Glassmorphism effects
   - Spring animations
   - SwiftUI throughout
   - Dark mode support

## 📁 What's In This Repository

### Source Code (18 Swift files)
```
Notchify/
├── App/                    # 2 files - Main app structure
├── Models/                 # 3 files - Data models
├── Views/                  # 9 files - UI components
│   └── Onboarding/        # 5 files - Setup flow
├── ViewModels/            # 1 file - Business logic
├── Utilities/             # 2 files - Helpers
└── Supporting Files/      # 1 file - Info.plist
```

### Documentation (5 files)
- **README.md** - Complete project documentation
- **QUICKSTART.md** - Get running in 5 minutes
- **SETUP.md** - Detailed Xcode setup guide
- **PROJECT_STATUS.md** - Current state and roadmap
- **FILES.md** - Complete file reference

## 🎯 Choose Your Path

### Path A: Quick Start (Recommended for First Time)

**Goal:** Get the app running as fast as possible

1. Read [QUICKSTART.md](QUICKSTART.md) (5 min)
2. Create Xcode project (2 min)
3. Add files to project (1 min)
4. Build and run (1 min)
5. **Total time: ~10 minutes**

### Path B: Detailed Setup

**Goal:** Understand everything before building

1. Read [README.md](README.md) (10 min)
2. Read [SETUP.md](SETUP.md) (10 min)
3. Review [PROJECT_STATUS.md](PROJECT_STATUS.md) (5 min)
4. Create Xcode project following detailed steps (10 min)
5. **Total time: ~35 minutes**

### Path C: Code Review First

**Goal:** Understand the architecture before running

1. Read [FILES.md](FILES.md) to understand structure
2. Review key files:
   - [MacBookModel.swift](Notchify/Models/MacBookModel.swift)
   - [NotchWindowManager.swift](Notchify/Utilities/NotchWindowManager.swift)
   - [OnboardingViewModel.swift](Notchify/ViewModels/OnboardingViewModel.swift)
3. Then follow Path A or B

## 🏗️ How to Build

### Prerequisites

- Mac running macOS 14.0+
- Xcode 15.0+
- Apple Developer account (free tier works)

### Quick Build Steps

1. **Create Xcode Project**
   ```
   Open Xcode
   File → New → Project → macOS App
   Name: Notchify
   Interface: SwiftUI
   Save in repository root
   ```

2. **Add Source Files**
   ```
   Right-click Notchify folder in Xcode
   Add Files to "Notchify"...
   Select: App, Views, ViewModels, Models, Utilities, Supporting Files
   Click Add
   ```

3. **Configure**
   ```
   Build Settings → Info.plist File → Set to: Notchify/Supporting Files/Info.plist
   Build Settings → macOS Deployment Target → Set to: 14.0
   Signing & Capabilities → Select your Team
   ```

4. **Build & Run**
   ```
   Press ⌘R
   ```

## 🎮 What to Expect

### First Launch

1. **Onboarding window appears** (600×500 window)
2. Walk through 4 steps:
   - Welcome
   - **Choose your Mac model** (14" or 16")
   - Grant permissions (optional)
   - See completion screen
3. **Notch interface appears** at top of screen

### Using the App

- **Hover** over notch → Expands smoothly
- **Move away** → Collapses back
- **Menu bar icon** → Access settings
- **Four tabs** in expanded view:
  - Media (placeholder)
  - Calendar (placeholder)
  - Notifications (placeholder)
  - Chat (placeholder)

## 🧪 Testing Checklist

Run through these to verify everything works:

- [ ] Onboarding flow completes
- [ ] Can select different Mac models
- [ ] Notch window appears at screen top
- [ ] Hovering expands the window
- [ ] Tabs switch correctly
- [ ] Settings panel opens
- [ ] Can change Mac model in settings
- [ ] Menu bar icon is visible
- [ ] App can be quit and relaunched

## 🐛 Troubleshooting

### Build Errors

| Error | Solution |
|-------|----------|
| "No such module 'SwiftUI'" | Set deployment target to 14.0+ |
| "Cannot find NotchWindowManager" | Check all files are added to target |
| Info.plist errors | Verify Info.plist path in Build Settings |

### Runtime Issues

| Issue | Solution |
|-------|----------|
| Window doesn't appear | Check Console.app, verify LSUIElement in Info.plist |
| Onboarding doesn't show | Run: `defaults delete com.yourcompany.Notchify` |
| Permissions don't work | Grant manually in System Settings |

## 📚 Learning Resources

### Understand the Code

**Start Here:**
1. [NotchifyApp.swift](Notchify/App/NotchifyApp.swift) - App entry point
2. [AppDelegate.swift](Notchify/App/AppDelegate.swift) - App lifecycle
3. [OnboardingView.swift](Notchify/Views/Onboarding/OnboardingView.swift) - First thing user sees

**Core Concepts:**
1. [MacBookModel.swift](Notchify/Models/MacBookModel.swift) - Why screen size matters
2. [NotchWindowManager.swift](Notchify/Utilities/NotchWindowManager.swift) - How positioning works
3. [PermissionsManager.swift](Notchify/Utilities/PermissionsManager.swift) - Permission handling

**UI Components:**
1. [CompactNotchView.swift](Notchify/Views/CompactNotchView.swift) - Collapsed state
2. [ExpandedNotchView.swift](Notchify/Views/ExpandedNotchView.swift) - Expanded state
3. [SettingsView.swift](Notchify/Views/SettingsView.swift) - Settings panel

### Key Architectural Decisions

**Why screen size selection is first:**
- Different MacBook models have different notch dimensions
- 14": 170pt × 32pt
- 16": 200pt × 37pt
- This affects ALL UI sizing throughout the app
- Must be set during onboarding for proper experience

**Why menu bar only (LSUIElement):**
- App is meant to be always accessible
- No need for dock icon
- Reduces clutter
- Fits the "notch utility" use case

**Why UserDefaults for storage:**
- Simple preferences don't need complex storage
- Easy to debug and reset
- No external dependencies
- Fast and reliable

## 🚀 Next Development Steps

### Phase 2: Media Player (Next Up)

Implement actual media controls:

**Create these files:**
```
Services/MediaService.swift
ViewModels/MediaPlayerViewModel.swift
Views/MediaPlayerView.swift
Models/MediaItem.swift
```

**What to implement:**
- MPRemoteCommandCenter integration
- Album artwork display
- Playback controls
- Waveform visualization
- Progress tracking

**Estimated time:** 2-3 days

### Phase 3: Calendar Integration

**Create these files:**
```
Services/CalendarService.swift
ViewModels/CalendarViewModel.swift
Views/CalendarView.swift
Models/CalendarEvent.swift
```

### Phase 4: Notifications

**Create these files:**
```
Services/NotificationService.swift
ViewModels/NotificationViewModel.swift
Views/NotificationsView.swift
Models/NotificationItem.swift
```

### Phase 5: Ollama Chat

**Create these files:**
```
Services/OllamaService.swift
ViewModels/OllamaChatViewModel.swift
Views/ChatView.swift
Models/ChatMessage.swift
```

## 💡 Development Tips

### Use SwiftUI Previews

Most views have preview support:
```swift
#Preview {
    WelcomeView()
}
```

Click "Resume" in preview panel for live updates.

### Reset Onboarding for Testing

```bash
defaults delete com.yourcompany.Notchify isOnboardingComplete
```

### View Logs

```bash
log stream --predicate 'processImagePath contains "Notchify"' --level debug
```

### Debug Window Positions

Add to NotchWindowManager:
```swift
print("Window: \(window.frame)")
print("Screen: \(screen.frame)")
```

## 🎨 Customization Ideas

### Change Notch Dimensions

Edit [NotchDimensions.swift](Notchify/Models/NotchDimensions.swift):
```swift
static let expandedWidthMultiplier: CGFloat = 4.0  // Default: 3.0
static let expandedHeightMultiplier: CGFloat = 10.0 // Default: 8.0
```

### Change Animation Speed

Edit [NotchWindowManager.swift](Notchify/Utilities/NotchWindowManager.swift):
```swift
context.duration = 0.5  // Default: 0.3
```

### Add New Onboarding Step

1. Add case to `OnboardingStep` enum
2. Create new view file
3. Add to switch in `OnboardingView`

## 🤝 Getting Help

### In Order of Preference:

1. **Check existing docs:**
   - [QUICKSTART.md](QUICKSTART.md) for quick fixes
   - [SETUP.md](SETUP.md) for build issues
   - [FILES.md](FILES.md) for code questions

2. **Check Console.app** for error messages

3. **Review code:**
   - Check [FILES.md](FILES.md) for file descriptions
   - Read inline comments in Swift files

4. **Open GitHub issue** with:
   - Xcode version
   - macOS version
   - Error messages
   - Steps to reproduce

## ✅ Success Criteria

**You're ready to start developing when:**

- ✅ Project builds without errors
- ✅ Onboarding flow works end-to-end
- ✅ Notch window appears and positions correctly
- ✅ Expand/collapse animations work
- ✅ Settings panel opens and saves changes
- ✅ Menu bar integration works
- ✅ You understand the code structure

## 🎯 Your First Task

**Recommended:** Run the app and complete onboarding

1. Build the project
2. Go through onboarding
3. Select your actual Mac model
4. Grant permissions
5. Test expand/collapse
6. Open settings and change model
7. Verify notch resizes

This will help you understand the user experience before diving into code.

## 📞 Quick Reference

| Document | Purpose | Read Time |
|----------|---------|-----------|
| [QUICKSTART.md](QUICKSTART.md) | Get running fast | 5 min |
| [README.md](README.md) | Full documentation | 15 min |
| [SETUP.md](SETUP.md) | Detailed setup | 10 min |
| [PROJECT_STATUS.md](PROJECT_STATUS.md) | Current state | 5 min |
| [FILES.md](FILES.md) | Code reference | 10 min |

## 🏁 Ready to Start?

1. **First time?** → Read [QUICKSTART.md](QUICKSTART.md)
2. **Want details?** → Read [SETUP.md](SETUP.md)
3. **Review code?** → Read [FILES.md](FILES.md)
4. **Start developing?** → Build Phase 2 features

---

**Questions?** Open an issue on GitHub
**Ready?** Let's build something amazing! 🚀

---

Made with ❤️ by Claude Code
