# fc_rsa

https://pub.dev/packages/pointycastle

pointycastle: ^3.3.5

https://pub.dev/packages/basic_utils

basic_utils: ^3.7.0

https://github.com/bcgit/pc-dart

https://github.com/Ephenodrom/Dart-Basic-Utils

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


Test 214 Zeichen:

##This project is a starting point for a Flutter application.##This project is a starting point for a Flu##
##This project is a starting point for a Flutter application.##This project is a starting point for a Fl##


{
"algorithm": "RSA-2048 OAEP SHA-1",
"ciphertext": "LBScJvawBPpJFrfmczfVDj6Subb6moJil0RZVY3mj3DqtgK+tUtfKEc0i7Z/t9f27D8fDymQgeYB6NBfR7u9/mbQyFsSL/bMJ18XkbzHmKuLVPIXJosc+GA26Sf5pP1Ovrhie5rM4AIyS9dbLnHFIpnLFGJIPiIg+c/1KmYE0gqz90TnErLMnFhlmb/++OQ1Fd1wMCjpCfZvAOnMJoVVIRjp7REcFm1B/YEeG3FhttjTpa7W6Df3vqaI3brlPJ4cFGFlJKQLnel8lr+aj9+WMfqb2Ezhco5nFaCpqCAl/BkwBBGgOTPCXRIBMPcZ1DrkewM1Muz6rDcdyp06MXJUkQ=="
}

{
"algorithm": "RSA-2048 PKCS 1.5",
"ciphertext": "ZIeDA6lqGjRHr6sopONTZzxDVNFAGunsIzhK/GfcGZIHUMcwFkvRiYGTocBKY3xurQ/OALHnfJIR4NyvwXNEQzBjhrIjX10sQpMTCGvxnXA57tlfrTdj/Mky3w0qHJ2DL8eXkWnHFsZLs/euabsloIhyhjx5xJ0dKN5ofm5QdHd4tiYz+1G062AvAq/raghV53GJOyxM5YFjWkNXJO1MiV1KMJRK4im77CnpLRCLL/Tbg4soZk6lflHTPfdeB8/5C/S+5f3mgloDyLXsp+NXBDOOFqsg7A1kz2+kFXjZ4E4tw76wEezKq84+u6kVcWBv8/UkZVdTUH7iIQIEPqsE0w=="
}


A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.