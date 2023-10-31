import 'package:flutter/material.dart';

import '../models/list_etudiants.dart';
import '../util/dbuse.dart';

class ListStudentDialog {
  final txtNom = TextEditingController();
  final txtPrenom = TextEditingController();
  final txtdatNais = TextEditingController();
  Widget buildAlert(BuildContext context, ListEtudiants student, bool isNew) {
    dbuse helper = dbuse();
    helper.openDb();
    if (!isNew) {
      txtNom.text = student.nom;
      txtPrenom.text = student.prenom;
      txtdatNais.text = student.datNais;
    }
    return AlertDialog(
      title: Text((isNew) ? 'New student' : 'Edit student'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
                controller: txtNom,
                decoration: const InputDecoration(hintText: 'Student Name')),
            TextField(
              controller: txtPrenom,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
            TextField(
              controller: txtdatNais,
              decoration: const InputDecoration(hintText: 'Date naissance'),
            ),
            ElevatedButton(
                onPressed: () {
                  student.nom = txtNom.text;
                  student.prenom = txtPrenom.text;
                  student.datNais = txtdatNais.text;
                  helper.insertEtudiants(student);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                child: const Text('Save student')),
          ],
        ),
      ),
    );
  }
}
