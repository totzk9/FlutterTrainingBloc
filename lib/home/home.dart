import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/bloc/task_bloc.dart';
import 'package:flutter_practice/data/model/task.dart';
import 'package:flutter_practice/item_task/task_card.dart';
import 'package:flutter_practice/new_task/new_task.dart';
import 'package:flutter_practice/task_detail/task_detail.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: _blocBuilder(context));
  }

  // StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
  // final database = Provider.of<TaskDao>(context);
  // return StreamBuilder(
  //     stream: database.watchAllTasks(),
  //     builder: (context, AsyncSnapshot<List<Task>> snapshot) {
  //       final tasks = snapshot.data ?? List();
  //       return ListView.builder(
  //           itemCount: tasks.length,
  //           itemBuilder: (_, index) {
  //             final itemTask = tasks[index];
  //             return _buildListItem(itemTask, database, context);
  //           });
  //     });

  BlocBuilder _blocBuilder(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskInitial) {
          print("TaskInitial");
          initTasks(context);
          return Center(
            child: Container(
              child: Text("Loading"),
            ),
          );
        } else if (state is TaskLoaded) {
          print("TaskLoaded");
          return TaskDetail(state.task);
        } else if (state is AllTaskLoaded) {
          print("AllTaskLoaded ${state.tasks}");
          return Scaffold(
            appBar: AppBar(
                title: Text("Todo List"), automaticallyImplyLeading: false),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount:
                              (state.tasks != null) ? state.tasks.length : 0,
                          itemBuilder: (_, index) {
                            final itemTask = state.tasks[index];
                            return _buildListItem(itemTask, context);
                          }))
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                final taskBloc = BlocProvider.of<TaskBloc>(context);
                taskBloc.add(CreateTaskEvent());
              },
            ),
          );
        } else if (state is CreateTask) {
          print("CreateTask");
          return NewTask();
        }
        // else if (state is TaskError) {
        //   return buildInitialInput();
        // }
      },
    );
  }

  Widget _buildListItem(Task itemTask, BuildContext context) {
    return Slidable(
      child: taskCard(itemTask, context),
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        SlideAction(
            child: Container(
          color: Colors.red,
        ))
      ],
    );
  }

  void initTasks(BuildContext context) {
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    taskBloc.add(GetAllTasks());
  }
}
