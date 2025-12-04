# ZoomSMS - ZoomConnect Interactive API Flutter App

A Flutter application for sending SMS messages via the ZoomConnect Interactive API.

## Setup Instructions

### 1. Install Flutter
Make sure you have Flutter installed. Visit [flutter.dev](https://flutter.dev) for installation instructions.

### 2. Configure API Credentials

Open `lib/api/zoomconnect_service.dart` and replace the placeholder values:

```dart
static const String _restApiToken = 'e702a972-2749-4513-a2f9-5ad2bbd22dac';
static const String _emailAddress = 'YOUR_EMAIL_HERE'; // Your ZoomConnect account email
```

**Important:** 
- The REST API token is already configured from your account
- You only need to add your ZoomConnect account email address
- Get these from: Account Settings > Developer Settings at [https://zoomconnect.com](https://zoomconnect.com)

### 3. Install Dependencies

Run the following command in the project directory:

```bash
flutter pub get
```

### 4. Run the App

Connect a device or start an emulator, then run:

```bash
flutter run
```

## Features

- Send SMS messages to predefined contact groups
- Four predefined message templates
- Three contact groups (A, B, C)
- Loading indicators during API calls
- Success/failure notifications
- Clean, simple UI

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── api/
│   └── zoomconnect_service.dart # ZoomConnect API integration
├── models/
│   └── contact_group.dart       # Contact group data model
└── screens/
    └── home_screen.dart         # Main UI screen
```

## Usage

1. Open the app
2. Tap on any message button
3. Select a contact group
4. The message will be sent to all recipients in that group
5. You'll see a confirmation message

## API Documentation

This app uses the ZoomConnect Interactive API. For more information, visit:
[https://zoomconnect.com/interactive-api/](https://zoomconnect.com/interactive-api/)

## Security Note

⚠️ **Never commit your API credentials to version control!**

Consider using environment variables or a secure configuration file for production apps.
