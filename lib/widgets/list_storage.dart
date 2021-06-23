import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

// final path = '.';

class NotesStorage {

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

  void setList(List<dynamic> notes, bool completed ) async {
    Map<String, dynamic> data = jsonDecode(await getJson);
    if (!completed) data['notes'] = notes;
    else data['completedNotes'] = List<String>.from(notes);
    setJson(jsonEncode(data));
  }

  void setJson(String jsonStr) async {
    File file = await _localFile;
    file.writeAsString(jsonStr);
  } 
}