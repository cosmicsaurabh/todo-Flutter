import 'package:flutter/material.dart';
import 'package:todo/data/models/task.dart';

class PriorityChip extends StatelessWidget {
  final TaskPriority priority;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const PriorityChip({
    super.key,
    required this.priority,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor(priority);

    return FilterChip(
      label: Text(
        priority.name[0].toUpperCase() + priority.name.substring(1),
        style: TextStyle(color: isSelected ? Colors.white : color),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: color.withOpacity(0.2),
      selectedColor: color,
      checkmarkColor: Colors.white,
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }
}
