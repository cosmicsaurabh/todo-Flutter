import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/services/notification_service.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/presentation/view_models/task_view_model.dart';
import 'package:todo/presentation/widgets/category_chip.dart';
import 'package:todo/presentation/widgets/priority_picker.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _dueDate;
  TimeOfDay? _reminderTime;
  TaskPriority _priority = TaskPriority.medium;
  TaskCategory _category = TaskCategory.personal;
  bool _hasReminder = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveTask),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildReminderToggle(),
              const SizedBox(height: 16),
              const Text('Priority:'),
              PriorityPicker(
                selectedPriority: _priority,
                onPrioritySelected: (priority) {
                  setState(() {
                    _priority = priority;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Category:'),
              Wrap(
                spacing: 8,
                children:
                    TaskCategory.values.map((category) {
                      return CategoryChip(
                        category: category,
                        isSelected: _category == category,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _category = category;
                            });
                          }
                        },
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _pickDate(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Due Date',
                border: OutlineInputBorder(),
              ),
              child: Text(
                _dueDate == null
                    ? 'Select date'
                    : DateFormat('MMM dd, yyyy').format(_dueDate!),
              ),
            ),
          ),
        ),
        if (_dueDate != null)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _dueDate = null;
              });
            },
          ),
      ],
    );
  }

  Widget _buildReminderToggle() {
    return SwitchListTile(
      title: const Text('Set Reminder'),
      value: _hasReminder,
      onChanged: (value) {
        setState(() {
          _hasReminder = value;
          if (value && _dueDate != null) {
            _pickTime(context);
          }
        });
      },
      secondary: const Icon(Icons.notifications),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });

      if (_hasReminder) {
        await _pickTime(context);
      }
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _reminderTime = pickedTime;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description:
            _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
        createdAt: DateTime.now(),
        dueDate: _dueDate,
        priority: _priority,
        category: _category,
        hasReminder: _hasReminder,
      );

      final taskVM = Provider.of<TaskViewModel>(context, listen: false);
      taskVM.addTask(task);

      if (_hasReminder && _dueDate != null && _reminderTime != null) {
        final notificationTime = DateTime(
          _dueDate!.year,
          _dueDate!.month,
          _dueDate!.day,
          _reminderTime!.hour,
          _reminderTime!.minute,
        );

        if (notificationTime.isAfter(DateTime.now())) {
          NotificationService.scheduleNotification(
            id: task.id.hashCode,
            title: 'Task Reminder',
            body: task.title,
            scheduledDate: notificationTime,
          );
        }
      }

      Navigator.pop(context);
    }
  }
}
