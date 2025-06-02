import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/data/models/task.dart';

class HiveService {
  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Register adapters (they will be available after code generation)
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskPriorityAdapter());
    Hive.registerAdapter(TaskCategoryAdapter());

    // Open boxes
    await Hive.openBox<Task>('tasks');
  }

  static Box<Task> getTaskBox() {
    return Hive.box<Task>('tasks');
  }
}
