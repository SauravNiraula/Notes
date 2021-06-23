import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
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
  var inputTextController = TextEditingController();

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

  void setNotes(List<dynamic> notes, bool completed) {
    notes = completed? notes : notes.map((each) => [each.name, each.id]).toList();
    widget.storage.setList(notes, completed);
  }

  void floatingButtonClicked() {

    if (selected) {
      if (textAvailable) {
        setState(() {
          notes.insert(0, EachNote(inputText, DateTime.now().microsecondsSinceEpoch.toString()));
          inputText = '';
          inputTextController.clear();
          // selected = false;
          textAvailable = false;
          // widget.storage.setList(notes.map((each) => [each.name, each.id]).toList(), false);
          setNotes(notes, false);
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
    // widget.storage.setList(completedNotes, true);
    setNotes(completedNotes, true);
  }

  void deleteClicked(EachNote each) {
    setState(() { 
      notes.remove(each);
      completedNotes.remove(each.id);
    });
    getApplicationDocumentsDirectory().then((dir) {
      File file = File(dir.path + "/notes.json");
      List<dynamic> temp = notes.map((each) => [each.name, each.id]).toList();
      Map<String, dynamic> object = {"notes": temp, "completedNotes": completedNotes};
      String jsonData = jsonEncode(object);
      file.writeAsString(jsonData);
    });
  }

  // Future<void> setTheState(EachNote each) async{
  //   setState(() { 
  //     notes = notes.where((element) => element.id != each.id).toList();
  //     completedNotes.remove(each.id);
      
  //   });
  // }

  Widget textInput() {
    if (selected) {
      return TextField(
        controller: inputTextController,
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
          onPressed: () => deleteClicked(each),
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
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selected = false;
                });
              },
              child: Container(
                child : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return listNotes(notes[index]);
                  },
                )
              ),
            ),
          )
          // Text(notesData)
        ],
      ),
      floatingActionButton: floatingActionContainer(),
    );
  }
}