// ignore_for_file: library_private_types_in_public_api

import 'package:communication_sql/ui/scol_list_dialog.dart';
import 'package:communication_sql/ui/students_screen.dart';
import 'package:communication_sql/util/dbuse.dart';
import 'package:flutter/material.dart';

import 'models/scol_list.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Classes List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ShList());
  }
}

class ShList extends StatefulWidget {
  const ShList({super.key});

  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  List<ScolList> scolList = [];

  dbuse helper = dbuse();
  late ScolListDialog dialog;

  @override
  void initState() {
    dialog = ScolListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScolListDialog dialog = ScolListDialog();
    showData();
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Classes list'),
      ),
      body: ListView.builder(
        // ignore: unnecessary_null_comparison
        itemCount: (scolList != null) ? scolList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              key: Key(scolList[index].nomClass),
              onDismissed: (direction) {
                // ignore: unused_local_variable
                String strName = scolList[index].nomClass;
                helper.deleteList(scolList[index]);
                setState(() {
                  scolList.removeAt(index);
                });
                Scaffold(
                    appBar: AppBar(
                  title: const Text(' Classes list'),
                ));
              },
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentsScreen(scolList[index])),
                  );
                },
                title: Text(scolList[index].nomClass),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          dialog.buildDialog(context, scolList[index], false),
                    );
                  },
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                dialog.buildDialog(context, ScolList(0, '', 0), true),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future showData() async {
    await helper.openDb();
    scolList = await helper.getClasses();
    setState(() {
      scolList = scolList;
    });
  }
}
