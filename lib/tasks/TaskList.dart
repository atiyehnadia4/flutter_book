import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_2/tasks/TasksDBWorker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

import 'TasksModel.dart';
class TaskList extends StatefulWidget {
  @override
  _TaskList createState() => _TaskList();
}



class _TaskList extends State<TaskList> {

  _deleteTask(BuildContext context, TasksModel model, Task task) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
              title: Text("Delete Note"),
              content: Text("Are you sure you want to delete ${task.completed}?"),
              actions: [
                TextButton(child: Text("Cancel"),
                  onPressed: () => Navigator.of(alertContext).pop(),
                ),
                TextButton(child: Text("Delete"),
                    onPressed: () async {
                      await TasksDBWorker.db.delete(task.id);
                      Navigator.of(alertContext).pop();
                      Scaffold.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                              content: Text("Note deleted")
                          )
                      );
                      model.loadData(TasksDBWorker.db);
                    }
                )
              ]);
        });
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
        builder: (BuildContext context, Widget child, TasksModel model) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    model.taskBeingEdited = Task();
                    model.setStackIndex(1);
                  }
              ),
              body: ListView.builder(
                  itemCount: model.taskList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Task task = model.taskList[index];
                    return Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: .25,
                            secondaryActions: [
                              IconSlideAction(
                                  caption: "Delete",
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () => _deleteTask(context, model, task)
                              )
                            ],
                            child: ListTile(
                                leading: Checkbox(
                                    value: task.completed,
                                    onChanged: (value) async{
                                      setState((){
                                        task.completed = value!;
                                      });
                                      //model.loadData(TasksDBWorker.db);
                                      await TasksDBWorker.db.update(task);
                                      }
                                    ),
                                title: Text("${task.description}",
                                    style: task.completed
                                        ? TextStyle(
                                        color: Theme
                                            .of(context)
                                            .disabledColor,
                                        decoration: TextDecoration.lineThrough)
                                        : null
                                ),
                                subtitle: Text("${task.dueDate}",
                                    style: task.completed
                                        ? TextStyle(
                                        color: Theme
                                            .of(context)
                                            .disabledColor,
                                        decoration: TextDecoration.lineThrough)
                                        : null),
                                onTap: () {
                                  model.taskBeingEdited = task;
                                  model.setStackIndex(1);
                                },

                            )
                        )
                    );
                  }
              )
          );
        }
    );
  }
}