import 'package:polymuseum/DBHelper.dart';

class MockedDBHelper extends DBHelper {
  @override
  updateSettings() async {}

  Map<String, List<Map<String, dynamic>>> _description;

  MockedDBHelper(
      {List<Map<String, dynamic>> visits,
      List<Map<String, dynamic>> exhibitions,
      List<Map<String, dynamic>> objects,
      List<Map<String, dynamic>> sprints}) {
    _description = {
      "visits": visits,
      "objects": objects,
      "exhibitions": exhibitions,
      "sprints": sprints
    };
  }

  @override
  Future<Map<String, dynamic>> getDocumentInCollectionById(
      String collectionName, int id) {
    List<dynamic> coll = _description[collectionName];
    List<dynamic> lst = coll.where((o) => o["id"] == id).toList();
    if (lst.isEmpty) return null;
    return Future.value(lst.first);
  }

  @override
  Future<Map<String, dynamic>> getExhibitionByUUID(String uuid) {
    var collections = _description["exhibitions"]
        .where((exhibition) => exhibition["UUID"] == uuid);
    if (collections.isEmpty) return null;
    return Future.value(collections.first);
  }
}
