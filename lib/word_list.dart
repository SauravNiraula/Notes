import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


class RandomWords extends StatefulWidget {
  @override 
  _RandomWordsState createState()  {
    return _RandomWordsState();
  } 
}


class _RandomWordsState extends State<RandomWords> {

  var suggession = <WordPair>[];

  _RandomWordsState() {
    suggession.addAll(generateWordPairs().take(10));
  }

  @override 
  Widget build (BuildContext context) {
    return ListView.builder(
      itemCount: this.suggession.length,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: [
              Container(child: Center(child: Text(this.suggession[index].asPascalCase)), height: 50),
              Divider()
            ]
          )
        );
      }
    );
  }
}