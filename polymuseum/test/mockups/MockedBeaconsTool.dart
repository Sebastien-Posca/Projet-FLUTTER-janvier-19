import 'package:polymuseum/sensors/BeaconsTool.dart';


class MockedBeaconsTool extends BeaconsTool {


  bool is_position_ok = false;

  @override
  Future<bool> checkPosition(int index) async {
    return is_position_ok;
  }

  @override
  initBeacon() {
    
  }

  @override
  void dispose() {

  }

}