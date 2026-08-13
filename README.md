# cordova-plugin-lottie-splashscreen

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Shows [Airbnb Lottie](https://airbnb.io/lottie/) animations as the native splash screen on iOS and Android.

**Repository:** [github.com/gizmo0506/cordova-plugin-lottie-splashscreen](https://github.com/gizmo0506/cordova-plugin-lottie-splashscreen)

> **Based on** [timbru31/cordova-plugin-lottie-splashscreen](https://github.com/timbru31/cordova-plugin-lottie-splashscreen) by Tim Brust. This fork adds Capacitor 8 support, Swift Package Manager for iOS, and updated native dependencies.

## What's different in this fork (v1.0.1)

- **Capacitor 8** compatible as a **Cordova plugin** (required for Android native code to sync)
- iOS **Swift Package Manager** via `plugin.xml` `package="swift"` + root `Package.swift` (CocoaPods fallback via `podspec` when the app uses Pods)
- Updated native deps: **Lottie Android 6.7.x**, **lottie-spm 4.6.x**, current AndroidX
- Capacitor-friendly JS bridge (`whenCordovaBridgeReady`)
- Android Capacitor crash fix (`webView.getView()` for animation events)

### Important: do not add a `capacitor` key to `package.json`

Capacitor CLI treats any `"capacitor": { ... }` entry in `package.json` as a **native Capacitor plugin** and skips `plugin.xml` on all platforms. This fork has no `capacitor.android` implementation, so Android would silently lose Kotlin sources and Gradle deps. Keep the **`cordova`** block only; iOS SPM is wired through `plugin.xml` + `Package.swift` instead.

## Supported platforms

| Platform | Requirement |
| --- | --- |
| **Capacitor** | 8.x (optional peer dep) |
| **iOS** | 15+ with cordova-ios **8+** or Capacitor 8 SPM |
| **Android** | cordova-android **10+**, AndroidX, Kotlin |

Pure Cordova projects without Capacitor 8 are still supported; this fork is primarily maintained for Capacitor 8 apps.

## Installation

### Capacitor 8 (recommended)

From GitHub:

```sh
npm install github:gizmo0506/cordova-plugin-lottie-splashscreen#v1.0.1
npx cap sync
```

After sync you should see **`Found 1 Cordova plugin`** for both Android and iOS. If the plugin is missing from that list, check that `package.json` has no top-level `"capacitor"` key.

Or pin a local checkout:

```sh
npm install ../cordova-plugin-lottie-splashscreen
npx cap sync
```

Add preferences in `capacitor.config.ts` (Capacitor does not read Cordova `config.xml` preferences automatically):

```ts
import type { CapacitorConfig } from '@capacitor/cli'

const config: CapacitorConfig = {
  // ...
  cordova: {
    preferences: {
      LottieAnimationLocation: 'public/lottie/splash.json',
      LottieAutoHideSplashScreen: 'true',
      LottieHideAfterAnimationEnd: 'true',
      LottieBackgroundColor: '#ffffff',
    },
  },
}

export default config
```

Place your Lottie JSON under `public/` so it is copied into the native app bundle.

Hide the splash from app code when your UI is ready:

```ts
declare const lottie: { splashscreen: { hide(): Promise<string> } }

await lottie.splashscreen.hide()
```

### Apache Cordova

```sh
cordova plugin add https://github.com/gizmo0506/cordova-plugin-lottie-splashscreen.git
```

Configure preferences in `config.xml` — see [Preferences](#preferences) below.

## Host app tooling (Capacitor 8)

This plugin does **not** ship AGP, Gradle, or Kotlin versions. Those live in your Capacitor app (`android/build.gradle`, `android/gradle/wrapper/gradle-wrapper.properties`, `android/variables.gradle`).

The plugin declares native **library** deps only:

| File | Pins |
| --- | --- |
| `plugin.xml` | Lottie 6.x, AndroidX |
| `Package.swift` | cordova-ios 8.x (rewritten to `capacitor-swift-pm` on `cap sync`), lottie-spm 4.6.x |

Tested against Capacitor 8 with AGP **8.13+**, Gradle **8.14+**, `compileSdk` **36**, Kotlin **2.2+**.

## Plugin development

```sh
git clone https://github.com/gizmo0506/cordova-plugin-lottie-splashscreen.git
cd cordova-plugin-lottie-splashscreen
npm install
npm run build          # compile www/*.ts → dist/
npm run lint           # ESLint only
npm run lint:all       # ESLint + ktlint + swiftlint (requires brew tools)
npm run setup          # optional: Husky git hooks
```

Native linters (optional, for `lint:all`):

```sh
brew install ktlint swiftlint
```

## Usage

Replacement for [cordova-plugin-splashscreen](https://github.com/apache/cordova-plugin-splashscreen). See the `example/` folder for a Cordova sample.

### Methods

- `lottie.splashscreen.hide()`
- `lottie.splashscreen.show(location?, remote?, width?, height?)`
- `lottie.splashscreen.on(event, callback)`
- `lottie.splashscreen.once(event)`

```js
await lottie.splashscreen.hide()
```

```ts
type LottieEvent =
  | 'lottieAnimationStart'
  | 'lottieAnimationEnd'
  | 'lottieAnimationCancel'
  | 'lottieAnimationRepeat'

lottie.splashscreen.on(event: LottieEvent, callback: (ev: Event) => void)
await lottie.splashscreen.once(event: LottieEvent)
```

## Preferences

Set in `capacitor.config.ts` under `cordova.preferences` (Capacitor) or in `config.xml` (Cordova).

| Preference | Default | Notes |
| --- | --- | --- |
| `LottieAnimationLocation` | `""` | Path or URL to Lottie JSON |
| `LottieAnimationLocationLight` / `Dark` | `""` | Theme-specific animations |
| `LottieRemoteEnabled` | `false` | Load animation from URL |
| `LottieAutoHideSplashScreen` | `false` | Hide when WebView page loads |
| `LottieHideAfterAnimationEnd` | `false` | Hide after first play |
| `LottieBackgroundColor` | `#ffffff` | Overlay background (8-digit hex OK) |
| `LottieFullScreen` | `false` | Full-screen animation |
| `LottieLoopAnimation` | `false` | Loop the animation |
| `LottieHideTimeout` | `0` | **iOS: seconds**, **Android: milliseconds** |
| `LottieFadeOutDuration` | `0` | **iOS: seconds**, **Android: milliseconds** |
| `LottieCacheDisabled` | `false` | Disable animation caching |
| `LottieImagesLocation` | derived | **Android only** — Lottie image assets folder |
| `LottieScaleType` | `FIT_CENTER` | **Android only** — `ImageView.ScaleType` |
| `LottieEnableHardwareAcceleration` | `false` | **Android only** |

See the [upstream README](https://github.com/timbru31/cordova-plugin-lottie-splashscreen) and [FAQ](FAQ.md) for more preference examples and troubleshooting.

## iOS notes

- **Capacitor 8 / SPM:** `lottie-ios` resolves via Swift Package Manager (`lottie-spm`).
- **CocoaPods fallback:** still supported for older cordova-ios via `podspec` with `nospm="true"` on the pod.
- Pure Cordova iOS: set `<preference name="SwiftVersion" value="5" />` in `config.xml`.

## Android notes

AndroidX and Kotlin are required (`cordova-android >= 10`). See [FAQ.md](FAQ.md) for common build errors.

## License

MIT — maintained by [Daya0506 / gizmo0506](https://github.com/gizmo0506).

**Based on** [timbru31/cordova-plugin-lottie-splashscreen](https://github.com/timbru31/cordova-plugin-lottie-splashscreen) by [Tim Brust](https://github.com/timbru31) (MIT).
