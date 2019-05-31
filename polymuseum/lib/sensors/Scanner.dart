import 'package:barcode_scan/barcode_scan.dart';


///Wrapper permettant d'être indépendant du plugin lisant les QRCode / code-barres
class Scanner {
  static Scanner _instance;
  static Scanner get instance => _instance;

  static setInstance(Scanner obj) {
    _instance = obj;
  }

  Future<String> scan() {
    return BarcodeScanner.scan();
  }

  String cameraAccessDenied() {
    return BarcodeScanner.CameraAccessDenied;
  }
}
