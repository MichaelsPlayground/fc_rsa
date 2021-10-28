import 'dart:typed_data';
import 'dart:convert';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/export.dart' as pc;

import 'storage.dart';

class Rsa2048OaepSha1EncryptionRoute extends StatefulWidget {
  const Rsa2048OaepSha1EncryptionRoute({Key? key}) : super(key: key);

  final String title = 'Verschlüsselung';
  final String subtitle = 'RSA 2048 OAEP SHA-1';

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<Rsa2048OaepSha1EncryptionRoute> {
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
      'RSA 2048 Verschlüsselung mit OAEP SHA-1 Padding (maximal 214 Zeichen).'
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
                  maxLength: 214,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Klartext (maximal 214 Zeichen)',
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
                            pc.RSAPublicKey publicKey =
                                CryptoUtils.rsaPublicKeyFromPem(publicKemPem)
                                    as RSAPublicKey;
                            final plaintextUint8List =
                                createUint8ListFromString(plaintext);
                            ciphertextBase64 = base64Encoding(
                                rsaOaepSha1Encrypt(publicKey, plaintextUint8List));
                          } catch (error) {
                            outputController.text = 'Fehler beim Verschlüsseln';
                            return;
                          }
                          // build output string
                          String _formdata = 'RSA-2048 OAEP SHA-1' +
                              ':' +
                              ciphertextBase64;
                          String jsonOutput = _returnJson(_formdata);
                          outputController.text = jsonOutput;
                        } else {
                          print("Formular ist nicht gültig");
                        }
                      },
                      child: Text('verschlüsseln'),
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

  Uint8List rsaOaepSha1Encrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = pc.OAEPEncoding(pc.RSAEngine())
      ..init(
          true, pc.PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt
    return _processInBlocks(encryptor, dataToEncrypt);
  }

  Uint8List rsaOaepSha1Decrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = pc.OAEPEncoding(pc.RSAEngine())
      ..init(false,
          pc.PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt
    return _processInBlocks(decryptor, cipherText);
  }

  Uint8List _processInBlocks(pc.AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);
    final output = Uint8List(numBlocks * engine.outputBlockSize);
    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;
      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);
      inputOffset += chunkSize;
    }
    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
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
