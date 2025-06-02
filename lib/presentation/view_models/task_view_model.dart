import 'package:flutter/material.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/data/repositories.dart/task_repository.dart';

class TaskViewModel with ChangeNotifier {
  final TaskRepository _taskRepository;

  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  String _searchQuery = '';
  bool _showCompleted = false;
  TaskCategory? _selectedCategory;
  TaskPriority? _selectedPriority;

  TaskViewModel(this._taskRepository) {
    loadTasks();
  }

  List<Task> get tasks => _filteredTasks;
  List<Task> get allTasks => _tasks;
  String get searchQuery => _searchQuery;

  Future<void> loadTasks() async {
    _tasks = await _taskRepository.getAllTasks();
    _applyFilters();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskRepository.addTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _taskRepository.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await _taskRepository.deleteTask(taskId);
    await loadTasks();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void toggleShowCompleted() {
    _showCompleted = !_showCompleted;
    _applyFilters();
    notifyListeners();
  }

  void setSelectedCategory(TaskCategory? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void setSelectedPriority(TaskPriority? priority) {
    _selectedPriority = priority;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredTasks =
        _tasks.where((task) {
          final matchesSearch =
              task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (task.description?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false);

          final matchesCompletion = _showCompleted ? true : !task.isCompleted;

          final matchesCategory =
              _selectedCategory == null || task.category == _selectedCategory;

          final matchesPriority =
              _selectedPriority == null || task.priority == _selectedPriority;

          return matchesSearch &&
              matchesCompletion &&
              matchesCategory &&
              matchesPriority;
        }).toList();

    // Sort by priority then by due date
    _filteredTasks.sort((a, b) {
      final priorityCompare = b.priority.index.compareTo(a.priority.index);
      if (priorityCompare != 0) return priorityCompare;

      if (a?.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;

      return a.dueDate!.compareTo(b.dueDate!);
    });
  }

  bool get showCompleted => _showCompleted;
  TaskCategory? get selectedCategory => _selectedCategory;
  TaskPriority? get selectedPriority => _selectedPriority;
}
