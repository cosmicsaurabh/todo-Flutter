import 'package:todo/presentation/views/add_task_screen.dart';
import 'package:todo/presentation/views/home_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
  static const String taskDetail = '/task-detail';
  static const String settings = '/settings';

  static final routes = {
    home: (context) => const HomeScreen(),
    addTask: (context) => const AddTaskScreen(),
    // Add other routes here
  };
}
