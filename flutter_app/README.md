# CipherX Flutter

CipherX is a Flutter app that bundles lightweight security-learning tools and utilities into a single experience. Explore classical ciphers, perform quick calculations, convert world currencies with live exchange rates, and fetch safe-mode jokes for a quick break.

## Features
- Interactive Caesar, Vigenère, and Atbash cipher playgrounds with instant results and clipboard copy helpers.
- A calculator powered by `math_expressions` for common arithmetic.
- Currency conversion that calls the Frankfurter and WorldTime APIs to display up-to-date rates and the destination market’s local time.
- Random joke feed backed by JokeAPI (safe mode).
- A cohesive, keyboard-friendly UI optimized for desktop and mobile form factors.

## Prerequisites
- Flutter SDK 3.19 or newer (the project targets Dart `^3.9.2`).
- A recent version of Android Studio, VS Code, or Xcode with Flutter tooling installed.
- Android SDK and/or Xcode command-line tools, depending on your target platform.
- An internet connection at runtime (required for the currency and jokes features).

Confirm your Flutter environment with:
```
flutter --version
```

## Installation
1. Clone the repository and move into the Flutter project directory:
   ```
   git clone <repo-url>
   cd GoogleAuth/flutter_app
   ```
2. Fetch the project dependencies:
   ```
   flutter pub get
   ```
3. (Optional) Run the analyzer to verify the codebase locally:
   ```
   flutter analyze
   ```

## Running the App
- **Android/iOS**  
  Connect a device or start an emulator/simulator, then run:
  ```
  flutter run
  ```
  Flutter will prompt you to pick the target if more than one is available.

- **Web (Chrome)**  
  Enable web support if needed (`flutter config --enable-web`) and run:
  ```
  flutter run -d chrome
  ```

- **Windows/macOS/Linux (Desktop)**  
  Ensure desktop support is enabled (`flutter config --enable-<platform>`), then:
  ```
  flutter run -d windows   # or -d macos / -d linux
  ```

## Using CipherX
1. Launch the app to land on the branded `HomeScreen`. Tap or click **Continue** to open the dashboard.
2. From the dashboard:
   - **Cipher Tools** lead to Caesar, Vigenère, and Atbash screens where you can type text, tweak parameters (shift values or keywords), and copy encrypted/decrypted results.
   - **Currency** opens a converter; enter an amount, choose source/target currencies, then tap **Convert** to fetch real-time rates and the destination’s local time.
   - **Calculator** provides quick arithmetic support via an inline expression evaluator.
   - **Random Jokes** pulls a fresh safe-mode joke on load; press **Another one** for more.
3. Use the back button (or navigation bar) to return to the dashboard and switch between tools.

## Troubleshooting
- **Dependencies fail to download**: Ensure you are behind no restrictive proxy or configure `PUB_HOSTED_URL`/`FLUTTER_STORAGE_BASE_URL` appropriately.
- **HTTP requests blocked on iOS**: If you target iOS and encounter App Transport Security errors, add the required ATS exceptions to `ios/Runner/Info.plist`.
- **Timeouts fetching data**: The app retries world time lookups, but if APIs remain unreachable, verify network connectivity or try again later.

## Testing
Run all tests (when present) with:
```
flutter test
```

## Additional Resources
- [Flutter documentation](https://docs.flutter.dev/)
- [Frankfurter API](https://www.frankfurter.app/)
- [WorldTime API](http://worldtimeapi.org/)
- [JokeAPI](https://jokeapi.dev/)
