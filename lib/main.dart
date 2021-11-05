

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_2/tasks/Tasks.dart';

import 'notes/Notes.dart';

void main() {
  runApp(FlutterBook());
}

class _Dummy extends StatelessWidget {
  final _title;

  _Dummy(this._title);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(_title));
  }
}


class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: AppBar(
                    title: Text('FlutterBook'),
                    bottom: TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.date_range),
                              text: 'Appointments'),
                          Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
                          Tab(icon: Icon(Icons.note), text: 'Notes'),
                          Tab(icon: Icon(Icons.assignment_turned_in),
                              text: 'Tasks'),
                        ]
                    )
                ),
                body: TabBarView(
                    children: [
                      _Dummy('Appointments'),
                      _Dummy('Contacts'),
                      Notes(),
                      Tasks()]
                )
            )
        )
    );
  }
}

// class _FlutterBook extends StatelessWidget {
//   static const _TABS = const [
//     const {'icon': Icons.date_range, 'name': 'Appointments'},
//     const {'icon': Icons.contacts, 'name': 'Contacts'},
//     const {'icon': Icons.note, 'name': 'Notes'},
//     const {'icon': Icons.assignment_turned_in, 'name': 'Tasks'},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         theme: ThemeData(primarySwatch: Colors.blue),
//     home: DefaultTabController(
//     length: _TABS.length, // 4
//     child: Scaffold(
//     appBar: AppBar(
//     title: Text('FlutterBook'),
//     bottom: TabBar(tabs: _TABS.map((tab) => Tab(icon: Icon(tab['icon’]), text: tab['name'])).toList())
//     ),
//     body: TabBarView(children: _TABS.map((tab) => _Dummy(tab['name'])).toList(),
//     )
//     )
//     )
//     );
//   }
// }

