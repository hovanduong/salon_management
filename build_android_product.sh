flutter clean
flutter pub get
cd android
flutter build appbundle --dart-define=DART_DEFINES_BASE_URL=https://prod.spa.dhysolutions.net/api
fastlane deploy -env beta
