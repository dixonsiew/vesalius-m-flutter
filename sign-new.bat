@echo off
call zipalign.exe -v 4 build\app\outputs\flutter-apk\app-release.apk unsigned.apk
call apksigner.bat sign -v --out "vesalius.m.apk" --ks gms-nova.keystore --ks-pass pass:"$Abc12345" --key-pass pass:"$Abc12345" --ks-key-alias Nova unsigned.apk
del unsigned.apk