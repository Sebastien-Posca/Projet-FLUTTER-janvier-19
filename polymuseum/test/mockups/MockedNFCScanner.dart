import 'package:polymuseum/sensors/NFCScanner.dart';

class MockedNFCScanner extends NFCScanner {
  List<String> _values_queue = List();
  Duration _min_delay = Duration(seconds: 1);

  enqueueValue(String value) {
    _values_queue.insert(0, value);
  }

  setMinimumDelay(Duration duration) {
    _min_delay = duration;
  }

  @override
  Future<String> read() async {
    return Future.delayed(_min_delay, () => _values_queue.removeLast());
  }
}
