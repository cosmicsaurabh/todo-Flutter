import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/services/notification_service.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/presentation/view_models/task_view_model.dart';
import 'package:todo/presentation/widgets/category_chip.dart';
import 'package:todo/presentation/widgets/padded_card.dart';
import 'package:todo/presentation/widgets/priority_chip.dart';

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
        title: const Text('Add Task'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveTask),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCard([
                _buildTextField('Title*', _titleController, required: true),
                const SizedBox(height: 12),
                _buildTextField(
                  'Description',
                  _descriptionController,
                  maxLines: 3,
                ),
              ]),
              const SizedBox(height: 12),
              _buildCard([
                _buildDatePicker(),
                const SizedBox(height: 12),
                _buildReminderToggle(),
              ]),
              const SizedBox(height: 12),
              _buildCard([
                const Text(
                  'Priority',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Wrap(
                  spacing: 8,
                  children:
                      TaskPriority.values.map((priority) {
                        return PriorityChip(
                          priority: priority,
                          isSelected: _priority == priority,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _priority = priority);
                            }
                          },
                        );
                      }).toList(),
                ),
              ]),
              const SizedBox(height: 12),
              _buildCard([
                const Text(
                  'Category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children:
                      TaskCategory.values.map((category) {
                        return CategoryChip(
                          category: category,
                          isSelected: _category == category,
                          onSelected: (selected) {
                            if (selected) setState(() => _category = category);
                          },
                        );
                      }).toList(),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return PaddedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
      ),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Due Date',
          border: OutlineInputBorder(),
        ),
        child: Text(
          _dueDate == null
              ? 'Select date'
              : DateFormat('EEE, MMM dd, yyyy').format(_dueDate!),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildReminderToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Set Reminder', style: TextStyle(fontSize: 16)),
        Switch(
          value: _hasReminder,
          onChanged: (value) {
            setState(() {
              _hasReminder = value;
              if (value && _dueDate != null) {
                _pickTime(context);
              }
            });
          },
        ),
      ],
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
      setState(() => _dueDate = pickedDate);
      if (_hasReminder) await _pickTime(context);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() => _reminderTime = pickedTime);
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
