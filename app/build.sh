echo "Building selfsigned APK and AAB files"
echo ">>> pub get"
flutter pub get
echo ">>> pub upgrade"
flutter pub upgrade
echo " pub outdated"
flutter pub outdated
echo ""
read -p "Press enter to continue..."
sleep 1
mkdir artifacts

echo ">>> build appbundle --no-tree-shake-icons"
flutter build appbundle --no-tree-shake-icons
mv build/app/outputs/bundle/release/app-release.aab artifacts/app-release.aab

echo ">>> build apk --no-tree-shake-icons"
flutter build apk --no-tree-shake-icons
mv build/app/outputs/flutter-apk/app-release.apk artifacts/app-release-selfsigned.apk