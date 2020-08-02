import 'package:flutter/material.dart';
import 'package:flutternoteapp/screens/noteList.dart';

void main() => runApp(NoteApp());

class NoteApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //implement build
    return MaterialApp(
      title: 'Note App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo
      ),
      home: NoteList(),
    );
  }

}