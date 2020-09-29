// @DataClassName('Tasks')
import 'package:floor/floor.dart';

@entity
class Task {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String imageUrl;
  final String status;
  // final String dateAdded;

  // @override
  // Set<Column> get primaryKey => {id};
  Task({this.id, this.name, this.imageUrl, this.status});

  @override
  String toString() {
    return 'Task{id: $id, name: $name,imageUrl: $imageUrl, status: $status}';
  }
}
