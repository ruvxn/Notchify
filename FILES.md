# Notchify - File Structure

Complete list of all files in the project with descriptions.

## Directory Structure

```
Notchify/
├── App/                          # Main application entry points
├── Models/                       # Data models and configuration
├── Views/                        # SwiftUI views
│   └── Onboarding/              # First-launch setup flow
├── ViewModels/                   # View model layer
├── Utilities/                    # Helper classes and managers
├── Resources/                    # Assets (empty - to be added)
└── Supporting Files/             # Configuration files
```

## Source Files (18 files)

### App Layer (2 files)

#### [NotchifyApp.swift](Notchify/App/NotchifyApp.swift)
**Purpose:** Main app entry point using `@main` attribute
**Key Features:**
- Uses `NSApplicationDelegateAdaptor` to integrate AppDelegate
- Configures app as menu bar only (no main window)
- Entry point for the entire application

**Important Code:**
```swift
@main
struct NotchifyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
}
```

#### [AppDelegate.swift](Notchify/App/AppDelegate.swift)
**Purpose:** Manages menu bar, windows, and app lifecycle
**Key Features:**
- Creates and manages status bar item (menu bar icon)
- Shows onboarding on first launch
- Creates and manages notch window
- Provides menu with Settings, Toggle, and Quit options

**Key Methods:**
- `applicationDidFinishLaunching()` - Checks onboarding status
- `setupMenuBar()` - Creates menu bar icon and menu
- `showNotchWindow()` - Displays the notch interface
- `showOnboarding()` - Presents onboarding window

---

### Models Layer (3 files)

#### [MacBookModel.swift](Notchify/Models/MacBookModel.swift)
**Purpose:** Defines MacBook model types and their notch dimensions
**Key Features:**
- Enum with three cases: `macBook14inch`, `macBook16inch`, `noNotch`
- Each model has specific notch dimensions
- Conforms to `Codable` for UserDefaults storage

**Dimensions:**
- 14-inch: 170pt × 32pt
- 16-inch: 200pt × 37pt
- No Notch: 200pt × 32pt (simulated)

#### [NotchDimensions.swift](Notchify/Models/NotchDimensions.swift)
**Purpose:** Calculates notch dimensions for compact and expanded states
**Key Features:**
- Stores base width and height
- Calculates expanded dimensions using multipliers
- Provides `CGSize` properties for easy use

**Multipliers:**
- Width: 3.0x for expanded state
- Height: 8.0x for expanded state

#### [NotchConfiguration.swift](Notchify/Models/NotchConfiguration.swift)
**Purpose:** Manages user's notch configuration
**Key Features:**
- Stores selected MacBook model
- Saves to UserDefaults with key `selectedMacBookModel`
- Loads saved configuration on app launch

**Key Methods:**
- `loadSaved()` - Retrieves saved configuration
- `save()` - Persists configuration to UserDefaults

---

### Views Layer (9 files)

#### [NotchContentView.swift](Notchify/Views/NotchContentView.swift)
**Purpose:** Main container for notch interface
**Key Features:**
- Observes `NotchWindowManager` for state changes
- Switches between compact and expanded views
- Smooth transitions with spring animations

#### [CompactNotchView.swift](Notchify/Views/CompactNotchView.swift)
**Purpose:** Collapsed state of notch interface
**Key Features:**
- Minimal UI with status indicators
- Animated music note icon
- Notification badge
- Glassmorphism background

**Design:**
- Height matches notch dimensions
- Subtle animations
- Shows current status at a glance

#### [ExpandedNotchView.swift](Notchify/Views/ExpandedNotchView.swift)
**Purpose:** Full notch interface with tabs
**Key Features:**
- Tab navigation for 4 sections (Media, Calendar, Notifications, Chat)
- Placeholder views for each tab (to be implemented)
- Glassmorphism with shadow
- Responsive tab switching

**Tabs:**
1. Media Player
2. Calendar
3. Notifications
4. AI Chat

#### [SettingsView.swift](Notchify/Views/SettingsView.swift)
**Purpose:** Settings and preferences panel
**Key Features:**
- Mac model selection with segmented picker
- Launch at login toggle
- Permission status display
- Reset settings option
- Re-run onboarding option

**Sections:**
- General (model selection, launch at login)
- Permissions (calendar, notifications)
- Advanced (reset, re-run setup)

#### Onboarding Views (5 files)

##### [OnboardingView.swift](Notchify/Views/Onboarding/OnboardingView.swift)
**Purpose:** Container for onboarding flow
**Key Features:**
- Progress bar showing completion
- Navigation between steps
- Back/Next/Skip buttons
- Completion callback

**Flow:**
1. Welcome → 2. Screen Size → 3. Permissions → 4. Complete

##### [WelcomeView.swift](Notchify/Views/Onboarding/WelcomeView.swift)
**Purpose:** First screen introducing the app
**Key Features:**
- App logo/icon
- Feature list with icons
- Welcome message

**Features Shown:**
- 🎵 Media Control
- 📅 Calendar Integration
- 🔔 Notification Center
- 💬 AI Chat

##### [ScreenSizeSelectionView.swift](Notchify/Views/Onboarding/ScreenSizeSelectionView.swift)
**Purpose:** Critical step for selecting Mac model ⭐
**Key Features:**
- Interactive cards for each model
- Visual preview of dimensions
- Selection confirmation
- Cannot proceed without selection

**Why Important:**
This determines all notch sizing for the entire app experience.

##### [PermissionsView.swift](Notchify/Views/Onboarding/PermissionsView.swift)
**Purpose:** Request necessary permissions
**Key Features:**
- Calendar access card
- Notification access card
- Ollama connection check
- Skip option (permissions are optional)

**Permissions:**
- Calendar (EventKit)
- Notifications (UserNotifications)
- Ollama (network check)

##### [CompletionView.swift](Notchify/Views/Onboarding/CompletionView.swift)
**Purpose:** Final onboarding screen
**Key Features:**
- Success message
- Quick tips for using the app
- Summary of granted permissions
- Launch button

---

### ViewModels Layer (1 file)

#### [OnboardingViewModel.swift](Notchify/ViewModels/OnboardingViewModel.swift)
**Purpose:** Manages onboarding state and logic
**Key Features:**
- Tracks current step
- Manages selected model
- Handles permission requests
- Checks Ollama connection
- Saves configuration on completion

**Properties:**
- `currentStep: OnboardingStep` - Current onboarding screen
- `selectedModel: MacBookModel?` - User's Mac selection
- `hasCalendarPermission: Bool` - Calendar access status
- `hasNotificationPermission: Bool` - Notification access status
- `ollamaConnected: Bool` - Ollama connection status

**Key Methods:**
- `nextStep()` - Navigate forward
- `previousStep()` - Navigate backward
- `selectModel()` - Set MacBook model
- `requestCalendarPermission()` - Request calendar access
- `requestNotificationPermission()` - Request notification access
- `checkOllamaConnection()` - Test Ollama connectivity
- `completeOnboarding()` - Save configuration and finish

---

### Utilities Layer (2 files)

#### [PermissionsManager.swift](Notchify/Utilities/PermissionsManager.swift)
**Purpose:** Centralized permission handling
**Key Features:**
- Singleton pattern (`shared` instance)
- Calendar permission management (EventKit)
- Notification permission management (UserNotifications)
- Permission status tracking
- System Settings opener

**Permission Status Enum:**
```swift
enum PermissionStatus {
    case notDetermined
    case denied
    case authorized
    case restricted
}
```

**Key Methods:**
- `requestCalendarAccess()` - Request calendar permission
- `checkCalendarPermission()` - Check current status
- `requestNotificationAccess()` - Request notification permission
- `checkNotificationPermission()` - Check current status
- `openSystemSettings()` - Open Privacy & Security settings

#### [NotchWindowManager.swift](Notchify/Utilities/NotchWindowManager.swift)
**Purpose:** Manages notch window positioning and animations
**Key Features:**
- Singleton pattern (`shared` instance)
- Creates and positions window at screen top
- Handles expand/collapse animations
- Mouse tracking for hover detection
- Dynamic sizing based on configuration

**Key Properties:**
- `isExpanded: Bool` - Current expansion state
- `configuration: NotchConfiguration` - Current notch config
- `notchWindow: NSWindow?` - The actual window

**Key Methods:**
- `createNotchWindow()` - Creates NSWindow with proper positioning
- `expand()` - Animates to expanded state
- `collapse()` - Animates to compact state
- `toggle()` - Switch between states
- `updateConfiguration()` - Apply new notch dimensions

**Window Configuration:**
- Borderless window
- Status bar level (floats above apps)
- Transparent background
- No shadow
- Can't be moved by user
- Spans all spaces

---

### Supporting Files (1 file)

#### [Info.plist](Notchify/Supporting%20Files/Info.plist)
**Purpose:** App configuration and permissions
**Key Settings:**
- `LSUIElement = true` - Menu bar only app (no dock icon)
- `LSMinimumSystemVersion = 14.0` - Requires macOS 14.0+

**Permission Descriptions:**
- `NSCalendarsUsageDescription` - "Notchify needs access to your calendar to display upcoming events..."
- `NSRemindersUsageDescription` - "Notchify needs access to your reminders..."
- `NSAppleEventsUsageDescription` - "Notchify needs to control media playback..."
- `NSMicrophoneUsageDescription` - "Notchify may use the microphone to detect audio..."
- `NSAppleMusicUsageDescription` - "Notchify needs access to Apple Music..."

---

## Documentation Files (4 files)

### [README.md](README.md)
**Purpose:** Main project documentation
**Sections:**
- Features overview
- Requirements
- Installation instructions
- Usage guide
- Configuration options
- Development setup
- Contributing guidelines

### [SETUP.md](SETUP.md)
**Purpose:** Detailed Xcode setup guide
**Sections:**
- Step-by-step Xcode project creation
- File organization
- Build settings configuration
- Signing and capabilities
- Troubleshooting common issues

### [QUICKSTART.md](QUICKSTART.md)
**Purpose:** Get up and running in 5 minutes
**Sections:**
- Quick setup steps
- First launch walkthrough
- Common commands
- Testing guide
- Quick troubleshooting

### [PROJECT_STATUS.md](PROJECT_STATUS.md)
**Purpose:** Current project state and roadmap
**Sections:**
- Completed features checklist
- Architecture overview
- Next steps
- Known limitations
- File statistics

---

## File Count Summary

**Total Files:** 22

**Source Code:**
- Swift files: 18
- Info.plist: 1

**Documentation:**
- Markdown files: 4

**By Category:**
- App: 2 files
- Models: 3 files
- Views: 9 files (5 onboarding + 4 main)
- ViewModels: 1 file
- Utilities: 2 files
- Supporting: 1 file
- Documentation: 4 files

**Lines of Code (estimated):**
- Swift: ~1,800 lines
- Documentation: ~1,200 lines
- Total: ~3,000 lines

---

## Key Files for Getting Started

### Must Read First:
1. [QUICKSTART.md](QUICKSTART.md) - Get running quickly
2. [SETUP.md](SETUP.md) - Detailed setup
3. [README.md](README.md) - Full documentation

### Must Understand:
1. [MacBookModel.swift](Notchify/Models/MacBookModel.swift) - Core configuration
2. [NotchWindowManager.swift](Notchify/Utilities/NotchWindowManager.swift) - Window management
3. [OnboardingViewModel.swift](Notchify/ViewModels/OnboardingViewModel.swift) - Setup flow

### Entry Points:
1. [NotchifyApp.swift](Notchify/App/NotchifyApp.swift) - App starts here
2. [AppDelegate.swift](Notchify/App/AppDelegate.swift) - Main app logic

---

## Files to Modify for Customization

### Change Notch Dimensions:
- [NotchDimensions.swift](Notchify/Models/NotchDimensions.swift)
- [MacBookModel.swift](Notchify/Models/MacBookModel.swift)

### Change UI/Appearance:
- [CompactNotchView.swift](Notchify/Views/CompactNotchView.swift)
- [ExpandedNotchView.swift](Notchify/Views/ExpandedNotchView.swift)

### Change Onboarding Flow:
- [OnboardingView.swift](Notchify/Views/Onboarding/OnboardingView.swift)
- [OnboardingViewModel.swift](Notchify/ViewModels/OnboardingViewModel.swift)

### Add New Features:
- Create new ViewModels in `ViewModels/`
- Create new Views in `Views/`
- Update [ExpandedNotchView.swift](Notchify/Views/ExpandedNotchView.swift) to add tabs

---

## Next Files to Create

### Phase 2: Media Player
- `ViewModels/MediaPlayerViewModel.swift`
- `Views/MediaPlayerView.swift`
- `Services/MediaService.swift`
- `Models/MediaItem.swift`

### Phase 3: Calendar
- `ViewModels/CalendarViewModel.swift`
- `Views/CalendarView.swift`
- `Services/CalendarService.swift`
- `Models/CalendarEvent.swift`

### Phase 4: Notifications
- `ViewModels/NotificationViewModel.swift`
- `Views/NotificationsView.swift`
- `Services/NotificationService.swift`
- `Models/NotificationItem.swift`

### Phase 5: Chat
- `ViewModels/OllamaChatViewModel.swift`
- `Views/ChatView.swift`
- `Services/OllamaService.swift`
- `Models/ChatMessage.swift`

---

**Note:** This document will be updated as the project evolves and new files are added.
