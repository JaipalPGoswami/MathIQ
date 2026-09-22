# Math Facts AI 🧮 ⭐

**Math Facts AI** is a production-grade Android educational mathematics application designed for children from **KG through Grade 3** (ages 4–9). Built with Flutter, Dart, Riverpod, Drift/SQLite local-first architecture, and a child-safe AI tutor integration, it transforms math learning into a playful, engaging journey: **Learn → Practice → Play → Review → Improve**.

---

## 1. Project Overview

Math Facts AI bridges educational rigor with kid-first design. Rather than dry question drills or generic CRUD forms, the application delivers tactile 3D buttons, animated visual counters (apples, stars, cookies), custom-drawn analog clocks, interactive pizza fraction slices, 10 themed mini-games, and a gentle conversational AI tutor with voice narration (TTS).

---

## 2. Key Features

- **Grade-Specific Structured Curriculum**:
  - **KG**: Counting 1–100, number recognition, tracing, matching, more/less, addition/subtraction within 10, 2D/3D shapes, patterns, comparison, basic clocks, coins.
  - **Grade 1**: Numbers to 1,000, place value (tens and ones), addition/subtraction within 100 with regrouping intro, multiplication intro (arrays, 2/5/10 tables), fair sharing division, length/weight, picture graphs, word problems.
  - **Grade 2**: Numbers to 10,000, multi-digit operations with carrying/borrowing, times tables 2–10, division facts, fraction fundamentals (halves, thirds, quarters), perimeter, analog time (quarters & minutes), bar graphs.
  - **Grade 3**: Numbers to 100,000, multi-digit operations, times tables 2–12, long division introduction, fractions & decimals, angles & right angles, area introduction, multi-step word problems.
- **11 Deterministic Math Generators**:
  - Arithmetic is computed and verified deterministically with zero risk of AI hallucination.
  - Strict validation of distractors, uniqueness, and grade-appropriate bounds.
- **Adaptive Learning Engine**:
  - Tracks individual skill accuracy and mastery levels: *Beginner (0–39%)*, *Learning (40–59%)*, *Developing (60–79%)*, *Strong (80–94%)*, and *Mastered (95–100%)*.
  - Dynamically adjusts question difficulty based on recent attempts.
- **10 Interactive Mini-Games**:
  1. *Number Match* (visual quantity to digit matching)
  2. *Count the Objects* (tap-to-count animated animals)
  3. *Missing Number* (fill the blank train cars)
  4. *Math Race* (rapid arithmetic countdown)
  5. *Shape Match* (identify geometric shapes and properties)
  6. *Number Ordering* (sort bubble numbers ascending)
  7. *Fraction Pizza* (interactive pizza slice fraction challenge)
  8. *Money Shop* (purchase toys with coins and cash)
  9. *Time Challenge* (read the analog clock)
  10. *Pattern Detective* (crack secret repeating sequences)
- **Child-Safe AI Tutor**:
  - Constrained educational system prompt.
  - Automatic filtering of Personally Identifiable Information (PII) including emails, phone numbers, and addresses.
  - Encouraging, positive-reinforcement responses with zero negative shaming.
  - Instant offline fallback when internet is unavailable.
- **Parent & Teacher Dashboard**:
  - 4-digit PIN gate (Default: `1234`).
  - Child performance breakdown (accuracy, questions solved, mastery radar).
  - Weak-topic diagnosis and smart practice recommendations.
  - Controls for daily goal, sound effects, voice narration, and AI access.
- **Local-First Architecture**:
  - 100% functional without internet connectivity for all curriculum, lessons, practice, games, quizzes, and achievements.

---

## 3. Requirements

- **Operating System**: Windows, macOS, or Linux
- **Flutter SDK**: `>= 3.16.0` (Dart `>= 3.2.0 < 4.0.0`)
- **Android SDK**: API level 21 minimum (Android 5.0 Lollipop), Target API level 34 (Android 14)
- **Java Development Kit**: JDK 17 recommended for Gradle 8+

---

## 4. Flutter Version

This project is tested and compatible with:
```bash
Flutter 3.16.x - 3.24.x
Dart 3.2.x - 3.5.x
```

---

## 5. Installation

1. **Clone or navigate to the repository directory**:
   ```bash
   cd "d:/ANtiGravity/Math IQ"
   ```

2. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify Flutter environment**:
   ```bash
   flutter doctor
   ```

---

## 6. Running the Application

### Connect an Android device or start an Android Virtual Device (AVD):
```bash
# List available devices
flutter devices

# Run in debug mode
flutter run
```

### Tablet & Phone Responsive Testing:
```bash
# Run with device simulation or custom size
flutter run -d windows  # (if desktop enabled) or run on Android tablet emulator
```

---

## 7. Database Architecture

The local database uses **Drift (SQLite)** and persistent storage:
- **`students`**: ID, name, age, grade, avatar, XP, streak, current level.
- **`topics`**: Standardized curriculum items filtered by grade bounds.
- **`attempts`**: Practice history storing question, answer, timestamp, and correctness.
- **`mastery`**: Computed accuracy, total attempts, and mastery tier per topic.
- **`achievements`**: 10 pre-seeded badges with unlock conditions and XP rewards.
- **`settings`**: Daily goals, sound toggles, voice TTS flags, and parent PIN.

---

## 8. AI Setup

The application features an abstract `AiService` architecture.
By default, the app functions in **offline educational mode** with rich built-in explanations. To connect Google Gemini API:

1. Obtain a Gemini API key from [Google AI Studio](https://aistudio.google.com/).
2. Provide the key during app launch or via environment variables:
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your_key_here
   ```
3. Alternatively, route through your enterprise secure backend proxy configured in `GeminiAiService`.

---

## 9. Environment Variables

| Variable | Description | Default |
|---|---|---|
| `GEMINI_API_KEY` | Google Gemini API key | Optional (uses offline mode if absent) |
| `API_PROXY_URL` | Secure AI proxy endpoint | `https://api.mathfactsai.example.com/v1/tutor` |

---

## 10. Firebase Setup (Cloud Integration)

To connect Firebase Authentication and Cloud Firestore:
1. Create a project in the [Firebase Console](https://console.firebase.google.com/).
2. Add an Android App with package name `com.mathfacts.ai`.
3. Download `google-services.json` and place it in:
   ```
   android/app/google-services.json
   ```
4. Run `flutterfire configure` to generate `firebase_options.dart`.

---

## 11. Testing

### Run All Unit and Widget Tests:
```bash
flutter test
```

### Run Math Engine Validation Specifically:
```bash
flutter test test/unit/math_engine_test.dart
```

### Run Adaptive & AI Safety Tests:
```bash
flutter test test/unit/adaptive_test.dart
```

---

## 12. Android Build Instructions

To build a debug APK:
```bash
flutter build apk --debug
```
The resulting APK will be located at:
```
build/app/outputs/flutter-apk/app-debug.apk
```

---

## 13. Release APK & App Bundle Instructions

### 1. Build an Android App Bundle (for Google Play Store):
```bash
flutter build appbundle --release
```
Location: `build/app/outputs/bundle/release/app-release.aab`

### 2. Build a standalone Release APK:
```bash
flutter build apk --release --split-per-abi
```
Location: `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` etc.

---

## 14. Troubleshooting

- **Sound not playing**: Ensure the device volume is unmuted and sound is toggled ON in Settings or the Parent Dashboard.
- **Voice Narration (TTS) silent**: Check that the device has the Google Speech Recognition & Synthesis engine installed (standard on Google Play certified Android devices).
- **Parent Dashboard PIN**: The initial factory PIN is `1234`. It can be updated at any time from the Parent Dashboard settings.
- **Grading & Content Reset**: To start completely fresh, go to Parent Dashboard ➔ Manage Full App Settings ➔ "Clear All Data".
