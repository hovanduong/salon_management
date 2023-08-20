flutter clean
flutter pub get
echo "START BUILD APK FILE ..."
flutter build apk --dart-define=DART_DEFINES_BASE_URL=https://customer-api.easysalon.vn/api/v2/
# flutter build apk --split-per-abi
# flutter build ipa --export-options-plist=ios/exportOptions.plist
