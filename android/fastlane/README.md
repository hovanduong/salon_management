fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android test

```sh
[bundle exec] fastlane android test
```

Runs all the tests

### android beta

```sh
[bundle exec] fastlane android beta
```

Submit a new Beta Build to Crashlytics Beta

### android build_apk

```sh
[bundle exec] fastlane android build_apk
```

Build File APK

### android build_aab

```sh
[bundle exec] fastlane android build_aab
```

Build File AAB

### android build_distribution

```sh
[bundle exec] fastlane android build_distribution
```

Submit File APK To App Distribution

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Deploy a new version to the Internal Google Play

### android build_notify_APK

```sh
[bundle exec] fastlane android build_notify_APK
```

Build File APK and send Discord notification

### android build_notify_ABB

```sh
[bundle exec] fastlane android build_notify_ABB
```

Build File ABB and send Discord notification

### android build_notify_distribution

```sh
[bundle exec] fastlane android build_notify_distribution
```

Notification Submit App To Distribution

### android build_notify_CHPlay

```sh
[bundle exec] fastlane android build_notify_CHPlay
```

Notification Submit App To Ch Play

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
