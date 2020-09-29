import 'package:flutter_practice/data/db/task_database.dart';
import 'package:flutter_practice/data/model/task.dart';

class TaskRepository {
  final AppDatabase _appDatabase;
  TaskRepository(this._appDatabase);

  Future<List<Task>> getAllTasks() {
    return _appDatabase.taskDao.getAllTasks();
  }

  Stream<List<Task>> streamAllTasks() {
    return _appDatabase.taskDao.streamAllTasks();
  }

  Future<Task> getTask(int id) {
    return _appDatabase.taskDao.getTask(id);
  }

  Future<void> insertTask(Task task) {
    return _appDatabase.taskDao.insertTask(task);
  }

  Future<void> deleteTask(Task task) {
    return _appDatabase.taskDao.deleteTask(task);
  }

  Future<void> updateTask(Task task) {
    return _appDatabase.taskDao.updateTask(task);
  }
}

class NetworkError extends Error {}
