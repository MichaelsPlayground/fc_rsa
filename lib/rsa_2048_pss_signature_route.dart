import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ninja/asymmetric/rsa/rsa.dart';


import 'storage.dart';

class Rsa2048PssSignatureRoute extends StatefulWidget {
  const Rsa2048PssSignatureRoute({Key? key}) : super(key: key);

  final String title = 'Signatur';
  final String subtitle = 'RSA 2048 PSS';

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<Rsa2048PssSignatureRoute> {
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
  TextEditingController privateKeyController = TextEditingController();
  TextEditingController outputController = TextEditingController();

  String txtDescription =
      'RSA 2048 Signatur mit PSS Padding und SHA-256 Hashing.'
      ' Der öffentliche Schlüssel ist im PEM PKCS#8 Format.';

  String _returnJson(String data) {
    var parts = data.split(':');
    var algorithm = parts[0];
    var plaintext = parts[1];
    var ciphertext = parts[2];

    // todo change ciphertext to signature

    JsonAsymmetricSignature jsonAsymmetricSignature = JsonAsymmetricSignature(
        algorithm: algorithm,
        plaintext: plaintext,
        ciphertext: ciphertext);

    String encryptionResult = jsonEncode(jsonAsymmetricSignature);
    // make it pretty
    var object = json.decode(encryptionResult);
    var prettyEncryptionResult2 = JsonEncoder.withIndent('  ').convert(object);
    return prettyEncryptionResult2;
  }

  Future<bool> _fileExistsPrivateKey() async {
    bool ergebnis = false;
    await Storage().filePrivateKeyExists().then((bool value) {
      setState(() {
        if (value == true) {
          privateKeyController.text = 'Datei existiert ';
        } else {
          privateKeyController.text = 'Datei existiert NICHT';
        }
        ergebnis = value;
      });
    });
    return ergebnis;
  }

  Future<void> _readDataPrivateKey() async {
    Storage().readDataPrivateKey().then((String value) {
      setState(() {
        privateKeyController.text = value;
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
                  maxLength: 100,
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
                // private key
                TextFormField(
                  controller: privateKeyController,
                  maxLines: 4,
                  maxLength: 2000,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  // enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Privater Schlüssel',
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
                        privateKeyController.text = data!.text!;
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
                        privateKeyController.text = '';
                      },
                      child: Text('Feld löschen'),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        bool priKeyFileExists =
                            await _fileExistsPrivateKey() as bool;
                        if (priKeyFileExists) {
                          await _readDataPrivateKey();
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
                        //_formKey.currentState!.reset();
                        plaintextController.text = '';
                        privateKeyController.text = '';
                        outputController.text = '';
                      },
                      child: Text('Formulardaten löschen'),
                    ),
                    SizedBox(width: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        // Wenn alle Validatoren der Felder des Formulars gültig sind.
                        if (_formKey.currentState!.validate()) {
                          String plaintext = plaintextController.text;
                          String privateKeyPem = privateKeyController.text;

                          String signatureBase64 = '';
                          try {

                            final privateKey = RSAPrivateKey.fromPEM(privateKeyPem);
                            final signature = privateKey.signPssToBase64(plaintext);
                            signatureBase64 = signature;
                          } catch (error) {
                            outputController.text = 'Fehler beim Signieren';
                            return;
                          }
                          // build output string
                          String _formdata = 'RSA-2048 PSS' +
                              ':' +
                              base64Encoding(createUint8ListFromString(plaintext)) +
                              ':' +
                              signatureBase64;
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
                  maxLength: 700,
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

  Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  String base64Encoding(Uint8List input) {
    return base64.encode(input);
  }

  Uint8List base64Decoding(String input) {
    return base64.decode(input);
  }
}

class JsonAsymmetricSignature {
  JsonAsymmetricSignature({
    required this.algorithm,
    required this.plaintext,
    required this.ciphertext,
  });

  final String algorithm;
  final String plaintext;
  final String ciphertext;

  Map toJson() => {
        'algorithm': algorithm,
        'plaintext': plaintext,
        'ciphertext': ciphertext,
      };
}
