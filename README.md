# Notchify

Transform your MacBook's notch into a powerful Dynamic Island-style productivity hub.

![Notchify Banner](https://via.placeholder.com/800x200?text=Notchify)

## Features

- 🎵 **Media Player** - Control your music with beautiful album artwork and waveform visualization
- 📅 **Calendar Integration** - View upcoming events at a glance
- 🔔 **Notification Center** - Manage system notifications seamlessly
- 💬 **AI Chat** - Chat with local LLM powered by Ollama
- ✨ **Dynamic Animations** - Smooth expand/collapse animations with glassmorphism effects
- 🎨 **Adaptive Design** - Automatically adjusts to 14" or 16" MacBook Pro models

## Requirements

- macOS 14.0 (Sonoma) or later
- MacBook Pro with notch (14" or 16") recommended
- Xcode 15.0+ (for development)
- [Ollama](https://ollama.ai) (optional, for AI chat features)

## Installation

### From Source

1. Clone the repository:

```bash
git clone https://github.com/yourusername/Notchify.git
cd Notchify
```

2. Open the project in Xcode:

```bash
open Notchify.xcodeproj
```

3. Build and run the project (⌘R)

### First Launch

On first launch, Notchify will guide you through a setup process:

1. **Welcome Screen** - Introduction to features
2. **Screen Size Selection** - Choose your MacBook model (14" or 16")
3. **Permissions Setup** - Grant calendar and notification access
4. **Ollama Connection** - Optionally connect to local Ollama instance
5. **Ready to Go!** - Start using Notchify

## Usage

### Basic Controls

- **Hover** over the notch to expand the interface
- **Click outside** to collapse back to compact mode
- **Menu bar icon** provides quick access to settings

### Features

#### Media Player

- Displays currently playing media from Apple Music, Spotify, and system audio
- Control playback with play/pause, next/previous buttons
- Animated waveform visualization
- Progress bar with seek functionality

#### Calendar

- Shows today's events and upcoming week
- Color-coded by calendar
- Countdown to next event
- Click events to view details

#### Notifications

- Monitors system notifications
- Click to open source application
- Notification history
- Clear individual or all notifications

#### AI Chat

- Requires [Ollama](https://ollama.ai) running locally
- Chat with various LLM models
- Conversation history saved locally
- Markdown rendering for responses

## Configuration

### Settings Panel

Access settings from the menu bar icon → Settings:

- **Mac Model** - Change your MacBook model selection
- **Launch at Login** - Automatically start Notchify on login
- **Permissions** - Manage calendar and notification access
- **Re-run Setup** - Go through onboarding again
- **Reset Settings** - Clear all preferences

### Ollama Setup

To use the AI chat feature:

1. Install [Ollama](https://ollama.ai)
2. Pull a model: `ollama pull llama2`
3. Start Ollama: `ollama serve`
4. Notchify will automatically detect the connection

## Project Structure

```
Notchify/
├── App/
│   ├── NotchifyApp.swift          # Main app entry point
│   └── AppDelegate.swift          # Menu bar and window management
├── Views/
│   ├── Onboarding/                # First-launch setup flow
│   │   ├── WelcomeView.swift
│   │   ├── ScreenSizeSelectionView.swift
│   │   ├── PermissionsView.swift
│   │   └── CompletionView.swift
│   ├── NotchContentView.swift     # Main notch interface
│   ├── CompactNotchView.swift     # Collapsed state
│   ├── ExpandedNotchView.swift    # Expanded state with tabs
│   └── SettingsView.swift         # Settings panel
├── ViewModels/
│   └── OnboardingViewModel.swift  # Onboarding state management
├── Models/
│   ├── MacBookModel.swift         # MacBook model definitions
│   ├── NotchDimensions.swift      # Dimension calculations
│   └── NotchConfiguration.swift   # User configuration
├── Utilities/
│   ├── NotchWindowManager.swift   # Window positioning and animations
│   └── PermissionsManager.swift   # Permission handling
└── Supporting Files/
    └── Info.plist                 # App configuration and permissions
```

## Development

### Building

1. Open `Notchify.xcodeproj` in Xcode
2. Select your development team in Signing & Capabilities
3. Build and run (⌘R)

### Architecture

- **SwiftUI** for all UI components
- **AppKit** for menu bar integration and window management
- **EventKit** for calendar access
- **UserNotifications** for notification monitoring
- **URLSession** for Ollama API communication

### Key Components

- **NotchWindowManager** - Handles window positioning, sizing, and expand/collapse animations
- **PermissionsManager** - Centralized permission handling
- **OnboardingViewModel** - Manages first-launch setup flow
- **NotchConfiguration** - Stores and loads user preferences

## Roadmap

### Phase 1: Foundation ✅

- [x] Onboarding flow with screen size selection
- [x] Notch window with dynamic sizing
- [x] Expand/collapse animations
- [x] Settings panel

### Phase 2: Media Player (In Progress)

- [ ] MPRemoteCommandCenter integration
- [ ] Album artwork display
- [ ] Waveform visualization
- [ ] Playback controls

### Phase 3: Calendar & Notifications

- [ ] EventKit integration
- [ ] Event display and filtering
- [ ] Notification monitoring
- [ ] Notification history

### Phase 4: Ollama Chat

- [ ] Ollama API client
- [ ] Streaming chat responses
- [ ] Model selection
- [ ] Conversation persistence

### Phase 5: Polish

- [ ] Performance optimization
- [ ] Edge case handling
- [ ] App icon and branding
- [ ] Distribution build

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by Apple's Dynamic Island on iPhone 14 Pro
- Built with SwiftUI and AppKit
- Powered by [Ollama](https://ollama.ai) for local LLM capabilities

## Support

If you encounter any issues or have questions:

- Open an [Issue](https://github.com/yourusername/Notchify/issues)
- Check existing issues for solutions
- Review the [Wiki](https://github.com/yourusername/Notchify/wiki) for detailed documentation

---
