import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_practice/data/data_pref.dart';
import 'package:flutter_practice/data/model/task.dart';

Widget taskCard(Task task, BuildContext context) {
  return Card(
      child: InkWell(
    onTap: () {
      print(task.id);
      DataPreferences().setIntData("currentTask", task.id);
      Navigator.pushNamed(context, '/task_detail');
    },
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            task.name,
            style: TextStyle(fontSize: 14.0),
          ),
          if (task.imageUrl != null)
            SizedBox(
              height: 8,
            ),
          if (task.imageUrl != null) Image.file(File(task.imageUrl)),
          if (task.imageUrl != null)
            SizedBox(
              height: 8,
            ),
          Text(
            task.status,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 12.0),
          )
        ],
      ),
    ),
  ));
}
