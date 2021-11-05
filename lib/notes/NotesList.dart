import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

import 'NotesDBWorker.dart';
import 'NotesModel.dart';

class NotesList extends StatelessWidget {
  Color _toColor(String color) {
    Color col = Colors.white;
    switch (color) {
      case "red" :
        col = Colors.red;
        break;
      case "green" :
        col = Colors.green;
        break;
      case "blue" :
        col = Colors.blue;
        break;
      case "yellow" :
        col = Colors.yellow;
        break;
      case "grey" :
        col = Colors.grey;
        break;
      case "purple" :
        col = Colors.purple;
        break;
    }
    return col;
  }

  _deleteNote(BuildContext context, NotesModel model, Note note) {
    return showDialog(
        context : context,
        barrierDismissible : false,
        builder : (BuildContext alertContext) {
          return AlertDialog(
              title : Text("Delete Note"),
              content : Text("Are you sure you want to delete ${note.title}?"),
              actions : [
                TextButton(child : Text("Cancel"),
                    onPressed: ()  => Navigator.of(alertContext).pop(),
                ),
                TextButton(child : Text("Delete"),
                    onPressed : () async {
                      await NotesDBWorker.db.delete(note.id);
                      Navigator.of(alertContext).pop();
                      Scaffold.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor : Colors.red,
                              duration : Duration(seconds : 2),
                              content : Text("Note deleted")
                          )
                      );
                      model.loadData(NotesDBWorker.db);
                    }
                ) ] ); } ); }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NotesModel>(
        builder: (BuildContext context, Widget child, NotesModel model) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    model.noteBeingEdited = Note();
                    model.setColor('');
                    model.setStackIndex(1);
                  }
              ),
              body: ListView.builder(
                  itemCount: model.noteList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Note note = model.noteList[index];
                    Color color = _toColor(note.color);
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
                                  onTap: () => _deleteNote(context, model, note)
                              )
                            ],
                            child: Card(
                                elevation: 8,
                                color: color,
                                child: ListTile(
                                  title: Text(note.title),
                                  subtitle: Text(note.content),
                                  onTap: () {
                                    model.noteBeingEdited = note;
                                    model.setColor(model.noteBeingEdited.color);
                                    model.setStackIndex(1);
                                  },
                                )
                            )
                        )
                    );
                  }));
        });
  }
}
