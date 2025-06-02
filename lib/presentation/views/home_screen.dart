import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/presentation/view_models/task_view_model.dart';
import 'package:todo/presentation/view_models/theme_view_model.dart';
import 'package:todo/presentation/views/add_task_screen.dart';
import 'package:todo/presentation/widgets/category_chip.dart';
import 'package:todo/presentation/widgets/priority_picker.dart';
import 'package:todo/presentation/widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = Provider.of<ThemeViewModel>(context);
    final taskVM = Provider.of<TaskViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Todo'),
        actions: [
          IconButton(
            icon: Icon(themeVM.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeVM.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: taskVM.setSearchQuery,
            ),
          ),
          _buildFilterRow(context, taskVM),
          Expanded(
            child: ListView.builder(
              itemCount: taskVM.tasks.length,
              itemBuilder: (context, index) {
                final task = taskVM.tasks[index];
                return TaskTile(
                  task: task,
                  onToggleComplete: (isCompleted) {
                    taskVM.updateTask(task.copyWith(isCompleted: isCompleted));
                  },
                  onDelete: () => _showDeleteDialog(context, taskVM, task),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget _buildFilterRow(BuildContext context, TaskViewModel taskVM) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: Row(
  //         children: [
  //           FilterChip(
  //             label: const Text('Show Completed'),
  //             selected: taskVM._showCompleted,
  //             onSelected: (_) => taskVM.toggleShowCompleted(),
  //           ),
  //           const SizedBox(width: 8),
  //           ...TaskCategory.values.map((category) {
  //             return Padding(
  //               padding: const EdgeInsets.only(right: 8.0),
  //               child: CategoryChip(
  //                 category: category,
  //                 isSelected: taskVM._selectedCategory == category,
  //                 onSelected: (selected) {
  //                   taskVM.setSelectedCategory(selected ? category : null);
  //                 },
  //               ),
  //             );
  //           }),
  //           const SizedBox(width: 8),
  //           PriorityPicker(
  //             selectedPriority: taskVM.selectedPriority,
  //             onPrioritySelected: taskVM.setSelectedPriority,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildFilterRow(BuildContext context, TaskViewModel taskVM) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            FilterChip(
              label: const Text('Show Completed'),
              selected: taskVM.showCompleted,
              onSelected: (_) => taskVM.toggleShowCompleted(),
            ),
            const SizedBox(width: 8),
            ...TaskCategory.values.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CategoryChip(
                  category: category,
                  isSelected: taskVM.selectedCategory == category,
                  onSelected: (selected) {
                    taskVM.setSelectedCategory(selected ? category : null);
                  },
                ),
              );
            }),
            const SizedBox(width: 8),
            PriorityPicker(
              selectedPriority: taskVM.selectedPriority,
              onPrioritySelected: taskVM.setSelectedPriority,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    TaskViewModel taskVM,
    Task task,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  taskVM.deleteTask(task.id);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _navigateToAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
        fullscreenDialog: true,
      ),
    );
  }
}
