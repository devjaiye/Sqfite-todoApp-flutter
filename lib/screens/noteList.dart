import 'package:flutter/material.dart';
import 'package:flutternoteapp/screens/note_details.dart';
import 'package:flutternoteapp/models/note.dart';
import 'package:flutternoteapp/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //implement createState
    return _NoteList();
  }
}

class _NoteList extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  int position;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Note Room'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          navigateNoteDetail(Note('', '', 2), 'Add Note');
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Note',
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, position) {
          return Dismissible(
            key: ObjectKey(noteList[position]),
            child: Card(
              color: Colors.white,
              elevation: 7.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                  getPriorityColor(this.noteList[position].priorities),
                  child: getPriorityIcon(this.noteList[position].priorities),
                ),

                title: Text(
                  this.noteList[position].title,
                  style: titleStyle,
                ),
                subtitle: Text(this.noteList[position].date),
                trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    // _delete(context, noteList[position]);
                    debugPrint('Click me...');
                  },
                ),
                onTap: () {
                  navigateNoteDetail(this.noteList[position], 'Edit Note');
                },
              ),
            ),
            //...

          );
        });
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Color(0xFFFFA000);
        break;
      default:
        return Color(0xFFFFA000);
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.priority_high,
        color: Colors.white,);
        break;
      case 2:
        return Icon(Icons.report_problem,
          color: Colors.white,);
        break;

      default:
        return Icon(Icons.priority_high);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      Future.delayed(Duration(seconds: 5)).then((_) {
        _showSnackBar(context, 'Note Deleted Successfully');
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
    updateListView();
  }

  void navigateNoteDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDB();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    dispose();
  }

//....
/* void getAlertDialog(BuildContext context){
    Column(
      children: <Widget>[
        AlertDialog(title: Text('Are You Sure?'),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: (){
                  setState(() {
                    _delete(context, noteList[position]);
                  });
                }, icon: null, label: null),
            Text('Yes')
          ],),

        FlatButton.icon(onPressed: (){
          deactivate();
        }, icon: null, label: null),
        Text('No'),
      ],
    );
  } */
}
