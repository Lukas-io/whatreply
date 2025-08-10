# WhatReply - WhatsApp Chat UI Clone

A Flutter app that replicates the WhatsApp chat screen with message & reply functionality, featuring a custom background painter with SVG-style art.

## About This Project

This project was created as a request from one of my X followers:

**Bibek Panda** ([@_Pandabibek](https://x.com/_Pandabibek))

**Original Tweet:** [https://x.com/lukasiuu/status/1953944215353803016](https://x.com/lukasiuu/status/1953944215353803016)

## Features

- **WhatsApp-like Chat Interface**: Authentic design with proper colors and styling
- **Message & Reply System**: Full reply functionality with preview
- **Custom Background Art**: Beautiful SVG-style patterns drawn with CustomPainter
- **Real-time Chat**: Simulated conversation with auto-replies
- **Message Actions**: Long-press to reply, copy, or forward messages
- **Responsive Design**: Works on all screen sizes
- **Material 3 Design**: Modern Flutter design system

## Screenshots

The app features:
- WhatsApp green color scheme (#25D366, #128C7E, #075E54)
- Message bubbles with proper styling for sent/received messages
- Reply preview system
- Custom background with geometric patterns and bubbles
- Chat header with contact info and call buttons
- Input field with emoji and send functionality

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
├── main.dart                 # App entry point
├── models/
│   └── message.dart         # Message data model
├── screens/
│   └── chat_screen.dart     # Main chat interface
├── widgets/
│   ├── message_bubble.dart  # Individual message display
│   ├── chat_input.dart      # Message input field
│   └── chat_background_painter.dart # Custom background art
└── utils/
    └── date_utils.dart      # Date formatting utilities
```

## Key Components

### ChatBackgroundPainter
A custom painter that creates beautiful SVG-style background art including:
- Gradient backgrounds
- Floating bubbles
- Geometric patterns (triangles, rectangles)
- Subtle grid lines

### MessageBubble
Displays individual messages with:
- Proper alignment (left/right)
- Reply previews
- Timestamps
- Read receipts
- WhatsApp-style bubble design

### ChatInput
Input field with:
- Text input
- Reply preview
- Send button
- Emoji button (placeholder)

## Dependencies

- `flutter_svg`: SVG support
- `intl`: Date formatting
- `cupertino_icons`: iOS-style icons

## Customization

The app uses authentic WhatsApp colors:
- Primary Green: #25D366
- Secondary Green: #128C7E
- Dark Green: #075E54
- Light Green: #DCF8C6
- Text Colors: #0C1317, #667781

## Future Enhancements

- [ ] Emoji picker integration
- [ ] File sharing
- [ ] Voice messages
- [ ] Group chat support
- [ ] Dark mode
- [ ] Message search
- [ ] Contact list

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is for educational purposes and demonstrates Flutter UI development skills.
