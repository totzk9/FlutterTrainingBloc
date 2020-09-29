part of 'task_bloc.dart';

@immutable
abstract class TaskState extends Equatable {
  const TaskState();
}

class TaskInitial extends TaskState {
  const TaskInitial();

  @override
  List<Object> get props => [];
}

class CreateTask extends TaskState {
  const CreateTask();

  @override
  List<Object> get props => [];
}

class InsertTask extends TaskState {
  final Task task;

  const InsertTask(this.task);

  @override
  List<Object> get props => [task];
}

class TaskLoading extends TaskState {
  const TaskLoading();

  @override
  List<Object> get props => [];
}

class TaskLoaded extends TaskState {
  final Task task;

  const TaskLoaded(this.task);

  @override
  List<Object> get props => [task];
}

class AllTaskLoaded extends TaskState {
  final List<Task> tasks;

  const AllTaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskError extends TaskState {
  final String errorMessage;
  const TaskError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
