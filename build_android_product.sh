# cd android
flutter clean
flutter pub get
flutter build appbundle --dart-define=DART_DEFINES_BASE_URL=https://prod.spa.dhysolutions.net/api
fastlane build_notify_ABB --env beta
fastlane deploy --env beta
fastlane build_notify_CHPlay --env beta

