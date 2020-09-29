import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/bloc/task_bloc.dart';
import 'package:flutter_practice/data/data_pref.dart';
import 'package:flutter_practice/data/db/task_database.dart';
import 'package:flutter_practice/data/repository/task_repository.dart';
import 'package:flutter_practice/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _appDatabase =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final repository = TaskRepository(_appDatabase);
  await DataPreferences().init();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Todo List",
    home: ThisApp(repository),
  ));
}

class ThisApp extends StatelessWidget {
  final TaskRepository repository;

  ThisApp(this.repository);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Todo List",
        home: FutureBuilder(
          builder: (context, taskSnapshot) {
            return BlocProvider(
              create: (context) =>
                  TaskBloc(AllTaskLoaded(taskSnapshot.data), repository),
              child: Home(),
            );
          },
          future: repository.getAllTasks(),
        ));
  }
}
