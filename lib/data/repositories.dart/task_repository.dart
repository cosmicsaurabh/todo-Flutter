import 'package:hive/hive.dart';
import 'package:todo/data/models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}

class HiveTaskRepository implements TaskRepository {
  final Box<Task> taskBox;

  HiveTaskRepository(this.taskBox);

  @override
  Future<List<Task>> getAllTasks() async {
    return taskBox.values.toList();
  }

  @override
  Future<void> addTask(Task task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await taskBox.delete(taskId);
  }
}
