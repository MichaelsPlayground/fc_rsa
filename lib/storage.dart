import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {

  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localPrivateKeyFile async {
    final path = await localPath;
    return File('$path/rsa2048prikey.txt');
  }

  Future<File> get localPublicKeyFile async {
    final path = await localPath;
    return File('$path/rsa2048pubkey.txt');
  }

  Future<String> readDataPrivateKey() async {
    try {
      final file = await localPrivateKeyFile;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> readDataPublicKey() async {
    try {
      final file = await localPublicKeyFile;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeDataPrivateKey(String data) async {
    final file = await localPrivateKeyFile;
    return file.writeAsString("$data");
  }

  Future<File> writeDataPublicKey(String data) async {
    final file = await localPublicKeyFile;
    return file.writeAsString("$data");
  }
/*
  Future<int> deleteFile() async {
    try {
      final file = await localFile;
      await file.delete();
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<void> deleteFile2() async {
    try {
      final file = await localFile;
      await file.delete();
    } catch (e) {
      //return 0;
    }
  }

  Future<String> deleteFile3() async {
    try {
      final file = await localFile;
      await file.delete();
      return '1';
    } catch (e) {
      return '0';
    }
  }
*/
  Future<bool> filePrivateKeyExists() async {
    try {
      final file = await localPrivateKeyFile;
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  Future<bool> filePublicKeyExists() async {
    try {
      final file = await localPublicKeyFile;
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}

