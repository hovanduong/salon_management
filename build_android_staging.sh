flutter clean
flutter pub get
cd android
flutter build apk --dart-define=DART_DEFINES_BASE_URL=https://spa-api.dhysolutions.net/api
fastlane distribution -env beta
