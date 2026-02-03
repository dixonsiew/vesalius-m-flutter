#!/bin/sh
flutter build ios --release
# rm *.apk
# flutter build apk
# zipalign -v 4 build/app/outputs/flutter-apk/app-release.apk unsigned.apk
# apksigner sign -v --out vesalius-m-ihp.apk --ks gms-nova.keystore --ks-pass pass:\$Abc12345 --key-pass pass:\$Abc12345 --ks-key-alias Nova unsigned.apk
# rm unsigned.apk
#jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore gms-nova.keystore -storepass \$Abc12345 -keypass \$Abc12345 build/app/outputs/flutter-apk/app-release.apk Nova
#zipalign -v 4 build/app/outputs/flutter-apk/app-release.apk vesalius-m.apk