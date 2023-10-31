// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../models/list_etudiants.dart';
import '../models/scol_list.dart';
import '../util/dbuse.dart';
import '../ui/list_student_dialog.dart';

class StudentsScreen extends StatefulWidget {
  final ScolList scolList;
  const StudentsScreen(this.scolList, {super.key});

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  dbuse helper = dbuse();
  ListStudentDialog dialog = ListStudentDialog();
// Initialize the dbuse here
  List<ListEtudiants> students = [];

  @override
  void initState() {
    super.initState();
    showData(widget.scolList.codClass);
  }

  @override
  Widget build(BuildContext context) {
    helper = dbuse();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scolList.nomClass),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(students[index].nom),
            subtitle: Text(
                'Prenom: ${students[index].prenom} - Date Nais:${students[index].datNais}'),
            onTap: () {},
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        dialog.buildAlert(context, students[index],
                            false));
              },
            ),

          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildAlert(
                context, ListEtudiants(0, widget.scolList.codClass, '', '', ''), true),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),

    );
  }

  Future<void> showData(int idList) async {
    await helper.openDb();
    students = await helper.getEtudiants( idList.toString() );
    setState(() {
      students = students;
    });
  }
}
