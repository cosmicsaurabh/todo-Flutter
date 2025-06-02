import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/services/hive_service.dart';
// import 'package:todo/core/services/notification_service.dart';
import 'package:todo/data/repositories.dart/task_repository.dart';
import 'package:todo/presentation/view_models/task_view_model.dart';
import 'package:todo/presentation/view_models/theme_view_model.dart';
import 'package:todo/presentation/views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await HiveService.init();
  // await NotificationService.init();
  // Get the Hive box for tasks
  final taskBox = HiveService.getTaskBox();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(
          create: (_) => TaskViewModel(HiveTaskRepository(taskBox)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = Provider.of<ThemeViewModel>(context);

    return MaterialApp(
      title: 'Enhanced Todo',
      theme: themeVM.currentTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
