import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

bool _isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

/// Wrapper permettant d'être indépendant du plugin de NFC choisi

class NFCScanner {
  static NFCScanner _instance;
  static NFCScanner get instance => _instance;

  static setInstance(NFCScanner obj) {
    _instance = obj;
  }

  Future<String> read() async {
    String result = await FlutterNfcReader.read;
    var id = "";
    for (var i = 0; i < result.length; i++) {
      if (_isNumeric(result[i])) id += result[i];
    }
    return id;
  }

  Future<bool> stop() async {
    return await FlutterNfcReader.stop;
  }
}
