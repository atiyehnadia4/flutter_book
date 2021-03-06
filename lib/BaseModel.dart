import 'package:scoped_model/scoped_model.dart';

class BaseModel<T> extends Model {
  int stackIndex = 0;
  List<T> entryList = [];
  var entityBeingEdited;

  void setStackIndex(int stackIndex) {
    this.stackIndex = stackIndex;
    notifyListeners();
  }

  void loadData(database) async {
    entryList.clear();
    entryList.addAll(await database.getAll());
    notifyListeners();
  }
}

mixin DateSelection on Model {
  var chosenDate;

  void setChosenDate(String date) {
    this.chosenDate = date;
    notifyListeners();
  }
}
