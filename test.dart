import 'dart:convert';
import "package:notes_app/widgets/list_storage.dart";


class EachNote {
  EachNote(this.name, this.id);
  final String name;
  final String id;
}

void main() {
  NotesStorage storage = NotesStorage(); 
  List<EachNote> notes = [EachNote('adfadsfasdf', 'adsf'), EachNote('aaaa', 'aaa')];
  // storage.setList(notes.map((each) => [each.name, each.id]).toList(), false);
  // storage.getJson.then((value) => print(value));
  storage.getJson.then((value) {
    Map<String, dynamic> notesData = jsonDecode(value);
      // if (notesData['notes'].length > 0) update(notesData['notes'], false);
    });
  // notes.setList([['adfadsf', 'adfadsf']], false);
}

void update(List<dynamic> notes) {
  // return notes
}
