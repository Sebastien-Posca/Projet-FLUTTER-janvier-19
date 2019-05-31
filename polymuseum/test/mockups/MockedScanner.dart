import 'package:polymuseum/sensors/Scanner.dart';

class MockedScanner extends Scanner {

  static create(){
    return MockedScanner();
  }

  String qrcode;

  //OVERRIDES

  @override
  Future<String> scan() async {
    return qrcode;
  }

}