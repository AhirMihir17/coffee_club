# ☕ Coffee Club App

A modern Flutter application demonstrating **Firebase Authentication** integrated with a **Coffee Shop Application** using clean architecture and **BLoC / Cubit** state management.

---

## 📌 Table of Contents

- [🚨 Mandatory Coding Rules & Pre-Instructions](#-mandatory-coding-rules--pre-instructions)
- [⚠️ Pre-Instructions & Prerequisites](#️-pre-instructions--prerequisites)
- [🔥 Firebase Setup & Configuration](#-firebase-setup--configuration)
- [🚀 Quick Start & Installation](#-quick-start--installation)
- [🧱 Project Architecture & Tech Stack](#-project-architecture--tech-stack)
- [📁 Folder Structure](#-folder-structure)
- [✨ Features](#-features)
- [🔧 Common Commands](#-common-commands)
- [🩺 Troubleshooting](#-troubleshooting)

---

## 🚨 Mandatory Coding Rules & Pre-Instructions

> [!IMPORTANT]
> All contributors and developers working on this codebase **must adhere strictly** to the following core engineering rules:

### 1. 🚫 Strictly No `setState()` Anywhere
- **Never call `setState()`** inside widgets.
- Every piece of UI state (form inputs, toggles, loading, lists, modal dialogs) must be handled cleanly using **BLoC / Cubit** (`BlocBuilder`, `BlocConsumer`, or `BlocListener`).
- Keep UI widgets stateless (`StatelessWidget`) whenever possible.

```dart
// ❌ WRONG:
setState(() {
  _isLoading = true;
});

// ✅ CORRECT:
context.read<LoginCubit>().login(email, password);
// Let BlocBuilder/BlocConsumer react to state changes in the UI
```

---

### 2. 🎨 Use Custom Design System Components Exclusively
Do **NOT** use default Flutter Material / Cupertino primitives directly in feature screens. Always import and use our shared custom components from [`lib/core/widgets/`](file:///D:/firebase_learning/lib/core/widgets) and styling from [`lib/core/theme/`](file:///D:/firebase_learning/lib/core/theme):

| Category | ❌ Do NOT Use | ✅ Use Our Custom Component | File Reference |
|---|---|---|---|
| **Text** | `Text(...)` | `AppText(...)` | [`lib/core/widgets/app_text.dart`](file:///D:/firebase_learning/lib/core/widgets/app_text.dart) |
| **Input Field** | `TextField(...)`, `TextFormField(...)` | `AppTextField(...)` | [`lib/core/widgets/app_text_field.dart`](file:///D:/firebase_learning/lib/core/widgets/app_text_field.dart) |
| **Buttons** | `ElevatedButton(...)`, `TextButton(...)` | `AppButton(...)` | [`lib/core/widgets/app_button.dart`](file:///D:/firebase_learning/lib/core/widgets/app_button.dart) |
| **Toggle / Switch** | `Switch(...)`, `CupertinoSwitch(...)` | `AppSwitch(...)` | [`lib/core/widgets/app_switch.dart`](file:///D:/firebase_learning/lib/core/widgets/app_switch.dart) |
| **Cards / Containers**| `Card(...)` | `AppCard(...)` | [`lib/core/widgets/app_card.dart`](file:///D:/firebase_learning/lib/core/widgets/app_card.dart) |
| **Images & Loading** | `Image.network(...)`, `CircularProgressIndicator()` | `CustomCachedImage(...)`, `AuthShimmer(...)` | [`lib/core/widgets/`](file:///D:/firebase_learning/lib/core/widgets) |
| **Colors & Fonts** | Hardcoded `Colors.blue`, raw `TextStyle` | `AppTheme`, theme color schemes, or typography helpers | [`lib/core/theme/app_theme.dart`](file:///D:/firebase_learning/lib/core/theme/app_theme.dart) |

---

### 3. 📦 Manage States Properly (Clean State Modeling)
- **Do not carry all data across every state**:
  - Initial and Loading states must remain lightweight and lean. Do not attach dummy data or carry stale payloads into states where they do not belong.
  - **Only supply and load data in the `Success` (or loaded) state**: The UI should only receive and render the data payload when the state successfully resolves.
  - In the **`Error` state**, keep it simple: **only pass a simple error message string** (e.g. `final String errorMessage`), without carrying unnecessary payloads.

```dart
// ❌ WRONG: Stuffing all data onto every state
class DataState {
  final List<Item> items;
  final bool isLoading;
  final String? error;
  // Bloats states and mixes concerns...
}

// ✅ CORRECT: Standalone separate abstract class per state file without Equatable
abstract class CoffeeState {
  const CoffeeState();
}

class CoffeeInitial extends CoffeeState {
  const CoffeeInitial();
}

class CoffeeLoading extends CoffeeState {
  const CoffeeLoading();
}

class CoffeeSuccess extends CoffeeState {
  final List<CoffeeItem> items; // Data is ONLY exposed when success is achieved!
  const CoffeeSuccess(this.items);
}

class CoffeeError extends CoffeeState {
  final String errorMessage; // Simple, clean error message only
  const CoffeeError(this.errorMessage);
}
```

---

### 4. 🛡️ Mandatory `try-catch` for Firebase & External Operations
- **Every call to Firebase** (Authentication, Firestore, Storage) or external asynchronous services **must be wrapped in a `try-catch` block**.
- Catch specific Firebase exceptions (`FirebaseAuthException`, `FirebaseException`) first to provide granular feedback, followed by generic fallback `catch (e)`.
- Translate exceptions into clear error message strings and emit the respective `Error` state (or notify via `ToastUtils`).

```dart
// ✅ Standard pattern in Cubits / Services / Repositories:
Future<void> authenticateUser(String email, String password) async {
  emit(AuthLoading());
  try {
    final user = await _authRepository.signIn(email, password);
    emit(AuthSuccess(user));
  } on FirebaseAuthException catch (e) {
    emit(AuthError(e.message ?? 'Authentication failed. Please try again.'));
  } catch (e) {
    emit(AuthError('An unexpected error occurred: ${e.toString()}'));
  }
}
```

---

## ⚠️ Pre-Instructions & Prerequisites

Before cloning, building, or running this application, please ensure the following pre-requirements are fulfilled on your development machine.

### 1. Developer Environment Checklist
- [ ] **Flutter SDK**: Ensure Flutter 3.10+ (or compatible SDK `^3.10.4`) is installed.
  ```bash
  flutter --version
  ```
- [ ] **Dart SDK**: Bundled with Flutter.
- [ ] **System Health Check**: Run `flutter doctor` and verify that all necessary components (Android toolchain, IDE plugins, etc.) are green/healthy:
  ```bash
  flutter doctor
  ```
- [ ] **IDE**: [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) with the Flutter & Dart extensions installed.
- [ ] **Git**: Installed and configured.

### 2. Platform Specific Requirements

#### Android
- **Android Studio** with Android SDK Command-line Tools and Android SDK Build-Tools.
- **Java Development Kit (JDK)**: Version 11 or 17 recommended.
- Minimum Android API: **21** (Android 5.0 Lollipop) or higher.
- An active Android Emulator or physical device connected with **USB Debugging** enabled.

#### iOS / macOS (Optional / Apple Machines Only)
- **macOS** with the latest version of **Xcode** installed.
- **CocoaPods** installed:
  ```bash
  sudo gem install cocoapods
  ```

---

## 🔥 Firebase Setup & Configuration

This project relies on **Firebase Authentication** and Firebase Core services. Follow these pre-instructions before running the app:

### 1. Firebase Project Setup
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create or select a Firebase project (default project referenced: `fir-learning-e0772`).
3. Navigate to **Build > Authentication** and click **Get Started**.
4. In the **Sign-in method** tab, enable the **Email/Password** provider.

### 2. Configuration Files

#### Android (`google-services.json`)
- Place your downloaded `google-services.json` file inside:
  ```
  android/app/google-services.json
  ```
- Make sure the `package_name` in `google-services.json` matches your `applicationId` in `android/app/build.gradle`.

#### iOS (`GoogleService-Info.plist`)
- Download `GoogleService-Info.plist` from Firebase Console.
- Open the `ios` directory in Xcode and drag `GoogleService-Info.plist` into `Runner` (select *Copy items if needed*).

### 3. (Optional) Re-configuring via FlutterFire CLI
If you want to connect your own Firebase project or re-generate options:
```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Activate FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for the app
flutterfire configure
```
This updates [lib/firebase_options.dart](file:///D:/firebase_learning/lib/firebase_options.dart).

---

## 🚀 Quick Start & Installation

Follow these steps to run the application locally:

### 1. Clone the Repository
```bash
git clone <repository-url>
cd firebase_learning
```

### 2. Install Dependencies
Fetch all required Dart and Flutter packages:
```bash
flutter pub get
```

### 3. Ensure Assets and Fonts are Available
Check that all image assets defined in `pubspec.yaml` exist under `assets/`:
```
assets/
├── images/
├── png/
└── svg/
```

### 4. Run the Application
Launch on your connected device or emulator:
```bash
# Run in debug mode
flutter run

# Or target a specific device
flutter devices
flutter run -d <device-id>
```

---

## 🧱 Project Architecture & Tech Stack

The application follows clean state-management principles using **BLoC / Cubit**:

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) & [`equatable`](https://pub.dev/packages/equatable)
- **Backend / Authentication**: [`firebase_auth`](https://pub.dev/packages/firebase_auth) & [`firebase_core`](https://pub.dev/packages/firebase_core)
- **Design & Typography**: [`google_fonts`](https://pub.dev/packages/google_fonts), [`flutter_svg`](https://pub.dev/packages/flutter_svg)
- **UI Components**: [`toastification`](https://pub.dev/packages/toastification), [`shimmer`](https://pub.dev/packages/shimmer), [`cached_network_image`](https://pub.dev/packages/cached_network_image)

### Architecture Flow:
```
UI (Screens / Widgets)
       ↕ (Events / States)
Cubit / Bloc Layer
       ↕
Repository Layer (Data abstraction)
       ↕
Data Service Layer (Firebase Auth Service)
```

---

## 📁 Folder Structure

```
lib/
├── app.dart                   # Root MultiBlocProvider & MaterialApp configuration
├── firebase_options.dart      # FlutterFire auto-generated configuration
├── main.dart                  # Entry point with Firebase.initializeApp()
│
├── core/                      # Shared core modules
│   ├── constants/             # App colors, styles, string constants
│   ├── repository/            # Repositories (Auth, SignUp, ForgotPassword)
│   ├── service/               # External services (FirebaseAuthService)
│   ├── theme/                 # AppTheme (Light & Dark) and ThemeCubit
│   ├── utils/                 # Utility helpers (ToastUtils, validators)
│   └── widgets/               # Reusable widgets (AppButton, AppTextField, Shimmer, etc.)
│
├── screens/                   # Authentication screens
│   ├── auth_gate/             # Listens to auth state and routes (Auth vs Coffee App)
│   ├── login/                 # Login screen, Cubit, models & form widgets
│   ├── signup/                # Sign up screen, Cubit & models
│   └── forgot_password/       # Password reset screen, Cubit & models
│
└── coffee/                    # Coffee Shop module
    ├── cubit/                 # Main coffee state cubit
    ├── models/                # Coffee item models & data entities
    ├── screens/
    │   ├── cart/              # Cart screen & CartCubit
    │   ├── detail/            # Item detail screen
    │   ├── favorites/         # Favorites list & FavoritesCubit
    │   ├── home/              # Coffee catalog & HomeCubit
    │   ├── main/              # Main bottom navigation container & NavigationCubit
    │   ├── profile/           # User profile screen & ProfileCubit
    │   └── coffee_welcome_screen.dart
    └── widgets/               # Coffee-specific UI components
```

---

## ✨ Features

- **Authentication Flow**:
  - 🔐 Login with email and password
  - 📝 User registration with form validation
  - 🔄 Forgot password recovery email dispatch
  - 🛡️ `AuthGate` ensuring protected access to coffee features
- **Coffee Shop Experience**:
  - ☕ Coffee catalog browsing by categories
  - 🔍 Coffee item details and customizations
  - 🛒 Cart management with dynamic total calculations
  - ❤️ Favorites bookmarking
  - 👤 User profile screen
- **UI/UX & Themes**:
  - 🌓 Dark / Light mode switching powered by `ThemeCubit`
  - 🍞 Custom interactive toasts via `toastification`
  - ⚡ Shimmer loading placeholders for smooth visual transitions

---

## 🔧 Common Commands

```bash
# Fetch dependencies
flutter pub get

# Clean build cache and temporary files
flutter clean

# Analyze code for lints and formatting issues
flutter analyze

# Format code
dart format lib/

# Build Android APK
flutter build apk --release

# Build Android App Bundle (for Play Store)
flutter build appbundle
```

---

## 🩺 Troubleshooting

| Issue | Cause | Solution |
|---|---|---|
| `DefaultFirebaseOptions have not been configured` | Missing configuration for current platform | Run `flutterfire configure` to generate platform bindings. |
| `google-services.json not found` | File missing in `android/app/` | Download it from Firebase Console and copy to [android/app/google-services.json](file:///D:/firebase_learning/android/app/google-services.json). |
| `FirebaseAuthException: user-not-found` / `wrong-password` | Invalid login credentials | Verify user credentials in Firebase Console > Authentication. |
| Gradle build failure on Android | Outdated Gradle cache or JDK mismatch | Run `flutter clean`, followed by `cd android && ./gradlew clean`. Ensure JDK 17 is active. |
| CocoaPods errors (iOS) | Pods not installed or out of sync | Run `cd ios && pod install --repo-update`. |

---

## 📝 Custom Developer Instructions

> [!NOTE]
> Add any team-specific guidelines, environment variables, or onboarding instructions here:
> - Ensure Git commits follow conventional commits format (e.g. `feat:`, `fix:`, `chore:`).
> - Never commit secret production keys or sensitive Firebase production credentials.
