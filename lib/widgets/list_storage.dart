import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

// final path = '.';

class NotesStorage {

  // NotesStorage() {
    // _localPath.then((path) {
      // File("$path/notes.json").exists().then((exists) {
      //   if (!exists) {
      //     setJson('{"notes": [], "completedNotes": []}');
      //   }
      // });
    // });
  // }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.json');
  }

  Future<String> get getJson async {
    File file = await _localFile;
    String jsonStr = '{"notes": [], "completedNotes": []}';
    bool exists = await file.exists();
    if (exists) jsonStr = await file.readAsString();
    return jsonStr;
  }

  Future<void> setList(List<dynamic> notes, bool completed ) async {
    Map<String, dynamic> data = jsonDecode(await getJson);
    if (!completed) data['notes'] = notes;
    else data['completedNotes'] = notes;
    setJson(jsonEncode(data));
  }

  Future<void> setJson(String jsonStr) async {
    File file = await _localFile;
    file.writeAsString(jsonStr);
  } 
}