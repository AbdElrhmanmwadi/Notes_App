import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../common/widgets/empty_state.dart';
import '../../../common/widgets/loading_indicator.dart';
import '../../../controllers/notes_controller.dart';
import '../../../models/note.dart';
import '../../../models/note_query.dart';
import '../note_editor_screen.dart';
import 'note_card.dart';
import 'notes_search_field.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  /// Long-press menu. The available actions depend on which shelf the note
  /// lives on.
  void _showActions(
      BuildContext context, NotesController controller, Note note) {
    final scope = controller.scope.value;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (scope == NoteScope.trash) ...[
              ListTile(
                leading: const Icon(Icons.restore_from_trash_outlined),
                title: const Text('Restore'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  controller.restoreFromTrash(note);
                  _toast(context, 'Note restored');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever_outlined),
                title: const Text('Delete forever'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _confirmDeleteForever(context, controller, note);
                },
              ),
            ] else ...[
              ListTile(
                leading: Icon(
                    note.isPinned ? Icons.push_pin_outlined : Icons.push_pin),
                title: Text(note.isPinned ? 'Unpin' : 'Pin'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  controller.togglePin(note);
                },
              ),
              ListTile(
                leading: Icon(scope == NoteScope.archived
                    ? Icons.unarchive_outlined
                    : Icons.archive_outlined),
                title: Text(scope == NoteScope.archived ? 'Unarchive' : 'Archive'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _archiveWithUndo(context, controller, note,
                      archived: scope != NoteScope.archived);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _trashWithUndo(context, controller, note);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _archiveWithUndo(
    BuildContext context,
    NotesController controller,
    Note note, {
    required bool archived,
  }) {
    controller.setArchived(note, archived);
    _toast(
      context,
      archived ? 'Note archived' : 'Note unarchived',
      undoLabel: 'Undo',
      onUndo: () => controller.setArchived(note, !archived),
    );
  }

  void _trashWithUndo(
      BuildContext context, NotesController controller, Note note) {
    controller.moveToTrash(note);
    _toast(
      context,
      'Note moved to trash',
      undoLabel: 'Undo',
      onUndo: () => controller.restoreFromTrash(note),
    );
  }

  Future<void> _confirmDeleteForever(
      BuildContext context, NotesController controller, Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete forever?'),
        content: const Text(
            'This note will be permanently deleted. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) controller.deleteForever(note.id!);
  }

  void _toast(BuildContext context, String message,
      {String? undoLabel, VoidCallback? onUndo}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: (undoLabel != null && onUndo != null)
              ? SnackBarAction(label: undoLabel, onPressed: onUndo)
              : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotesController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _NotesToolbar(controller: controller),
          const SizedBox(height: 12),
          NotesSearchField(onChanged: (v) => controller.query.value = v),
          _TagFilterBar(controller: controller),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const LoadingIndicator();

              final scope = controller.scope.value;
              final notes = controller.notes;
              if (notes.isEmpty) {
                return EmptyState(
                  icon: _emptyIcon(scope),
                  message: _emptyMessage(scope, controller.query.value),
                );
              }

              return MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                padding: const EdgeInsets.only(bottom: 96),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  final inTrash = scope == NoteScope.trash;
                  return NoteCard(
                    note: note,
                    // Trashed notes aren't editable — tapping shows the
                    // restore/delete actions instead of the editor.
                    onTap: inTrash
                        ? () => _showActions(context, controller, note)
                        : () => Get.to(() => NoteEditorScreen(note: note)),
                    onLongPress: () => _showActions(context, controller, note),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  IconData _emptyIcon(NoteScope scope) => switch (scope) {
        NoteScope.active => Icons.note_alt_outlined,
        NoteScope.archived => Icons.archive_outlined,
        NoteScope.trash => Icons.delete_outline,
      };

  String _emptyMessage(NoteScope scope, String query) {
    if (query.isNotEmpty) return 'No notes match your search.';
    return switch (scope) {
      NoteScope.active => 'No notes yet.\nTap + to create one.',
      NoteScope.archived => 'No archived notes.',
      NoteScope.trash => 'Trash is empty.',
    };
  }
}

/// Toolbar above the search field: a shelf switcher (Notes / Archive / Trash)
/// on the left, and a sort menu (or the empty-trash action) on the right.
class _NotesToolbar extends StatelessWidget {
  const _NotesToolbar({required this.controller});

  final NotesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final scope = controller.scope.value;
      return Row(
        children: [
          PopupMenuButton<NoteScope>(
            initialValue: scope,
            onSelected: (value) => controller.scope.value = value,
            tooltip: 'Switch shelf',
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              for (final option in NoteScope.values)
                PopupMenuItem(
                  value: option,
                  child: Row(
                    children: [
                      Icon(_scopeIcon(option), size: 20),
                      const SizedBox(width: 12),
                      Text(option.label),
                    ],
                  ),
                ),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_scopeIcon(scope), size: 20),
                const SizedBox(width: 8),
                Text(
                  scope.label,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          const Spacer(),
          if (scope == NoteScope.trash)
            TextButton.icon(
              onPressed: controller.notes.isEmpty
                  ? null
                  : () => _confirmEmptyTrash(context),
              icon: const Icon(Icons.delete_sweep_outlined, size: 20),
              label: const Text('Empty'),
            )
          else
            PopupMenuButton<NoteSort>(
              initialValue: controller.sort.value,
              onSelected: (value) => controller.sort.value = value,
              tooltip: 'Sort',
              position: PopupMenuPosition.under,
              icon: const Icon(Icons.sort),
              itemBuilder: (context) => [
                for (final option in NoteSort.values)
                  PopupMenuItem(value: option, child: Text(option.label)),
              ],
            ),
        ],
      );
    });
  }

  Future<void> _confirmEmptyTrash(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Empty trash?'),
        content: const Text(
            'All notes in the trash will be permanently deleted. This cannot '
            'be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Empty trash'),
          ),
        ],
      ),
    );
    if (confirmed == true) controller.emptyTrash();
  }

  IconData _scopeIcon(NoteScope scope) => switch (scope) {
        NoteScope.active => Icons.sticky_note_2_outlined,
        NoteScope.archived => Icons.archive_outlined,
        NoteScope.trash => Icons.delete_outline,
      };
}

/// Horizontal row of selectable tag chips. Hidden entirely when no note has a
/// tag. Tapping a chip filters the grid; tapping the active chip clears it.
class _TagFilterBar extends StatelessWidget {
  const _TagFilterBar({required this.controller});

  final NotesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tags = controller.allTags;
      if (tags.isEmpty) return const SizedBox.shrink();
      final selected = controller.tagFilter.value;

      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tags.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final tag = tags[index];
              final isSelected = tag == selected;
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (_) =>
                    controller.tagFilter.value = isSelected ? null : tag,
                visualDensity: VisualDensity.compact,
              );
            },
          ),
        ),
      );
    });
  }
}
