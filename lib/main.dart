import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'rsa_2048_key_generation_route.dart';
import 'rsa_2048_oaep_sha1_encryption_route.dart';
import 'rsa_2048_oaep_sha1_decryption_route.dart';
import 'rsa_2048_pkcs15_signature_verification_route.dart';
import 'rsa_2048_pss_signature_verification_route.dart';
import 'rsa_2048_pkcs15_decryption_route.dart';
import 'rsa_2048_pkcs15_encryption_route.dart';
import 'rsa_2048_pkcs15_signature_route.dart';
import 'rsa_2048_pss_signature_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainFormPage(title: 'RSA Playground'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainFormPage extends StatefulWidget {
  MainFormPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainFormPageState createState() => _MainFormPageState();
}

class _MainFormPageState extends State<MainFormPage> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'Bitte wählen Sie einen Algorithmus';

  BoxDecoration linkBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        width: 2.0,
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(10.0) // <--- border radius here
          ),
    );
  }

  Widget linkWidget() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: linkBoxDecoration(), // <--- BoxDecoration here
      child: Text(
        'Beschreibung des Programms: http://fluttercrypto.bplaced.net/flutter-rsa-playground',
        style: TextStyle(
          fontSize: 18,
          color: Colors.blue,
          //decoration: TextDecoration.underline,
          decoration: TextDecoration.none,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget libraryLinkWidget() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: linkBoxDecoration(), // <--- BoxDecoration here
      child: Text(
        'Verwendete Kryptographie Bibliothek:'
        '\nninja_dart Version 3.0.7'
        '\nhttps://pub.dev/packages/ninja',
        style: TextStyle(
          fontSize: 14,
          color: Colors.blue,
          decoration: TextDecoration.none,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Diese App demonstriert die asymmetrische Kryptographie auf Basis des RSA Algorithmus.',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Bitte wählen Sie einen Algorithmus\naus der Liste aus:',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  isDense: false,
                  itemHeight: 48,
                  //what you need for height
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                  decoration: InputDecoration(
                    labelText: 'wählen Sie einen Algorithmus',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                    if (dropdownValue ==
                        'RSA OAEP-SHA-1 Padding\nVerschluesselung') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Rsa2048OaepSha1EncryptionRoute()),
                      );
                    }
                    if (dropdownValue ==
                        'RSA OAEP-SHA-1 Padding\nEntschluesselung') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Rsa2048OaepSha1DecryptionRoute()),
                      );
                    }
                    if (dropdownValue ==
                        'RSA PKCS 1.5 Padding\nVerschluesselung') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Rsa2048Pkcs15EncryptionRoute()),
                      );
                    }
                    if (dropdownValue ==
                        'RSA PKCS 1.5 Padding\nEntschluesselung') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const Rsa2048Pkcs15DecryptionRoute()),
                      );
                    }
                    if (dropdownValue ==
                        'RSA PKCS 1.5 Padding\nSignatur') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Rsa2048Pkcs15SignatureRoute()),
                      );
                    }
                    ;
                    if (dropdownValue ==
                        'RSA PKCS 1.5 Padding\nVerifikation') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Rsa2048Pkcs15SignatureVerificationRoute()),
                      );
                    };
                    if (dropdownValue ==
                        'RSA PSS Padding\nSignatur') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Rsa2048PssSignatureRoute()),
                      );
                    }
                    ;
                    if (dropdownValue ==
                        'RSA PSS Padding\nVerifikation') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Rsa2048PssSignatureVerificationRoute()),
                      );
                    }
                    ;
                    if (dropdownValue ==
                        'RSA-2048 Schluessel\nGenerierung') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Rsa2048KeyGenerationRoute()),
                      );
                    };
                  },
                  items: <String>[
                    'Bitte wählen Sie einen Algorithmus',
                    'RSA OAEP-SHA-1 Padding\nVerschluesselung',
                    'RSA OAEP-SHA-1 Padding\nEntschluesselung',
                    'RSA PKCS 1.5 Padding\nVerschluesselung',
                    'RSA PKCS 1.5 Padding\nEntschluesselung',
                    'RSA PSS Padding\nSignatur',
                    'RSA PSS Padding\nVerifikation',
                    'RSA PKCS 1.5 Padding\nSignatur',
                    'RSA PKCS 1.5 Padding\nVerifikation',
                    'RSA-2048 Schluessel\nGenerierung',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        // own license
                        LicenseRegistry.addLicense(() async* {
                          yield LicenseEntryWithLineBreaks(
                            ['FlutterCrypto RSA Playgound'],
                            'Das Programm unterliegt keiner Lizenz und kann frei verwendet werden (Public Domain).',
                          );
                        });
                        // show license dialog
                        showAboutDialog(
                          context: context,
                          applicationName: widget.title,
                          applicationVersion: '1.0.0',
                          //applicationIcon: MyAppIcon(),
                          applicationIcon: Image.asset('assets/images/flutter_crypto_raw2.png', height: 86, width: 86),
                          applicationLegalese:
                              'Das Programm kann frei verwendet werden (Public Domain)',
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                  'Die App demonstriert die Verschlüsselung und Signatur mit'
                                  ' dem RSA Algorithmus mit den Paddings OAEP, PKCS 1.5 und PSS.'
                                  '\nDas RSA Schlüsselpaar kann erzeugt und lokal gespeichert werden.'),
                            ),
                          ],
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('bereitgestellt von FlutterCrypto')),
                        );
                      },
                      child: Text('über das Programm und Lizenzen'),
                    ),
                  ],
                ),

                // link to fluttercrypto.bplaced.net
                SizedBox(height: 10),
                Link(
                  target: LinkTarget.blank, // new browser, not in app
                  uri: Uri.parse('http://fluttercrypto.bplaced.net/flutter-rsa-kryptographie/'),
                  builder: (context, followLink) => GestureDetector(
                    onTap: followLink,
                    child: linkWidget(),
                  ),
                ),

                // link to pub.dev
                SizedBox(height: 10),
                Link(
                  target: LinkTarget.blank, // new browser, not in app
                  uri: Uri.parse('https://pub.dev/packages/ninja'),
                  builder: (context, followLink) => GestureDetector(
                    onTap: followLink,
                    child: libraryLinkWidget(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
