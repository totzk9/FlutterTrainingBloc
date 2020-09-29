import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter_practice/data/dao/task_dao.dart';
import 'package:flutter_practice/data/model/task.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'task_database.g.dart';

@Database(version: 1, entities: [Task])
abstract class AppDatabase extends FloorDatabase {
  TaskDao get taskDao;
}
