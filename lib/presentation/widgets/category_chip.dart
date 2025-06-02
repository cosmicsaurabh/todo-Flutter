import 'package:flutter/material.dart';
import 'package:todo/data/models/task.dart';

class CategoryChip extends StatelessWidget {
  final TaskCategory category;
  final bool isSelected;
  final Function(bool) onSelected;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(category);

    return FilterChip(
      label: Text(
        category.toString().split('.').last,
        style: TextStyle(color: isSelected ? Colors.white : color),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: color.withOpacity(0.2),
      selectedColor: color,
      checkmarkColor: Colors.white,
    );
  }

  Color _getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return Colors.blue;
      case TaskCategory.personal:
        return Colors.green;
      case TaskCategory.shopping:
        return Colors.orange;
      case TaskCategory.others:
        return Colors.purple;
    }
  }
}
