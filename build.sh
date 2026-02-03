#!/bin/sh
flutter build ios --release
rm *.apk
flutter build apk
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore gms-nova.keystore -storepass \$Abc12345 -keypass \$Abc12345 build/app/outputs/flutter-apk/app-release.apk Nova
zipalign -v 4 build/app/outputs/flutter-apk/app-release.apk vesalius-m-cvs.apk