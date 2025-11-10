# Aurora Mobile Engineer Challenge

A Flutter mobile app that fetches random images from an API and displays them with an adaptive background color that matches the image's dominant colors.

## Features

- ✅ **Single Screen UI** - Clean, focused interface
- ✅ **Square Image Display** - Images are displayed centered as squares
- ✅ **Adaptive Background** - Background color automatically adapts to the image's dominant color
- ✅ **Image Fetching** - "Another" button fetches new random images
- ✅ **Loading States** - Smooth loading indicators while fetching
- ✅ **Error Handling** - Graceful error handling with user-friendly messages
- ✅ **Smooth Transitions** - Fade animations for images and color transitions
- ✅ **Light/Dark Mode** - Full support for light and dark themes with smooth transitions
- ✅ **Accessibility** - Semantic labels and proper accessibility support
- ✅ **Image Caching** - Efficient image caching using `cached_network_image`

## Architecture

The app follows clean architecture principles with:

- **BLoC Pattern** - State management using `flutter_bloc`
- **Repository Pattern** - Data layer abstraction
- **Dependency Injection** - Using `GetIt` for service locator
- **Modular Structure** - Organized into modules (image, theme) and screens

## Project Structure

```
lib/
├── core/
│   ├── di/              # Dependency injection
│   ├── repositories/    # Data repositories
│   ├── services/        # HTTP services
│   └── utils/           # Utilities and constants
├── modules/
│   ├── image/           # Image feature module (BLoC, events, state)
│   └── theme/           # Theme management module
└── screens/
    └── image_viewer/    # Image viewer screen and widgets
```

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- iOS Simulator / Android Emulator or physical device

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd aurora_mobile_challenge
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## API

The app uses the Aurora API endpoint:
- **Base URL**: `https://november7-730026606190.europe-west1.run.app`
- **Endpoint**: `GET /image`
- **Response**: `{"url": "https://images.unsplash.com/..."}`

## Key Technologies

- **Flutter** - UI framework
- **flutter_bloc** - State management
- **cached_network_image** - Image caching
- **palette_generator** - Color extraction from images
- **GetIt** - Dependency injection

## Requirements Met

All requirements from the assignment have been implemented:

- ✅ Single screen UI
- ✅ Square image centered on screen
- ✅ Background color adapts to the image
- ✅ "Another" button below the image
- ✅ Loading state while fetching
- ✅ Error handling
- ✅ Smooth transitions
- ✅ Light/dark mode support
- ✅ Basic accessibility

## Video Demo

[Add link to video demonstration here]

## License

This project is part of the Aurora Mobile Engineer take-home challenge.
