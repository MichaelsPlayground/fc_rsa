# fc_rsa

Hinweis: Das Archiv enthält auch die Source Dateien für pointycastle und fast_rsa

rsa crypto umgestellt auf ninja-dart

ninja dart für signature + encryption 

https://pub.dev/packages/ninja

ninja: ^3.0.7

https://github.com/ninja-dart/ninja

url_launcher: ^6.0.12

https://pub.dev/packages/url_launcher

path_provider: ^2.0.5

https://pub.dev/packages/path_provider

in AndroidManifest.xml ergänzen:

    <queries>
        <!-- If your app opens https URLs -->
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="https" />
        </intent>
    </queries>


// erledigt in alle Formulare einfügen (sonst klappt IOS 11 nicht):

Expanded(
child:

vor: ElevatedButton(

und nach ), // Elevated Button noch
), einfügen

nicht eintragen:
overflow: TextOverflow.ellipsis,
ergibt: aus ...

suchen/ersetzen:

ElevatedButton(

Expanded(
child:ElevatedButton(

nicht benutzt:

fast_rsa für RSA signature PSS

https://pub.dev/packages/fast_rsa

fast_rsa: ^3.0.3

https://github.com/jerson/flutter-rsa

https://pub.dev/packages/pointycastle

pointycastle: ^3.3.5

https://pub.dev/packages/basic_utils

basic_utils: ^3.7.0

https://github.com/bcgit/pc-dart

https://github.com/Ephenodrom/Dart-Basic-Utils


Test 214 Zeichen:

##This project is a starting point for a Flutter application.##This project is a starting point for a Flu##
##This project is a starting point for a Flutter application.##This project is a starting point for a Fl##




A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
