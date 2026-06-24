import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/notes_controller.dart';
import '../../core/theme/note_palette.dart';
import '../../models/note.dart';

/// Unified create/edit screen. Pass an existing [note] to edit, or omit it to
/// create a new one. Changes are persisted automatically when leaving.
class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, this.note});

  final Note? note;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late int? _color;
  late bool _isPinned;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _bodyController = TextEditingController(text: widget.note?.body ?? '');
    _color = widget.note?.color;
    _isPinned = widget.note?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    final note = widget.note;
    if (note == null) {
      return _titleController.text.trim().isNotEmpty ||
          _bodyController.text.trim().isNotEmpty;
    }
    return _titleController.text != note.title ||
        _bodyController.text != note.body ||
        _color != note.color ||
        _isPinned != note.isPinned;
  }

  Future<void> _persist() async {
    if (!_hasChanges) return;
    final base = widget.note ?? const Note(title: '', body: '', updatedAt: '');
    await Get.find<NotesController>().save(
      base.copyWith(
        title: _titleController.text,
        body: _bodyController.text,
        color: _color,
        clearColor: _color == null,
        isPinned: _isPinned,
      ),
    );
  }

  void _pickColor() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: WrapAlignment.center,
          children: [
            for (final color in NotePalette.colors)
              _ColorDot(
                color: color,
                selected: _color == color?.toARGB32(),
                onTap: () {
                  setState(() => _color = color?.toARGB32());
                  Navigator.of(sheetContext).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = _color != null ? Color(_color!) : theme.scaffoldBackgroundColor;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _persist();
      },
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          leading: const BackButton(),
          title: Text(widget.note == null ? 'New note' : 'Edit note'),
          actions: [
            IconButton(
              tooltip: _isPinned ? 'Unpin' : 'Pin',
              icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              onPressed: () => setState(() => _isPinned = !_isPinned),
            ),
            IconButton(
              tooltip: 'Colour',
              icon: const Icon(Icons.palette_outlined),
              onPressed: _pickColor,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: theme.textTheme.headlineSmall,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    filled: false,
                    border: InputBorder.none,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    DateFormat('MMM d, h:mm a').format(DateTime.now()),
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                ),
                TextField(
                  controller: _bodyController,
                  maxLines: null,
                  minLines: 8,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  style: theme.textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Start typing…',
                    filled: false,
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color? color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color ?? scheme.surfaceContainerHighest,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
            width: selected ? 3 : 1,
          ),
        ),
        child: color == null
            ? Icon(Icons.format_color_reset, size: 20, color: scheme.outline)
            : (selected
                ? const Icon(Icons.check, size: 20, color: Colors.black54)
                : null),
      ),
    );
  }
}
