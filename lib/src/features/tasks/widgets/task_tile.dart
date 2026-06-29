import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/task.dart';

/// A single task row with a leading checkbox and optional reminder line.
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
  });

  final Task task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reminder = task.reminderAt;
    final overdue = reminder != null &&
        !task.isComplete &&
        reminder.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: CheckboxListTile(
          value: task.isComplete,
          onChanged: onToggle,
          controlAffinity: ListTileControlAffinity.leading,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              if (task.priority.isSet && !task.isComplete) ...[
                Icon(Icons.flag, size: 16, color: task.priority.color),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  task.title,
                  style: task.isComplete
                      ? theme.textTheme.bodyLarge?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: theme.colorScheme.outline,
                        )
                      : theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          subtitle: reminder == null
              ? null
              : Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      size: 14,
                      color: overdue
                          ? theme.colorScheme.error
                          : theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM d, h:mm a').format(reminder),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: overdue
                            ? theme.colorScheme.error
                            : theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
