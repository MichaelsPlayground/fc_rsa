import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ninja/asymmetric/rsa/rsa.dart';
import 'storage.dart';

class Rsa2048Pkcs15SignatureRoute extends StatefulWidget {
  const Rsa2048Pkcs15SignatureRoute({Key? key}) : super(key: key);

  final String title = 'Signatur';
  final String subtitle = 'RSA 2048 PKCS 1.5';

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<Rsa2048Pkcs15SignatureRoute> {
  @override
  void initState() {
    super.initState();
    descriptionController.text = txtDescription;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();

  // the following controller have a default value
  TextEditingController plaintextController = TextEditingController(
      text: 'The quick brown fox jumps over the lazy dog');
  TextEditingController publicKeyController = TextEditingController();
  TextEditingController outputController = TextEditingController();

  String txtDescription =
      'RSA 2048 Signatur mit PKCS 1.5 Padding und SHA-256 Hashing.'
      ' Der öffentliche Schlüssel ist im PEM PKCS#8 Format.';

  String _returnJson(String data) {
    var parts = data.split(':');
    var algorithm = parts[0];
    var ciphertext = parts[1];

    JsonAsymmetricEncryption jsonAsymmetricEncryption = JsonAsymmetricEncryption(
        algorithm: algorithm,
        ciphertext: ciphertext);

    String encryptionResult = jsonEncode(jsonAsymmetricEncryption);
    // make it pretty
    var object = json.decode(encryptionResult);
    var prettyEncryptionResult2 = JsonEncoder.withIndent('  ').convert(object);
    return prettyEncryptionResult2;
  }

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
                //SizedBox(height: 20),
                // form description
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enabled: false,
                  // false = disabled, true = enabled
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Beschreibung',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),
                // plaintext
                TextFormField(
                  controller: plaintextController,
                  maxLines: 3,
                  maxLength: 500,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Klartext',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte Daten eingeben';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        plaintextController.text = '';
                      },
                      child: Text('Feld löschen'),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        final data =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        plaintextController.text = data!.text!;
                      },
                      child: Text('aus Zwischenablage einfügen'),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                // public key
                TextFormField(
                  controller: publicKeyController,
                  maxLines: 4,
                  maxLength: 600,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  // enabled: false,
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        final data =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        publicKeyController.text = data!.text!;
                      },
                      child: Text('Schlüssel aus Zwischenablage einfügen'),
                    )
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        publicKeyController.text = '';
                      },
                      child: Text('Feld löschen'),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
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
                  ],
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        // reset() setzt alle Felder wieder auf den Initalwert zurück.
                        _formKey.currentState!.reset();
                      },
                      child: Text('Formulardaten löschen'),
                    ),
                    SizedBox(width: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        // Wenn alle Validatoren der Felder des Formulars gültig sind.
                        if (_formKey.currentState!.validate()) {
                          String plaintext = plaintextController.text;
                          String publicKemPem = publicKeyController.text;

                          String ciphertextBase64 = '';
                          try {

                          } catch (error) {
                            outputController.text = 'Fehler beim Verschlüsseln';
                            return;
                          }
                          // build output string
                          String _formdata = 'RSA-2048 PKCS 1.5' +
                              ':' +
                              ciphertextBase64;
                          String jsonOutput = _returnJson(_formdata);
                          outputController.text = jsonOutput;
                        } else {
                          print("Formular ist nicht gültig");
                        }
                      },
                      child: Text('signieren'),
                    )
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: outputController,
                  maxLines: 15,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Ausgabe',
                    hintText: 'Ausgabe',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        outputController.text = '';
                      },
                      child: Text('Feld löschen'),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        final data = ClipboardData(text: outputController.text);
                        await Clipboard.setData(data);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Daten in die Zwischenablage kopiert'),
                          ),
                        );
                      },
                      child: Text('in Zwischenablage kopieren'),
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
}

class JsonAsymmetricEncryption {
  JsonAsymmetricEncryption({
    required this.algorithm,
    required this.ciphertext,
  });

  final String algorithm;
  final String ciphertext;

  Map toJson() => {
        'algorithm': algorithm,
        'ciphertext': ciphertext,
      };
}
