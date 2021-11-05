import '../BaseModel.dart';

TasksModel tasksModel = TasksModel();

class Task {
  var id;
  var description;
  var dueDate;
  var completed = false; // note that the textbook uses String.

  String toString() {
    return "{ id=$id, description=$description, dueDate=$dueDate, completed=$completed }";
  }

  bool hasDueDate() {
    return dueDate != null;
  }
}

class TasksModel extends BaseModel<Task> with DateSelection {
  var _stackIndex = 0;

  int get stackIndex => _stackIndex;

  void set stackIndex(int stackIndex) {
    _stackIndex = stackIndex;
    notifyListeners();
  }

  List<Task> entryList = [];

  List<Task> get taskList => entryList;

  set taskList(List<Task> value) {
    entryList = value;
  }

  var _entryBeingEdited;

  void setStackIndex(int stackIndex) {
    this.stackIndex = stackIndex;
    notifyListeners();
  }

  get taskBeingEdited => _entryBeingEdited;

  set taskBeingEdited(value) {
    _entryBeingEdited = value;
  }

  void loadData(dynamic database) async {
    taskList.clear();
    taskList.addAll(await database.getAll());
    notifyListeners();
  }
}
