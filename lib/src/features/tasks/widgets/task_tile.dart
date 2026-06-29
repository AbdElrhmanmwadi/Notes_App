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
          subtitle: _buildSubtitle(theme, reminder, overdue),
        ),
      ),
    );
  }

  /// Builds the optional subtitle: a reminder line (with a repeat icon when the
  /// task recurs) and a subtask progress line. Returns null when neither apply.
  Widget? _buildSubtitle(ThemeData theme, DateTime? reminder, bool overdue) {
    final lines = <Widget>[];
    final muted = theme.colorScheme.outline;

    if (reminder != null) {
      final color = overdue ? theme.colorScheme.error : muted;
      lines.add(Row(
        children: [
          Icon(Icons.alarm, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            DateFormat('MMM d, h:mm a').format(reminder),
            style: theme.textTheme.labelSmall?.copyWith(color: color),
          ),
          if (task.recurrence.isSet) ...[
            const SizedBox(width: 6),
            Icon(Icons.repeat, size: 13, color: muted),
            const SizedBox(width: 2),
            Text(task.recurrence.label,
                style: theme.textTheme.labelSmall?.copyWith(color: muted)),
          ],
        ],
      ));
    }

    if (task.hasSubtasks) {
      final done = task.completedSubtasks;
      final total = task.subtasks.length;
      lines.add(Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Icon(Icons.checklist, size: 14, color: muted),
            const SizedBox(width: 4),
            Text('$done/$total',
                style: theme.textTheme.labelSmall?.copyWith(color: muted)),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : done / total,
                  minHeight: 4,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
          ],
        ),
      ));
    }

    if (lines.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines,
    );
  }
}
