// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/Notes.dart';
import 'package:notes_app/widgets/list_storage.dart';


void main() {
  test('test',() async{
    final notes = Notes(storage: NotesStorage());
    // expect(notes.notesData
  });
}