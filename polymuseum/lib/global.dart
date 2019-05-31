Global instance;

setInstance(Global inst) {
  instance = inst;
}

abstract class Global {
  int get seed;
  List<Map<String, dynamic>> get checkListObjects;
  int get checkListObjectsCount;

  addScannedObject(Map<String, dynamic> obj);

  List<Map<String, dynamic>> getScannedObjects({List<String> ids});

  addCheckListObject(Map<String, dynamic> obj);

  removeCheckListObject(Map<String, dynamic> obj);

  initCheckList();

  clear();
}

class DefaultGlobal extends Global {
  DefaultGlobal();

  int _seed = -1;
  Map<String, Map<String, dynamic>> _scannedObjects = new Map();
  Map<String, Map<String, dynamic>> _checkListObjects = new Map();

  @override
  get seed => _seed;
  @override
  get checkListObjects => _checkListObjects.values.toList();
  @override
  get checkListObjectsCount => _checkListObjects.length;

  @override
  addScannedObject(Map<String, dynamic> obj) {
    _scannedObjects[obj["id"].toString()] = obj;

    _checkListObjects.remove(obj["id"].toString());
    if (_checkListObjects.isEmpty) _seed = -1;
  }

  @override
  List<Map<String, dynamic>> getScannedObjects({List<String> ids}) {
    if (ids == null) return _scannedObjects.values.toList();

    return _scannedObjects.values.where((obj) {
      return ids.contains(obj["id"].toString());
    }).toList();
  }

  @override
  addCheckListObject(Map<String, dynamic> obj) {
    _checkListObjects[obj["id"].toString()] = obj;
  }

  @override
  removeCheckListObject(Map<String, dynamic> obj) {
    return _checkListObjects.remove(obj["id"]);
  }

  @override
  initCheckList() {
    _seed = 0;
    _checkListObjects.clear();
  }

  @override
  clear() {
    _scannedObjects.clear();
    _checkListObjects.clear();
  }
}

enum Permission {
  // Microphone
  RecordAudio,

  // Camera
  Camera,

  // Read External Storage (Android)
  ReadExternalStorage,

  // Write External Storage (Android)
  WriteExternalStorage,

  // Access Coarse Location (Android) / When In Use iOS
  AccessCoarseLocation,

  // Access Fine Location (Android) / When In Use iOS
  AccessFineLocation,

  // Access Fine Location (Android) / When In Use iOS
  WhenInUseLocation,

  // Access Fine Location (Android) / Always Location iOS
  AlwaysLocation,

  // Write contacts (Android) / Contacts iOS
  WriteContacts,

  // Read contacts (Android) / Contacts iOS
  ReadContacts,
}
