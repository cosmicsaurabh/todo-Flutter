import 'package:flutter/material.dart';
import 'package:todo/data/models/task.dart';

class PriorityPicker extends StatelessWidget {
  final TaskPriority? selectedPriority;
  final Function(TaskPriority) onPrioritySelected;

  const PriorityPicker({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          TaskPriority.values.map((priority) {
            final isSelected = selectedPriority == priority;
            return ChoiceChip(
              label: Text(
                priority.toString().split('.').last,
                style: TextStyle(
                  color:
                      isSelected ? Colors.white : _getPriorityColor(priority),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onPrioritySelected(priority);
                }
              },
              backgroundColor: _getPriorityColor(priority).withOpacity(0.2),
              selectedColor: _getPriorityColor(priority),
            );
          }).toList(),
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
