# WhatReply - WhatsApp Chat UI Clone

A Flutter app that replicates the WhatsApp chat screen with message & reply functionality, featuring a custom swipe-to-reply widget and authentic chat interface.

## About This Project

This project was created as a request from one of my X followers:

**Bibek Panda** ([@_Pandabibek](https://x.com/_Pandabibek))

**Original Tweet:** [https://x.com/lukasiuu/status/1953944215353803016](https://x.com/lukasiuu/status/1953944215353803016)

## Features

- **WhatsApp-like Chat Interface**: Authentic design with proper colors and styling
- **Message & Reply System**: Full reply functionality with preview
- **Swipe-to-Reply**: Custom swipe gesture to reply to messages
- **Real-time Chat**: Simulated conversation with auto-replies
- **Message Actions**: Long-press to reply, copy, or forward messages
- **Responsive Design**: Works on all screen sizes
- **Material 3 Design**: Modern Flutter design system

## Screenshots

The app features:
- WhatsApp green color scheme (#25D366, #128C7E, #075E54)
- Message bubbles with proper styling for sent/received messages
- Reply preview system with colored indicators
- Chat header with contact info and call buttons
- Input field with emoji and send functionality
- Custom swipe-to-reply widget

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd whatreply
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── custom_swipe_to_reply_widget.dart  # Custom swipe gesture widget
├── models/
│   ├── message.dart                   # Message data model
│   ├── message_brain.dart            # Chat logic and auto-replies
│   └── message_data.dart             # Sample message data
├── screens/
│   └── chat_screen.dart              # Main chat interface
├── widgets/
│   ├── message_widgets.dart          # Message display components
│   ├── chat_input.dart               # Message input field
│   ├── chat_header.dart              # Chat header with contact info
│   └── messages_list.dart            # Messages list widget
└── utils/
    └── date_utils.dart               # Date formatting utilities
```

## Key Components

### CustomSwipeToReply
A custom widget that enables swipe gestures to reply to messages:
- Swipe left/right to reply
- Visual feedback during swipe
- Reply preview integration

### MessageWidget
Displays individual messages with:
- Proper alignment (left/right)
- Reply previews with colored indicators
- Timestamps
- WhatsApp-style bubble design
- Integration with swipe-to-reply

### ChatInput
Input field with:
- Text input
- Reply preview
- Send button
- Emoji button (placeholder)

### MessageBrain
Handles chat logic including:
- Auto-reply system
- Message management
- Chat simulation

## Dependencies

- `intl: ^0.19.0`: Date formatting
- `cupertino_icons: ^1.0.8`: iOS-style icons
- `flutter_lints: ^5.0.0`: Code quality and linting

## Customization

The app uses authentic WhatsApp colors:
- Primary Green: #25D366
- Secondary Green: #128C7E
- Dark Green: #075E54
- Light Green: #DCF8C6
- Text Colors: #0C1317, #667781
- Reply Indicators: #6640FF (received), #FA3E51 (sent)

## Future Enhancements

- [ ] Emoji picker integration
- [ ] File sharing
- [ ] Voice messages
- [ ] Group chat support
- [ ] Dark mode
- [ ] Message search
- [ ] Contact list
- [ ] Message reactions

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is for educational purposes and demonstrates Flutter UI development skills.
