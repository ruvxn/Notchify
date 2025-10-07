# Notchify - Xcode Setup Guide

This guide will help you create the Xcode project and get Notchify running on your Mac.

## Prerequisites

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- Apple Developer account (for code signing)

## Creating the Xcode Project

### Step 1: Create a New Project

1. Open Xcode
2. Select **File → New → Project**
3. Choose **macOS** → **App**
4. Click **Next**

### Step 2: Configure Project Settings

Fill in the project details:

- **Product Name:** `Notchify`
- **Team:** Select your development team
- **Organization Identifier:** `com.yourcompany` (use your own)
- **Bundle Identifier:** `com.yourcompany.Notchify`
- **Interface:** SwiftUI
- **Language:** Swift
- **Storage:** None (we'll use UserDefaults)
- **Include Tests:** Optional

Click **Next** and save the project in the repository root directory.

### Step 3: Add Source Files to Xcode

1. In Xcode's Project Navigator (left sidebar), right-click on the `Notchify` folder
2. Select **Add Files to "Notchify"...**
3. Navigate to the `Notchify` folder in the repository
4. Select all the folders: `App`, `Views`, `ViewModels`, `Models`, `Utilities`, `Supporting Files`
5. Make sure **"Create groups"** is selected
6. Click **Add**

Your project structure should now match:

```
Notchify/
├── App/
│   ├── NotchifyApp.swift
│   └── AppDelegate.swift
├── Views/
│   ├── Onboarding/
│   ├── NotchContentView.swift
│   ├── CompactNotchView.swift
│   ├── ExpandedNotchView.swift
│   └── SettingsView.swift
├── ViewModels/
│   └── OnboardingViewModel.swift
├── Models/
│   ├── MacBookModel.swift
│   ├── NotchDimensions.swift
│   └── NotchConfiguration.swift
├── Utilities/
│   ├── NotchWindowManager.swift
│   └── PermissionsManager.swift
└── Supporting Files/
    └── Info.plist
```

### Step 4: Configure Info.plist

1. In the Project Navigator, find the existing `Info.plist` (usually in the `Notchify` folder)
2. Delete it or replace it with the one from `Supporting Files/Info.plist`
3. In your project settings, go to **Build Settings**
4. Search for "Info.plist File"
5. Set the path to: `Notchify/Supporting Files/Info.plist`

### Step 5: Configure Signing & Capabilities

1. Select the project in the Project Navigator
2. Select the **Notchify** target
3. Go to the **Signing & Capabilities** tab
4. Select your **Team**
5. Ensure **Automatically manage signing** is checked

### Step 6: Add Required Capabilities

Still in **Signing & Capabilities**, click **+ Capability** and add:

1. **App Sandbox** (if needed for distribution)
   - Under "App Sandbox", enable:
     - Calendar (Read/Write)
     - User Selected Files (Read/Write)
   - Note: For full functionality during development, you may want to disable sandboxing

2. **Hardened Runtime** (for notarization)
   - Enable if planning to distribute

### Step 7: Update Build Settings

1. Go to **Build Settings** tab
2. Set **macOS Deployment Target** to `14.0` or later
3. Ensure **Swift Language Version** is set to `Swift 5`

### Step 8: Remove Default Files

Xcode may have created default files. Remove these if they exist:

- Default `ContentView.swift` (we have our own views)
- Default `NotchifyApp.swift` (if it conflicts with ours)

Make sure only our custom `NotchifyApp.swift` from the `App` folder is in the project.

## Building and Running

### First Build

1. Select a run destination: **My Mac**
2. Press **⌘R** or click the **Play** button
3. If you encounter any errors, check:
   - All files are properly added to the target
   - No duplicate files
   - Info.plist path is correct
   - Signing is configured

### Expected First Launch

On first launch, you should see:

1. **Welcome Screen** with app features
2. Click **Next**
3. **Screen Size Selection** - choose your MacBook model
4. Click **Next**
5. **Permissions Setup** - grant calendar and notification access (optional)
6. Click **Continue**
7. **Completion Screen** with quick tips
8. Click **Launch App**
9. The notch interface should appear at the top of your screen

### Troubleshooting

#### Build Errors

**Error: "No such module 'SwiftUI'"**
- Solution: Make sure macOS Deployment Target is 14.0 or later

**Error: "Cannot find 'NotchWindowManager' in scope"**
- Solution: Ensure all utility files are added to the target
- Check **Target Membership** in the File Inspector

**Error: Info.plist not found**
- Solution: Update the Info.plist path in Build Settings

#### Runtime Issues

**Window doesn't appear**
- Check Console for errors
- Ensure LSUIElement is set to YES in Info.plist
- Verify NotchWindowManager is initializing correctly

**Permissions not working**
- Check Info.plist has all usage descriptions
- Try granting permissions manually in System Settings
- Restart the app after granting permissions

**Onboarding doesn't show**
- Delete UserDefaults: Run in Terminal:
  ```bash
  defaults delete com.yourcompany.Notchify
  ```
- Restart the app

## Development Tips

### Debugging

1. Use **Console.app** to view system logs
2. Add print statements in key methods
3. Use Xcode's debugger with breakpoints

### Testing Onboarding

To re-trigger onboarding:

1. Quit the app
2. Run in Terminal:
   ```bash
   defaults delete com.yourcompany.Notchify isOnboardingComplete
   ```
3. Restart the app

Or use the "Re-run Setup" option in Settings.

### Testing Different Screen Sizes

Change the selected model in Settings to test different notch dimensions:

1. Click menu bar icon → Settings
2. Change Mac Model in the General section
3. The notch window will resize automatically

### Hot Reload

SwiftUI supports live previews:

1. Open any View file
2. Click **Resume** in the preview panel (right side)
3. Edit the view and see changes in real-time

## Next Steps

Now that the foundation is complete, you can:

1. **Test the onboarding flow** - Verify all screens work correctly
2. **Test expand/collapse** - Hover over the notch to expand
3. **Test settings** - Change preferences and verify they persist
4. **Implement features** - Start with Phase 2 (Media Player)

## Additional Configuration

### Launch at Login (macOS 13+)

The app uses `SMAppService` for launch at login. To test:

1. Enable in Settings → General → Launch at Login
2. Restart your Mac
3. Notchify should launch automatically

### Distribution

For distributing outside Xcode:

1. Archive the app (**Product → Archive**)
2. Distribute for direct distribution
3. Notarize with Apple (required for Gatekeeper)
4. Create a DMG or PKG installer

## Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [AppKit Documentation](https://developer.apple.com/documentation/appkit)
- [EventKit Documentation](https://developer.apple.com/documentation/eventkit)
- [Notarization Guide](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)

---

If you encounter any issues not covered here, please open an issue on GitHub.
