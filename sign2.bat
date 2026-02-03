@echo off
call jarsigner.exe -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore gms-nova.keystore -storepass "$Abc12345" -keypass "$Abc12345" build\app\outputs\bundle\release\app-release.aab Nova