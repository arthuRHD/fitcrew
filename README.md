<div align="center">
  <img src="assets/png/color_with_background.png" alt="FitCrew Logo" width="500"/>
</div>

[![Build & Deploy](https://github.com/arthurhd/fitcrew/actions/workflows/firebase-hosting-merge.yml/badge.svg)](https://github.com/arthurhd/fitcrew/actions/workflows/firebase-hosting-merge.yml)
[![Coverage](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Farthurhd.github.io%2Ffitcrew%2Fcoverage%2Fbadge.json&query=%24.coverage&label=Coverage)](https://arthurhd.github.io/fitcrew/coverage/)
[![Flutter Version](https://img.shields.io/badge/flutter-3.27.4-blue.svg)](https://flutter.dev/docs/get-started/install)
[![Style: Very Good Analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

A fitness tracking application built with Flutter and Firebase.

## Features

- 🔐 Secure authentication with Firebase Auth
  - Email/Password login
  - Google Sign-In integration
  - Persistent sessions
- 👤 User profile management
- 📱 Cross-platform support
  - Web deployment with Firebase Hosting
  - Android & iOS support (coming soon)
- 🎨 Modern Material Design 3
- 🧪 Comprehensive test coverage

## Tech Stack

### Frontend
- **Flutter 3.27.4** - UI framework
- **Riverpod** - State management
- **GoRouter** - Navigation
- **Font Awesome** - Icons
- **Very Good Analysis** - Lint rules

### Backend & Services
- **Firebase Auth** - Authentication
- **Firebase Hosting** - Web deployment

### Tools
- **GitHub Actions** - CI/CD
- **GitHub Pages** - Coverage reports

## Development Setup

### Prerequisites

- Flutter 3.27.4
- Firebase CLI
- Node.js 20.x
- LCOV (for coverage reports)

### Local Development

1. Clone and install dependencies:
```bash
git clone https://github.com/arthur-rcd/fitcrew.git
cd fitcrew
flutter pub get
```

2. Configure Firebase:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

3. Run tests:
```bash
# Web tests
./scripts/run_tests.sh chrome

# View coverage report
open coverage/html/index.html
```

4. Run the app:
```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

## CI/CD Pipeline

### Pull Requests
- Runs tests
- Generates coverage report
- Creates preview deployment
- Uploads coverage artifacts

### Main Branch
- Runs tests
- Updates coverage report on GitHub Pages
- Deploys to Firebase Hosting production

## Project Structure

```
lib/
├── main.dart
├── providers/          # Riverpod providers
├── router/            # GoRouter configuration
├── screens/           # UI screens
│   ├── auth/         # Authentication screens
│   ├── home/         # Main app screens
│   └── profile/      # User profile
├── theme/            # App theming
└── widgets/          # Reusable components

test/                 # Test files matching lib/ structure
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Ensure tests pass (`./scripts/run_tests.sh chrome`)
4. Commit your changes (`git commit -m 'Add some amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
