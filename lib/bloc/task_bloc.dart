import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_practice/data/model/task.dart';
import 'package:flutter_practice/data/repository/task_repository.dart';
import 'package:meta/meta.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  // TaskBloc() : super(TaskInitial());

  // @override
  // TaskState get initialState => TaskInitial();

  TaskBloc(TaskState initialState, this.taskRepository) : super(initialState);

  @override
  Stream<TaskState> mapEventToState(
    TaskEvent event,
  ) async* {
    yield TaskLoading();
    if (event is GetTask) {
      try {
        final task = await taskRepository.getTask(event.id);
        yield TaskLoaded(task);
      } on NetworkError {
        yield TaskError("error");
      }
    } else if (event is GetAllTasks) {
      try {
        final tasks = await taskRepository.getAllTasks();
        print('saved $tasks');
        yield AllTaskLoaded(tasks);
      } on NetworkError {
        yield TaskError("error");
      }
    } else if (event is CreateTaskEvent) {
      try {
        // final tasks = await taskRepository.getAllTasks();
        yield CreateTask();
      } on NetworkError {
        yield TaskError("error");
      }
    } else if (event is InsertTaskEvent) {
      try {
        // final tasks = await taskRepository.getAllTasks();
        await taskRepository.insertTask(event.task);
        final tasks = await taskRepository.getAllTasks();
        print('saved ${event.task}');
        yield AllTaskLoaded(tasks);
        // yield InsertTask(event.task);
      } on NetworkError {
        yield TaskError("error");
      }
    }
  }
}
