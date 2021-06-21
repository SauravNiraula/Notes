import 'dart:convert';
import 'widgets/list_storage.dart';
import 'package:flutter/material.dart';


class EachNote {
  EachNote(this.name, this.id);
  final String name;
  final String id;
}

class Notes extends StatefulWidget {

  Notes({Key? key, required this.storage}): super(key: key);

  final NotesStorage storage;   
  final String hintText = "Add Notes here";

  @override 
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {


  String inputText = '';
  bool textAvailable = false;
  bool selected = false;
  List<EachNote> notes = [];
  List<String> completedNotes = [];
  Map<String, dynamic> notesData = {};

  @override
  void initState() {
    super.initState();

    widget.storage.getJson.then((value) {
        notesData = jsonDecode(value);
        if (notesData['notes'].length > 0) update(notesData['notes'], false);
        if (notesData['completedNotes'].length > 0) update(notesData['completedNotes'], true);
    });
  }

  void update(List<dynamic> notess, bool completed) {
    completed? setState(() => completedNotes = List<String>.from(notess)) : setState(() => notes = notess.map((each) => EachNote(each[0], each[1])).toList());
  }

  TextStyle getStyle(EachNote each) {
    return TextStyle(fontSize: 20, decoration: completedNotes.contains(each.id)? TextDecoration.lineThrough : null);
  }

  Color getListColor(EachNote each) {
    return completedNotes.contains(each.id)? Colors.grey : Colors.blueGrey;
  }

  Color? getColor() {
    return selected? textAvailable? Colors.green[900] : Colors.red[900] : Colors.blueGrey;
  }

  IconData getIcon() {
    return selected? textAvailable? Icons.check : Icons.delete : Icons.note_add;
  }

  void onTextChange(String str) {
    setState(() {
      inputText = str;
      if (str.isNotEmpty) {
        setState(() => textAvailable=true);
      }else {
        setState(() {
          textAvailable = false;
        });
      }
    });
  }

  void floatingButtonClicked() {

    if (selected) {
      if (textAvailable) {
        setState(() {
          notes.insert(0, EachNote(inputText, DateTime.now().microsecondsSinceEpoch.toString()));
          inputText = '';
          selected = false;
          textAvailable = false;
          widget.storage.setList(notes.map((each) => [each.name, each.id]).toList(), false);
        });
      }
      else{
        setState(() {
          selected = false;
        });
      }
    }
    else {
      setState(() {
        selected = true;
      });
    }
  }

  void listClicked(String each) {
    if (completedNotes.contains(each)) {
      setState(() => completedNotes.remove(each));
    }
    else setState(() => completedNotes.add(each));
    widget.storage.setList(List<String>.from(completedNotes), true);
  }

  Widget textInput() {
    if (selected) {
      return TextField(
        onChanged: (String str) {
          onTextChange(str);
        },
        autofocus: true,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.hintText 
        ),
      );
    }
    else {
      return Container();
    }
  }

  Widget animatedContainer() {
    return AnimatedContainer(
      height: selected? 80 : 0,
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: textInput()
      )
    );
  }

  Widget floatingActionContainer() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: getColor(),
          child: Icon(getIcon()),
          onPressed: floatingButtonClicked,
        ),
      )
    );
  }

  Widget listNotes(EachNote each) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: ListTile(
        onTap: () {
          listClicked(each.id);
        },
        leading: CircleAvatar(
          backgroundColor: getListColor(each),
          child: Text(each.name[0]),
        ),
        title: Text(each.name, style: getStyle(each)),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () { 
            setState(() { 
              notes.remove(each);
              if (completedNotes.contains(each)) completedNotes.remove(each);
              widget.storage.setList(notes.map((each) => [each.name, each.id]).toList(), false);
              widget.storage.setList(completedNotes, true);
            });
          },
        ),
      ),
    );
  }


  @override 
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          animatedContainer(),
          Expanded(
            child: Container(
              child : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int index) {
                  return listNotes(notes[index]);
                },
              )
            ),
          )
          // Text(notesData)
        ],
      ),
      floatingActionButton: floatingActionContainer(),
    );
  }
}