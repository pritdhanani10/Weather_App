# 🌌 Aether Weather (Weather_App)

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20%2B%20TDD-blueviolet?style=for-the-badge)](#architecture)
[![BLoC](https://img.shields.io/badge/State%20Management-BLoC%208.x-blue?style=for-the-badge)](https://bloclibrary.dev)
[![Design](https://img.shields.io/badge/Design%20System-Stitch%20Midnight%20Glass-00f2fe?style=for-the-badge)](#design-system--aetherial-midnight-glass)
[![Tests](https://img.shields.io/badge/Tests-15%2F15%20Passing-success?style=for-the-badge)](#testing)

A state-of-the-art, atmospheric Flutter weather application engineered with **Clean Architecture**, **Test-Driven Development (TDD)**, **BLoC State Management**, and a custom-crafted **Aetherial Midnight Glass** design system generated via **Stitch**.

---

## ✨ Features

- **Atmospheric Celestial Visuals**: Deep void base (`#0A0E27`) and midnight depths with ambient radial glow pools in electric cyan and borealis violet.
- **Translucent Glassmorphic UI**: Frosted multi-tier glass surfaces built with `BackdropFilter`, inner lighting highlights, and hairline borders.
- **Live Search & Telemetry**:
  - Search bar with automated 500ms debounce to minimize network overhead.
  - Safe input validation (prevents blank/whitespace query errors).
  - One-tap quick destination pills (`London`, `Tokyo`, `Paris`, `Sydney`, `Berlin`, `Dubai`) with active glowing states.
- **Dynamic Temperature Unit Switcher**: Toggle instantly between Celsius (`°C`) and Fahrenheit (`°F`) with real-time conversion across all views.
- **Hero Condition Display**:
  - Live update indicator pip.
  - Giant lightweight temperature typography.
  - Current conditions badge (`Scattered Clouds`, `Clear Sky`, etc.).
  - Feels-like temperature and High/Low range.
- **Hourly Forecast Slider**: Smooth edge-to-edge horizontal track displaying the next 16 hours with weather glyphs and predicted temperatures.
- **2x2 Meteorological Metric Grid**:
  - **Wind Speed & Direction**: Real-time velocity with compass orientation (`NW`) and breeze description.
  - **Humidity**: Relative atmospheric moisture percentage and dew point status.
  - **Barometric Pressure**: Atmospheric pressure in `hPa` with stability rating.
  - **Feels Like / Thermal Index**: Perceived temperature based on humidity and air movement.
- **5-Day Weather Outlook**: Daily predictions with icons and min/max temperature gradient indicator bars.
- **Robust Error & Empty States**:
  - Atmospheric satellite syncing loading animation.
  - Offline / city not found card with one-tap retry.
  - Interactive welcome screen with exploration trigger.

---

## 🎨 Design System — Aetherial Midnight Glass

The visual identity was designed using **Stitch** (`Modern Atmospheric Weather App`):

| Token | Value | Description |
|---|---|---|
| `AppTheme.voidBase` | `#0A0E27` | Foundational celestial background |
| `AppTheme.deepMidnight` | `#0D1538` | Secondary depth container |
| `AppTheme.electricCyan` | `#00F2FE` | Primary accent, active borders, and glows |
| `AppTheme.ionBlue` | `#4FACFE` | Secondary telemetry and progress gradients |
| `AppTheme.borealisViolet` | `#7F00FF` | Ambient radial pool glow |
| `AppTheme.glassSurfaceStandard` | `rgba(255,255,255, 0.06)` | Translucent frosted glass card base |
| `AppTheme.glassBorder` | `rgba(255,255,255, 0.12)` | Subtle hairline glass border |

---

## 🏛️ Architecture

The codebase strictly adheres to Uncle Bob's **Clean Architecture** principles separated into four concentric layers:

```
lib/
├── core/
│   ├── constants/        # API endpoints, design tokens, and theme colors
│   └── error/            # Failures, exceptions, and error mappings
├── data/
│   ├── data_sources/     # Remote OpenWeatherMap HTTP client implementation
│   ├── models/           # JSON serializable data models extending domain entities
│   └── repositories/     # Concrete repository implementations mapping models to entities
├── domain/
│   ├── entities/         # Core business models (WeatherEntity)
│   ├── repositories/     # Abstract repository contracts
│   └── usecases/         # Single-responsibility business use cases (GetCurrentWeather)
├── presentation/
│   ├── bloc/             # WeatherBloc, Events (OnCityChanged), and States
│   └── pages/            # WeatherPage and custom glassmorphic widgets
└── injection_container.dart # Service locator (GetIt) dependency injection configuration
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.0.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.0.0`)
- An OpenWeatherMap API Key (A default demonstration key is included in `constants.dart`).

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/Weather_App.git
   cd Weather_App/Weather_App
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   # Run on connected mobile device, emulator, or chrome
   flutter run
   ```

---

## 🧪 Testing

The application is thoroughly covered by unit and widget tests following TDD principles:

```bash
# Run all unit, bloc, and widget tests
flutter test

# Run static analysis
flutter analyze
```

### Test Suite Overview
- **Data Source Tests**: Verify HTTP status codes (200 OK, 404/500 errors).
- **Model Tests**: Verify JSON decoding, numerical safety, serialization, and entity conversion.
- **Repository Tests**: Verify caching/network logic and failure mapping (`ServerFailure`, `ConnectionFailure`).
- **Use Case Tests**: Verify business logic contract execution.
- **BLoC Tests**: Verify state transitions (`WeatherEmpty` → `WeatherLoading` → `WeatherLoaded` / `WeatherLoadFailure`) with debounced stream transformations.
- **Widget Tests**: Verify TextField interaction, loading indicators, and `Key('weather_data')` view rendering with mocked HTTP overrides.

---

## 📦 Tech Stack & Dependencies

- **State Management**: [`flutter_bloc`](https://pub.dev/packages/flutter_bloc)
- **Functional Programming**: [`dartz`](https://pub.dev/packages/dartz) (Either, Left, Right)
- **Value Equality**: [`equatable`](https://pub.dev/packages/equatable)
- **Dependency Injection**: [`get_it`](https://pub.dev/packages/get_it)
- **Networking**: [`http`](https://pub.dev/packages/http)
- **Reactive Extensions**: [`rxdart`](https://pub.dev/packages/rxdart) (debounce transformer)
- **Mocking & Test Helpers**: [`mockito`](https://pub.dev/packages/mockito), [`mocktail`](https://pub.dev/packages/mocktail), [`bloc_test`](https://pub.dev/packages/bloc_test)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
