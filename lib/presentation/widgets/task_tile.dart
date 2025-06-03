import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/presentation/widgets/padded_card.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool) onToggleComplete;
  final Function() onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: PaddedCard(
          child: CheckboxListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: _buildSubtitle(context),
            value: task.isCompleted,
            onChanged: (value) => onToggleComplete(value ?? false),
            secondary: _buildPriorityIndicator(),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    final List<Widget> widgets = [];

    if (task.description != null) {
      widgets.add(
        Text(
          task.description!,
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    if (task.dueDate != null) {
      widgets.add(const SizedBox(height: 4));
      widgets.add(
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 14),
            const SizedBox(width: 4),
            Text(
              'Due ${DateFormat('MMM dd').format(task.dueDate!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    if (task.hasReminder) {
      widgets.add(const SizedBox(height: 4));
      widgets.add(
        const Row(
          children: [
            Icon(Icons.notifications, size: 14),
            SizedBox(width: 4),
            Text('Reminder set'),
          ],
        ),
      );
    }

    return widgets.isEmpty
        ? null
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        );
  }

  Widget _buildPriorityIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: _getPriorityColor(task.priority),
        shape: BoxShape.circle,
      ),
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
