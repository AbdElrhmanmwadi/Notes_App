import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../controllers/notes_controller.dart';
import '../../core/app_paths.dart';
import '../../core/theme/note_background.dart';
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
  String? _background;
  late bool _isPinned;
  late List<String> _tags;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _bodyController = TextEditingController(text: widget.note?.body ?? '');
    _background = widget.note?.background;
    _isPinned = widget.note?.isPinned ?? false;
    _tags = List<String>.from(widget.note?.tags ?? const []);
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
        _background != note.background ||
        _isPinned != note.isPinned ||
        !listEquals(_tags, note.tags);
  }

  Future<void> _persist() async {
    if (!_hasChanges) return;
    final base = widget.note ?? const Note(title: '', body: '', updatedAt: '');
    await Get.find<NotesController>().save(
      base.copyWith(
        title: _titleController.text,
        body: _bodyController.text,
        background: _background,
        clearBackground: _background == null,
        isPinned: _isPinned,
        tags: _tags,
      ),
    );
  }

  Future<void> _pickPhoto() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;
      final fileName = 'bg_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(picked.path).copy(AppPaths.backgroundFile(fileName));
      if (!mounted) return;
      setState(() => _background = 'img:$fileName');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't load that image")),
        );
      }
    }
  }

  void _showBackgroundPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Colours', style: theme.textTheme.titleSmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _Swatch(
                      selected: _background == null,
                      onTap: () => _select(sheetContext, null),
                      child: Icon(Icons.format_color_reset,
                          size: 20, color: theme.colorScheme.outline),
                    ),
                    for (final color in NoteBackground.solidColors)
                      _Swatch(
                        color: color,
                        selected:
                            _background == NoteBackground.solid(color).token,
                        onTap: () => _select(
                            sheetContext, NoteBackground.solid(color).token),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Gradients', style: theme.textTheme.titleSmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final g in NoteBackground.gradients)
                      _Swatch(
                        gradient: g.gradient,
                        selected:
                            _background == NoteBackground.gradient(g).token,
                        onTap: () => _select(
                            sheetContext, NoteBackground.gradient(g).token),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      _pickPhoto();
                    },
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Choose photo from gallery'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _select(BuildContext sheetContext, String? token) {
    setState(() => _background = token);
    Navigator.of(sheetContext).pop();
  }

  Future<void> _addTag() async {
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add tag'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.none,
          decoration: const InputDecoration(hintText: 'e.g. work, ideas'),
          onSubmitted: (v) => Navigator.of(dialogContext).pop(v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null) return;
    final merged = Note.sanitizeTags([..._tags, value]);
    if (!listEquals(merged, _tags)) setState(() => _tags = merged);
  }

  void _removeTag(String tag) {
    setState(() => _tags = _tags.where((t) => t != tag).toList());
  }

  Widget _buildTagsSection(Color onColor, Color hintColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final tag in _tags)
            Chip(
              label: Text(tag),
              labelStyle: TextStyle(color: onColor),
              backgroundColor: onColor.withValues(alpha: 0.12),
              side: BorderSide(color: onColor.withValues(alpha: 0.24)),
              deleteIconColor: onColor,
              onDeleted: () => _removeTag(tag),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ActionChip(
            avatar: Icon(Icons.add, size: 18, color: onColor),
            label: Text('Tag', style: TextStyle(color: onColor)),
            backgroundColor: Colors.transparent,
            side: BorderSide(color: hintColor),
            onPressed: _addTag,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bg = NoteBackground.fromToken(_background);

    final onColor = bg.primaryText(scheme, theme.brightness);
    final hintColor = bg.tertiaryText(scheme, theme.brightness);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _persist();
      },
      child: DecoratedBox(
        decoration: bg.decoration(scheme, radius: 0),
        child: Stack(
          children: [
            if (bg.needsScrim)
              Positioned.fill(
                child: ColoredBox(color: Colors.black.withValues(alpha: 0.4)),
              ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: onColor,
                iconTheme: IconThemeData(color: onColor),
                title: Text(
                  widget.note == null ? 'New note' : 'Edit note',
                  style: TextStyle(color: onColor),
                ),
                actions: [
                  IconButton(
                    tooltip: _isPinned ? 'Unpin' : 'Pin',
                    color: onColor,
                    icon: Icon(
                        _isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                    onPressed: () => setState(() => _isPinned = !_isPinned),
                  ),
                  IconButton(
                    tooltip: 'Background',
                    color: onColor,
                    icon: const Icon(Icons.wallpaper_outlined),
                    onPressed: _showBackgroundPicker,
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
                        cursorColor: onColor,
                        style: theme.textTheme.headlineSmall?.copyWith(
                            color: onColor, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: theme.textTheme.headlineSmall
                              ?.copyWith(color: hintColor),
                          filled: false,
                          border: InputBorder.none,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          DateFormat('MMM d, h:mm a').format(DateTime.now()),
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: hintColor),
                        ),
                      ),
                      TextField(
                        controller: _bodyController,
                        maxLines: null,
                        minLines: 10,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        cursorColor: onColor,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: onColor, height: 1.4),
                        decoration: InputDecoration(
                          hintText: 'Start typing…',
                          hintStyle: theme.textTheme.bodyLarge
                              ?.copyWith(color: hintColor),
                          filled: false,
                          border: InputBorder.none,
                        ),
                      ),
                      _buildTagsSection(onColor, hintColor),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A circular selectable swatch used in the background picker. Renders a solid
/// colour, a gradient, or a custom child (e.g. the "none" icon).
class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.selected,
    required this.onTap,
    this.color,
    this.gradient,
    this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Color? color;
  final Gradient? gradient;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: gradient == null
              ? (color ?? scheme.surfaceContainerHighest)
              : null,
          gradient: gradient,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
            width: selected ? 3 : 1,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, size: 22, color: Colors.black87)
            : child,
      ),
    );
  }
}
