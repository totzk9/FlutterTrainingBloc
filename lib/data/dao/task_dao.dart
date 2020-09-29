import 'package:floor/floor.dart';
import 'package:flutter_practice/data/model/task.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM Task')
  Future<List<Task>> getAllTasks();

  @Query('SELECT * FROM Task')
  Stream<List<Task>> streamAllTasks();

  @Query('SELECT * FROM Task WHERE id = :id')
  Future<Task> getTask(int id);

  @insert
  Future<void> insertTask(Task task);

  @delete
  Future<void> deleteTask(Task task);

  @update
  Future<void> updateTask(Task task);

  watchAllTasks() {}
}
