// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/Notes.dart';
import 'package:notes_app/widgets/list_storage.dart';


void main() {
  testWidgets('test the notes Widget',(WidgetTester tester) async{
    final notes = MaterialApp(
      home: Notes(storage: NotesStorage())
      );
    tester.pumpWidget(notes);
    // int length = notes.
    // expect(notes.notesData
  });
}