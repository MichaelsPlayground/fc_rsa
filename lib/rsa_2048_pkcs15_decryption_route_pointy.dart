import 'dart:typed_data';
import 'dart:convert';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/export.dart' as pc;

import 'storage.dart';

class Rsa2048Pkcs15DecryptionRoute extends StatefulWidget {
  const Rsa2048Pkcs15DecryptionRoute({Key? key}) : super(key: key);

  final String title = 'Entschlüsselung';
  final String subtitle = 'RSA 2048 PKCS 1.5';

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<Rsa2048Pkcs15DecryptionRoute> {
  @override
  void initState() {
    super.initState();
    descriptionController.text = txtDescription;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ciphertextController = TextEditingController();
  TextEditingController privateKeyController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController outputController = TextEditingController();

  String txtDescription = 'RSA 2048 Entschlüsselung mit PKCS 1.5 Padding (maximal 245 Zeichen).'
      ' Der private Schlüssel ist im PEM PKCS#8 Format.';

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
                // ciphertext
                TextFormField(
                  controller: ciphertextController,
                  maxLines: 15,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Ciphertext',
                    hintText:
                        'kopieren Sie den verschlüsselten Text in dieses Feld',
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
                        ciphertextController.text = '';
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
                        ciphertextController.text = data!.text!;
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
                  //enabled: false,
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
                        //_formKey.currentState!.reset();
                        ciphertextController.text = '';
                        privateKeyController.text = '';
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
                          String jsonAsymmetricEncryption = ciphertextController.text;
                          String privateKeyPem = privateKeyController.text;

                          String algorithm = '';
                          String ciphertextBase64 = '';
                          try {
                            final parsedJson = json.decode(jsonAsymmetricEncryption);
                            algorithm = parsedJson['algorithm'];
                            ciphertextBase64 = parsedJson['ciphertext'];
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
                                'Fehler: es handelt sich nicht um einen Datensatz, der mit RSA-2048 PKCS 1.5 verschlüsselt worden ist.';
                            return;
                          }

                          String decryptedtext = '';
                          try {
                            pc.RSAPrivateKey privateKey =
                            CryptoUtils.rsaPrivateKeyFromPem(privateKeyPem)
                            as pc.RSAPrivateKey;
                            decryptedtext = new String.fromCharCodes(rsaPkcs15Decrypt(privateKey, base64Decoding(ciphertextBase64)));
                          } catch (error) {
                            outputController.text = 'Fehler beim Entschlüsseln';
                            return;
                          }
                          outputController.text = decryptedtext;
                        } else {
                          print("Formular ist nicht gültig");
                        }
                      },
                      child: Text('entschlüsseln'),
                    )
                  ],
                ),

                SizedBox(height: 20),
                TextFormField(
                  controller: outputController,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Klartext',
                    hintText: 'hier steht der entschlüsselte Text',
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
                            content:
                                const Text('in die Zwischenablage kopiert'),
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

  Uint8List rsaPkcs15Encrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = pc.PKCS1Encoding(pc.RSAEngine())
      ..init(
          true, pc.PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt
    return _processInBlocks(encryptor, dataToEncrypt);
  }

  Uint8List rsaPkcs15Decrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = pc.PKCS1Encoding(pc.RSAEngine())
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
