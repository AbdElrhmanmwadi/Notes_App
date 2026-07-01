import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/subtask.dart';
import '../../../models/task_priority.dart';
import '../../../models/task_recurrence.dart';

/// The fields a task editor returns on save.
class TaskDraft {
  const TaskDraft(
      this.title, this.reminderAt, this.priority, this.recurrence, this.subtasks);

  final String title;
  final DateTime? reminderAt;
  final TaskPriority priority;
  final Recurrence recurrence;
  final List<Subtask> subtasks;
}

/// Bottom sheet for creating or editing a task: title, optional reminder (with
/// recurrence), priority and a subtask checklist. The "Save" button stays
/// disabled until the title is non-empty.
class TaskEditorSheet extends StatefulWidget {
  const TaskEditorSheet({
    super.key,
    required this.onSubmit,
    this.initialValue = '',
    this.initialReminder,
    this.initialPriority = TaskPriority.none,
    this.initialRecurrence = Recurrence.none,
    this.initialSubtasks = const [],
    this.hint = 'Enter a task',
  });

  /// Called with the assembled [TaskDraft].
  final Future<void> Function(TaskDraft draft) onSubmit;
  final String initialValue;
  final DateTime? initialReminder;
  final TaskPriority initialPriority;
  final Recurrence initialRecurrence;
  final List<Subtask> initialSubtasks;
  final String hint;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  late final TextEditingController _controller;
  late final TextEditingController _subtaskController;
  DateTime? _reminder;
  late TaskPriority _priority;
  late Recurrence _recurrence;
  late List<Subtask> _subtasks;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _subtaskController = TextEditingController();
    _reminder = widget.initialReminder;
    _priority = widget.initialPriority;
    _recurrence = widget.initialRecurrence;
    _subtasks = List<Subtask>.from(widget.initialSubtasks);
  }

  @override
  void dispose() {
    _controller.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  void _addSubtask() {
    final text = _subtaskController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _subtasks = [..._subtasks, Subtask(title: text)];
      _subtaskController.clear();
    });
  }

  void _toggleSubtask(int index) {
    setState(() {
      _subtasks = [..._subtasks];
      _subtasks[index] =
          _subtasks[index].copyWith(isComplete: !_subtasks[index].isComplete);
    });
  }

  void _removeSubtask(int index) {
    setState(() => _subtasks = [..._subtasks]..removeAt(index));
  }

  Widget _buildSubtasks(ThemeData theme) {
    final scheme = theme.colorScheme;
    final done = _subtasks.where((s) => s.isComplete).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.checklist_rounded, size: 18, color: scheme.primary),
            const SizedBox(width: 8),
            Text(
              _subtasks.isEmpty
                  ? 'Subtasks'
                  : 'Subtasks · $done/${_subtasks.length}',
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        for (var i = 0; i < _subtasks.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              children: [
                _MiniCircleCheck(
                  value: _subtasks[i].isComplete,
                  color: scheme.primary,
                  onTap: () => _toggleSubtask(i),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _subtasks[i].title,
                    style: _subtasks[i].isComplete
                        ? theme.textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: scheme.outline,
                          )
                        : theme.textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: scheme.outline,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _removeSubtask(i),
                ),
              ],
            ),
          ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.only(left: 12, right: 4),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(Icons.add, size: 20, color: scheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _subtaskController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addSubtask(),
                  decoration: const InputDecoration(
                    hintText: 'Add a subtask…',
                    filled: false,
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickReminder() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _reminder ?? now.add(const Duration(hours: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          _reminder ?? now.add(const Duration(hours: 1))),
    );
    if (time == null) return;

    setState(() {
      _reminder =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSave = _controller.text.trim().isNotEmpty;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _controller,
                        autofocus: true,
                        maxLines: 4,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (_) => setState(() {}),
                        style: theme.textTheme.titleMedium,
                        decoration: InputDecoration(
                          hintText: widget.hint,
                          filled: false,
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _reminder == null
                            ? TextButton.icon(
                                onPressed: _pickReminder,
                                icon: const Icon(Icons.alarm_add_outlined),
                                label: const Text('Set reminder'),
                              )
                            : InputChip(
                                avatar: const Icon(Icons.alarm, size: 18),
                                label: Text(DateFormat('MMM d, h:mm a')
                                    .format(_reminder!)),
                                onPressed: _pickReminder,
                                onDeleted: () =>
                                    setState(() => _reminder = null),
                              ),
                      ),
                      if (_reminder != null) ...[
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          children: [
                            for (final r in Recurrence.values)
                              ChoiceChip(
                                label: Text(r.label),
                                selected: _recurrence == r,
                                onSelected: (_) =>
                                    setState(() => _recurrence = r),
                                avatar: r.isSet
                                    ? const Icon(Icons.repeat, size: 16)
                                    : null,
                                visualDensity: VisualDensity.compact,
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final p in TaskPriority.values)
                            ChoiceChip(
                              label: Text(
                                  p == TaskPriority.none ? 'No priority' : p.label),
                              selected: _priority == p,
                              onSelected: (_) => setState(() => _priority = p),
                              avatar: p.color == null
                                  ? null
                                  : Icon(Icons.flag, size: 16, color: p.color),
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                      _buildSubtasks(theme),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: Get.back, child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: canSave
                        ? () async {
                            await widget.onSubmit(TaskDraft(
                              _controller.text,
                              _reminder,
                              _priority,
                              _reminder == null
                                  ? Recurrence.none
                                  : _recurrence,
                              _subtasks,
                            ));
                            Get.back();
                          }
                        : null,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small circular checkbox used in the editor's subtask list, matching the
/// tactile style used on the task cards.
class _MiniCircleCheck extends StatelessWidget {
  const _MiniCircleCheck({
    required this.value,
    required this.color,
    required this.onTap,
  });

  final bool value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? color : Colors.transparent,
          border: Border.all(
            color: value ? color : scheme.outline,
            width: 2,
          ),
        ),
        child: value
            ? Icon(Icons.check, size: 14, color: scheme.onPrimary)
            : null,
      ),
    );
  }
}
