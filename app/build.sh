echo "Building selfsigned APK and AAB files"
echo "Do not forget to update dependencies and version code before building und releasing"
read -p "Press enter to continue"
sleep 1
mkdir artifacts

echo ">>> build appbundle --no-tree-shake-icons"
flutter build appbundle --no-tree-shake-icons
mv build/app/outputs/bundle/release/app-release.aab artifacts/app-release.aab

echo ">>> build apk --no-tree-shake-icons"
flutter build apk --no-tree-shake-icons
mv build/app/outputs/flutter-apk/app-release.apk artifacts/app-release-selfsigned.apk