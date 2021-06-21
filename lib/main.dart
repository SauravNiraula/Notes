import 'package:flutter/material.dart';
import 'Notes.dart';
import 'widgets/list_storage.dart';


class NotesApp extends StatelessWidget {

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotesApp',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.article),
              ),
              Text('Notes')
            ]
          ),
        ),
        body: Notes(storage: NotesStorage()),
      ),
      debugShowCheckedModeBanner: false,
    );
  } 
}


void main() {
  runApp(NotesApp());
}