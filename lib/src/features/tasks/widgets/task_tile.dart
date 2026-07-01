import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/task.dart';

/// A single task card: a rounded checkbox, title, optional reminder/subtask
/// meta, and — when the task has subtasks — an expandable checklist that can be
/// ticked inline without opening the editor.
///
/// A thin accent stripe on the leading edge encodes the task's priority.
class TaskTile extends StatefulWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onToggleSubtask,
  });

  final Task task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onTap;

  /// Ticks/unticks the subtask at the given index (inline, no editor).
  final ValueChanged<int> onToggleSubtask;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final task = widget.task;
    final reminder = task.reminderAt;
    final overdue =
        reminder != null && !task.isComplete && reminder.isBefore(DateTime.now());
    final accent = task.isComplete ? null : task.priority.color;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: accent ?? Colors.transparent,
              width: accent == null ? 0 : 4,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: widget.onTap,
              child: Padding(
                padding: EdgeInsets.fromLTRB(accent == null ? 14 : 10, 10, 8, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _CircleCheckbox(
                      value: task.isComplete,
                      color: accent ?? scheme.primary,
                      onChanged: widget.onToggle,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            task.title,
                            style: task.isComplete
                                ? theme.textTheme.bodyLarge?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: scheme.outline,
                                  )
                                : theme.textTheme.bodyLarge,
                          ),
                          ..._buildMeta(theme, reminder, overdue),
                        ],
                      ),
                    ),
                    if (task.hasSubtasks)
                      IconButton(
                        tooltip: _expanded ? 'Hide subtasks' : 'Show subtasks',
                        visualDensity: VisualDensity.compact,
                        icon: AnimatedRotation(
                          turns: _expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(Icons.expand_more),
                        ),
                        onPressed: () => setState(() => _expanded = !_expanded),
                      ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: (_expanded && task.hasSubtasks)
                  ? _buildSubtaskList(theme)
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  /// Meta lines under the title: a reminder chip line and a subtask progress
  /// row. Each is prefixed with a small spacer so it doesn't hug the title.
  List<Widget> _buildMeta(ThemeData theme, DateTime? reminder, bool overdue) {
    final task = widget.task;
    final muted = theme.colorScheme.outline;
    final lines = <Widget>[];

    if (reminder != null) {
      final color = overdue ? theme.colorScheme.error : muted;
      lines.add(Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Icon(overdue ? Icons.alarm : Icons.alarm_outlined,
                size: 14, color: color),
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
        ),
      ));
    }

    if (task.hasSubtasks) {
      final done = task.completedSubtasks;
      final total = task.subtasks.length;
      final complete = done == total;
      lines.add(Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            Icon(complete ? Icons.check_circle : Icons.checklist,
                size: 14,
                color: complete ? theme.colorScheme.primary : muted),
            const SizedBox(width: 5),
            Text('$done/$total',
                style: theme.textTheme.labelSmall?.copyWith(color: muted)),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : done / total,
                  minHeight: 5,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
          ],
        ),
      ));
    }

    return lines;
  }

  Widget _buildSubtaskList(ThemeData theme) {
    final task = widget.task;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 8),
          for (var i = 0; i < task.subtasks.length; i++)
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => widget.onToggleSubtask(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    _CircleCheckbox(
                      value: task.subtasks[i].isComplete,
                      color: theme.colorScheme.primary,
                      size: 20,
                      onChanged: (_) => widget.onToggleSubtask(i),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task.subtasks[i].title,
                        style: task.subtasks[i].isComplete
                            ? theme.textTheme.bodyMedium?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: theme.colorScheme.outline,
                              )
                            : theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A compact, animated circular checkbox that fills with [color] when checked.
/// Nicer and more tactile than the stock square [Checkbox].
class _CircleCheckbox extends StatelessWidget {
  const _CircleCheckbox({
    required this.value,
    required this.color,
    required this.onChanged,
    this.size = 26,
  });

  final bool value;
  final Color color;
  final ValueChanged<bool?> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? color : Colors.transparent,
          border: Border.all(
            color: value ? color : scheme.outline,
            width: 2,
          ),
        ),
        child: value
            ? Icon(Icons.check, size: size * 0.62, color: scheme.onPrimary)
            : null,
      ),
    );
  }
}
