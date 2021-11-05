import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_2/tasks/TasksDBWorker.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../utils.dart';
import 'TasksModel.dart';

class TaskEntry extends StatelessWidget {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TaskEntry() {
    _titleEditingController.addListener(() {
      tasksModel.taskBeingEdited.description = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      tasksModel.taskBeingEdited.dueDate  = _contentEditingController.text;
    });
  }

  void _save(BuildContext context, TasksModel model) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (model.taskBeingEdited.id == null) {
      await TasksDBWorker.db.create(tasksModel.taskBeingEdited);
    } else {
      await TasksDBWorker.db.update(tasksModel.taskBeingEdited);
    }
    tasksModel.loadData(TasksDBWorker.db);

    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), content: Text('Task saved'),
        )
    );
  }

  ListTile _buildContentListTile() {
    return ListTile(
        leading: Icon(Icons.content_paste),
        title: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            decoration: InputDecoration(hintText: 'Description'),
            controller: _titleEditingController,
            validator: (String? value) {
              if (value!.length == 0) {
                return 'Please enter description';
              }
              return null;
            }
        )
    );
  }

  Row _buildControlButtons(BuildContext context, TasksModel model) {
    return Row(children: [
      TextButton(
        child: Text('Cancel'),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          model.setStackIndex(0);
        },
      ),
      Spacer(),
      TextButton(
        child: Text('Save'),
        onPressed: () {
          _save(context, tasksModel);
        },
      )
    ]
    );
  }

  String _dueDate() {
    if (tasksModel.taskBeingEdited != null && tasksModel.taskBeingEdited.hasDueDate()) {
      return tasksModel.taskBeingEdited.dueDate;
    }
    return '';
  }

  Future<String> selectDate(BuildContext context, dynamic model, String date) async {
    DateTime initialDate = date != null ?  toDate(date) : DateTime.now();
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null) {
      model.setChosenDate(DateFormat.yMMMMd('en_US').format(picked.toLocal()));
    }
    return "${picked?.month}/${picked?.day}/${picked?.year}";
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
        builder: (BuildContext context, Widget child, TasksModel model) {
          _titleEditingController.text = model.taskBeingEdited?.description;
          _contentEditingController.text = model.taskBeingEdited?.dueDate;
          return Scaffold(
              bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: _buildControlButtons(context, model)
              ),
              body:
              Form(
                  key: _formKey,
                  child: ListView(
                      children: [
                        _buildContentListTile(),
                        ListTile(
                          leading: Icon(Icons.today),
                          title: Text("Due Date"),
                          subtitle: Text(_dueDate()),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () async {
                              String chosenDate = await selectDate(context, model,
                                  model.taskBeingEdited?.dueDate);
                              if (chosenDate != null) {
                                model.taskBeingEdited?.dueDate = chosenDate;
                              }
                            },
                          ),
                        ),
                      ]
                  )
              )
          );
        }
    );
  }
}

