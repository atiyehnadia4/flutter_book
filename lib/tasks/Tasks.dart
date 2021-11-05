import 'package:flutter/cupertino.dart';
import 'package:flutter_book_2/tasks/TaskList.dart';
import 'package:flutter_book_2/tasks/TasksModel.dart';
import 'package:scoped_model/scoped_model.dart';

import 'TaskEntry.dart';
import 'TasksDBWorker.dart';

class Tasks extends StatelessWidget {

  Tasks() {
    tasksModel.loadData(TasksDBWorker.db);
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModel<TasksModel>(
        model: tasksModel,
        child: ScopedModelDescendant<TasksModel>(
            builder: (BuildContext context, Widget child, TasksModel model) {
              return IndexedStack(
                index: model.stackIndex,
                children: <Widget>[TaskList(), TaskEntry()],
              );
            }
        )
    );
  }
}