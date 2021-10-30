import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ninja/asymmetric/rsa/rsa.dart';
import 'storage.dart';

class Rsa2048Pkcs15SignatureVerificationRoute extends StatefulWidget {
  const Rsa2048Pkcs15SignatureVerificationRoute({Key? key}) : super(key: key);

  final String title = 'Verifikation';
  final String subtitle = 'RSA 2048 PKCS 1.5';

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<Rsa2048Pkcs15SignatureVerificationRoute> {
  @override
  void initState() {
    super.initState();
    descriptionController.text = txtDescription;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ciphertextController = TextEditingController();
  TextEditingController publicKeyController = TextEditingController();
  TextEditingController outputController = TextEditingController();
  TextEditingController signatureVerificationController =
      TextEditingController();

  String txtDescription =
      'RSA 2048 Verifikation einer Unterschrift mit RSA PKCS 1.5 Padding.'
      ' Der öffentliche Schlüssel ist im PEM PKCS#8 Format.';

  Future<bool> _fileExistsPublicKey() async {
    bool ergebnis = false;
    await Storage().filePublicKeyExists().then((bool value) {
      setState(() {
        if (value == true) {
          publicKeyController.text = 'Datei existiert ';
        } else {
          publicKeyController.text = 'Datei existiert NICHT';
        }
        ergebnis = value;
      });
    });
    return ergebnis;
  }

  Future<void> _readDataPublicKey() async {
    Storage().readDataPublicKey().then((String value) {
      setState(() {
        publicKeyController.text = value;
      });
    });
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
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // form description
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enabled: false,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Beschreibung',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),
                // signatur
                TextFormField(
                  controller: ciphertextController,
                  maxLines: 15,
                  maxLength: 700,
                  decoration: InputDecoration(
                    labelText: 'Signatur',
                    hintText: 'kopieren Sie den signierten Text in dieses Feld',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          ciphertextController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          ciphertextController.text = data!.text!;
                        },
                        child: Text('aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                // public key
                TextFormField(
                  controller: publicKeyController,
                  maxLines: 4,
                  maxLength: 500,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  //enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Öffentlicher Schlüssel',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte den Schlüssel laden oder erzeugen';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          publicKeyController.text = data!.text!;
                        },
                        child: Text('Schlüssel aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          publicKeyController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          bool pubKeyFileExists =
                              await _fileExistsPublicKey() as bool;
                          if (pubKeyFileExists) {
                            await _readDataPublicKey();
                          }
                        },
                        child: Text('lokal laden'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          //_formKey.currentState!.reset();
                          ciphertextController.text = '';
                          publicKeyController.text = '';
                        },
                        child: Text('Formulardaten löschen'),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          // Wenn alle Validatoren der Felder des Formulars gültig sind.
                          if (_formKey.currentState!.validate()) {
                            String jsonAsymmetricEncryption =
                                ciphertextController.text;
                            String publicKeyPem = publicKeyController.text;

                            String algorithm = '';
                            String plaintextBase64 = '';
                            String signatureBase64 = '';
                            try {
                              final parsedJson =
                                  json.decode(jsonAsymmetricEncryption);
                              algorithm = parsedJson['algorithm'];
                              plaintextBase64 = parsedJson['plaintext'];
                              signatureBase64 = parsedJson['signature'];
                            } on FormatException catch (e) {
                              outputController.text =
                                  'Fehler: Die Eingabe sieht nicht nach einem Json-Datensatz aus.';
                              return;
                            } on NoSuchMethodError catch (e) {
                              outputController.text =
                                  'Fehler: Die Eingabe ist ungültig.';
                              return;
                            }
                            if (algorithm != 'RSA-2048 PKCS 1.5') {
                              outputController.text =
                                  'Fehler: es handelt sich nicht um einen Datensatz, der mit RSA-2048 PKCS 1.5 signiert worden ist.';
                              return;
                            }

                            String verificationtext = '';
                            try {
                              final publicKey =
                                  RSAPublicKey.fromPEM(publicKeyPem);
                              final signature = base64Decoding(signatureBase64);
                              final plaintext = base64Decoding(plaintextBase64);
                              final verified = publicKey.verifySsaPkcs1v15(
                                  signature, plaintext);
                              if (verified == true) {
                                verificationtext = 'Die Signatur ist RICHTIG';
                              } else {
                                verificationtext = 'Die Signatur ist FALSCH';
                              }
                            } catch (error) {
                              signatureVerificationController.text =
                                  'Die Signatur ist FALSCH';
                              return;
                            }
                            signatureVerificationController.text =
                                verificationtext;
                            // cleartext output
                            outputController.text = new String.fromCharCodes(
                                base64Decoding(plaintextBase64));
                          } else {
                            print("Formular ist nicht gültig");
                          }
                        },
                        child: Text('Signatur prüfen'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                TextFormField(
                  controller: signatureVerificationController,
                  maxLines: 1,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Gültigkeit der Signatur',
                    hintText: 'Gültigkeit der Signatur',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),
                TextFormField(
                  controller: outputController,
                  maxLines: 3,
                  maxLength: 100,
                  decoration: InputDecoration(
                    labelText: 'Klartext',
                    hintText: 'hier steht der KLartext',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          outputController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              ClipboardData(text: outputController.text);
                          await Clipboard.setData(data);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('in die Zwischenablage kopiert'),
                            ),
                          );
                        },
                        child: Text('in Zwischenablage kopieren'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Uint8List base64Decoding(String input) {
    return base64.decode(input);
  }
}
