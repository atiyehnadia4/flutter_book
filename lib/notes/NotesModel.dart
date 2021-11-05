import 'package:scoped_model/scoped_model.dart';

import '../BaseModel.dart';

NotesModel notesModel = NotesModel();

class Note {
  var id;
  var title;
  var content;
  var color;

  String toString() => "{title=$title, content=$content, color=$color }";
}

class NotesModel extends BaseModel<Note>{
  var _stackIndex = 0;

  int get stackIndex => _stackIndex;

  void set stackIndex(int stackIndex) {
    _stackIndex = stackIndex;
    notifyListeners();
  }

  List<Note> get noteList => entryList;

  set noteList(List<Note> value) {
    entryList = value;
  }

  List<Note> entryList = [];

  var _entryBeingEdited;
  var _color;

  void setStackIndex(int stackIndex) {
    this.stackIndex = stackIndex;
    notifyListeners();
  }

  void setColor(String color) {
    this.color = color;
    notifyListeners();
  }

  get noteBeingEdited => _entryBeingEdited;

  set noteBeingEdited(value) {
    _entryBeingEdited = value;
  }

  get color => _color;

  set color(value) {
    _color = value;
  }
  void loadData(dynamic database) async {
    noteList.clear();
    noteList.addAll(await database.getAll());
    notifyListeners();
  }


}
