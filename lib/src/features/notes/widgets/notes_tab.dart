import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../common/widgets/empty_state.dart';
import '../../../common/widgets/loading_indicator.dart';
import '../../../controllers/notes_controller.dart';
import '../../../models/note.dart';
import '../note_editor_screen.dart';
import 'note_card.dart';
import 'notes_search_field.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  void _showActions(
      BuildContext context, NotesController controller, Note note) {
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
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _deleteWithUndo(context, controller, note);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteWithUndo(
      BuildContext context, NotesController controller, Note note) {
    controller.delete(note.id!);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Note deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => controller.restore(note),
          ),
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
          NotesSearchField(onChanged: (v) => controller.query.value = v),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const LoadingIndicator();

              final notes = controller.notes;
              if (notes.isEmpty) {
                return EmptyState(
                  icon: Icons.note_alt_outlined,
                  message: controller.query.value.isEmpty
                      ? 'No notes yet.\nTap + to create one.'
                      : 'No notes match your search.',
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
                  return NoteCard(
                    note: note,
                    onTap: () => Get.to(() => NoteEditorScreen(note: note)),
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
}
