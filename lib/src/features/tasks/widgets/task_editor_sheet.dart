import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Bottom sheet for creating or editing a task, including an optional reminder.
/// The "Save" button stays disabled until the field is non-empty.
class TaskEditorSheet extends StatefulWidget {
  const TaskEditorSheet({
    super.key,
    required this.onSubmit,
    this.initialValue = '',
    this.initialReminder,
    this.hint = 'Enter a task',
  });

  /// Called with the trimmed text and the chosen reminder (or null).
  final Future<void> Function(String value, DateTime? reminderAt) onSubmit;
  final String initialValue;
  final DateTime? initialReminder;
  final String hint;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  late final TextEditingController _controller;
  DateTime? _reminder;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _reminder = widget.initialReminder;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                      label:
                          Text(DateFormat('MMM d, h:mm a').format(_reminder!)),
                      onPressed: _pickReminder,
                      onDeleted: () => setState(() => _reminder = null),
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
                          await widget.onSubmit(_controller.text, _reminder);
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
    );
  }
}
