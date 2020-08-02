import 'package:flutternoteapp/models/note.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper; //Singleton DBHelper
  static Database _database; //Singleton DB

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriorities = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DBHelper

  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if (_database == null){
      _database = await initializeDB();
    }
    return _database;
  }


  Future<Database>initializeDB()async{
    //Get directory path for Android and iOS to store db..
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    //Open or Create the db at a given path...
    var notesDatabse = await openDatabase(path,version: 1,onCreate: _createDB);
    return notesDatabse;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT '
        ', $colTitle TEXT, $colDescription TEXT, $colPriorities INTEGER, $colDate TEXT)');
  }

//Fetch Operation: Get all note objects from DB
  Future<List<Map<String, dynamic>>>getNoteMapList() async{
    Database db = await this.database;
    //var result = await db.rawQuery('SELECT * FROM $noteTable orderby $colPriorities ASC');
    var result = await db.query(noteTable, orderBy: '$colPriorities ASC');
    return result;
  }
//Insert Operation: Insert note objects from DB
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = db.insert(noteTable,note.toMap());
    return result;
  }
//Update Operation: Update a note object and save it to DB
  Future<int> updateNote(Note update) async {
    Database db = await this.database;
    var result = db.update(noteTable, update.toMap(), where: '$colId = ?', whereArgs: [update.id]);
    return result;
  }
//Delete Operation: Delete a Note object from DB
  Future<int> deleteNote(int id) async{
    var db  = await this.database;
    int result = await db.rawDelete('Delete FROM $noteTable WHERE $colId = $id');
    return result;
  }
//Get number of note object in Db
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> i = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(i);
    return result;
  }

  //Get the Map List [List<Map> and convert it to Note List -- List<Note>
Future <List<Note>> getNoteList() async {

    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;
    List<Note> noteList = List<Note>();
    //For loop to creae a 'Note List from a Map List
  for (int i = 0; i < count; i++){
    noteList.add(Note.fromMapObject(noteMapList[i]));
  }
  return noteList;
}
}