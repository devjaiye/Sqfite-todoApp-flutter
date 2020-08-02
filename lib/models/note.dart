
class Note{
  int _id;
  String _title;
  String _description;
  String _date;
  int _priorities;

  Note(this._title,this._date,this._priorities, [this._description]);

  Note.withId(this._id,this._title,this._date,this._priorities, [this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get priorities => _priorities;
  String get date => _date;

  set title(String newTitle){
    if(newTitle.length <= 255){
      this._title = newTitle;
    }
  }

  set description(String newDescription){
    if(newDescription.length <= 255){
      this._description = newDescription;
    }
  }


  set priority(int newPriority){
    if(newPriority >= 1 && newPriority <= 2){
      this._priorities = newPriority;
    }
  }

  set date(String newDate){
    this._date = newDate;
  }

//Convert a Note object into a Map object....
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if(id !=null){
      map ['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priorities;
    map['date'] = _date;

    return map;
  }

//Extract a Note object from a Map object....
  Note.fromMapObject(Map<String, dynamic>map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priorities = map['priority'];
    this._date = map['date'];
  }

}

