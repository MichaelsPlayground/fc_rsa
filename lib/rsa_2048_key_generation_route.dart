import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ninja/asymmetric/rsa/rsa.dart';
import 'storage.dart';

class Rsa2048KeyGenerationRoute extends StatefulWidget {
  const Rsa2048KeyGenerationRoute({Key? key}) : super(key: key);

  final String title = 'Schlüsselerzeugung';
  final String subtitle = 'RSA 2048';

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<Rsa2048KeyGenerationRoute> {
  @override
  void initState() {
    super.initState();
    descriptionController.text = txtDescription;
    setState(() {
      state = '';
      statePriKey = '';
      statePubKey = '';
    });
  }

  final _formKey = GlobalKey<FormState>();
  String state = '';
  String statePriKey = '';
  String statePubKey = '';
  TextEditingController privateKeyController = TextEditingController();
  TextEditingController publicKeyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String privateKeyAfterGeneration = '';
  String publicKeyAfterGeneration = '';

  String txtDescription =
      'Erzeugung eines RSA Schlüsselpaares mit 2048 Bit Länge.'
      ' Das Schlüsselpaar kann lokal gespeichert werden.';

  Future<bool> _fileExistsPrivateKey() async {
    bool ergebnis = false;
    await Storage().filePrivateKeyExists().then((bool value) {
      setState(() {
        state = '';
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

  Future<bool> _fileExistsPublicKey() async {
    bool ergebnis = false;
    await Storage().filePublicKeyExists().then((bool value) {
      setState(() {
        state = '';
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

  Future<File> _writeDataPrivateKey() async {
    setState(() {
      statePriKey = privateKeyAfterGeneration;
    });
    return Storage().writeDataPrivateKey(statePriKey);
  }

  Future<File> _writeDataPublicKey() async {
    setState(() {
      statePubKey = publicKeyAfterGeneration;
    });
    return Storage().writeDataPublicKey(statePubKey);
  }

  Future<void> _readDataPrivateKey() async {
    Storage().readDataPrivateKey().then((String value) {
      setState(() {
        statePriKey = value;
        privateKeyAfterGeneration = '';
        privateKeyController.text = value;
      });
    });
  }

  Future<void> _readDataPublicKey() async {
    Storage().readDataPublicKey().then((String value) {
      setState(() {
        statePubKey = value;
        publicKeyAfterGeneration = '';
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
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Beschreibung',
                    border: OutlineInputBorder(),
                  ),
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
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final data =
                                ClipboardData(text: publicKeyController.text);
                            await Clipboard.setData(data);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 1),
                                content: const Text(
                                    'Öffentlichen Schlüssel in die Zwischenablage kopiert'),
                              ),
                            );
                          } else {
                            print("Formular ist nicht gültig");
                          }
                        },
                        child: Text('Schlüssel in die Zwischenablage kopieren'),
                      ),
                    )
                  ],
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
                          bool priKeyFileExists =
                              await _fileExistsPrivateKey() as bool;
                          bool pubKeyFileExists =
                              await _fileExistsPublicKey() as bool;
                          if (priKeyFileExists && pubKeyFileExists) {
                            await _readDataPrivateKey();
                            await _readDataPublicKey();
                          }
                        },
                        child: Text('lokal laden'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          // generate a RSA key pair with 2048 bit strength
                          final privateKey = RSAPrivateKey.generate(2048);
                          String privateKeyPem =
                              privateKey.toPem(toPkcs1: false);
                          String publicKeyPem =
                              privateKey.toPublicKey.toPem(toPkcs1: false);
                          privateKeyAfterGeneration = privateKeyPem;
                          publicKeyAfterGeneration = publicKeyPem;
                          privateKeyController.text = privateKeyPem;
                          publicKeyController.text = publicKeyPem;
                        },
                        child: Text('erzeugen'),
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
                          privateKeyAfterGeneration = '';
                          publicKeyAfterGeneration = '';
                          privateKeyController.text = '';
                          publicKeyController.text = '';
                          //_formKey.currentState!.reset();
                        },
                        child: Text('Formulardaten löschen'),
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
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          if (privateKeyAfterGeneration != '' &&
                              publicKeyAfterGeneration != '') {
                            // stores data from privateKeyAfterGeneration and
                            // publicKeyAfterGeneration
                            await _writeDataPrivateKey();
                            await _writeDataPublicKey();
                            await ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Text(
                                    'Privaten und Öffentlichen Schlüssel lokal gespeichert'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                content: Text(
                                    'Keinen Schlüssel lokal gespeichert, bitte erst neu erzeugen.'),
                              ),
                            );
                          }
                        },
                        child: Text('Schlüssel lokal speichern'),
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
}
