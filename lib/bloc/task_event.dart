part of 'task_bloc.dart';

@immutable
abstract class TaskEvent extends Equatable {
  const TaskEvent();
}

class GetTask extends TaskEvent {
  final int id;

  const GetTask(this.id);

  @override
  List<Object> get props => [id];
}

class GetAllTasks extends TaskEvent {
  @override
  List<Object> get props => [];
}

class CreateTaskEvent extends TaskEvent {
  @override
  List<Object> get props => [];
}

class InsertTaskEvent extends TaskEvent {
  final Task task;

  const InsertTaskEvent(this.task);

  @override
  List<Object> get props => [];
}
// class GetTaskWithImage extends TaskEvent {
//   final Task task;
//   const GetTaskWithImage(this.taskName);

//   @override
//   List<Object> get props => [taskName];

// }
