cd android
flutter clean
flutter pub get
echo "START BUILD AAB FILE ..."
# fastlane increment_vc 
flutter build appbundle --dart-define=DART_DEFINES_BASE_URL=https://customer-api.easysalon.vn/api/v2/
# fastlane deploy
