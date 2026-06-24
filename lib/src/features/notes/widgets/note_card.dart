import 'package:flutter/material.dart';

import '../../../models/note.dart';

/// Single note tile used inside the masonry grid.
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onLongPress,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = note.color != null ? Color(note.color!) : null;
    // Note colours are light pastels; keep text dark on top of them.
    final onColor = bg != null ? Colors.black87 : theme.colorScheme.onSurface;

    return Card(
      color: bg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (note.isPinned)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Icon(Icons.push_pin,
                      size: 16, color: onColor.withValues(alpha: 0.6)),
                ),
              if (note.title.trim().isNotEmpty) ...[
                Text(
                  note.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(color: onColor),
                ),
                const SizedBox(height: 8),
              ],
              if (note.body.trim().isNotEmpty)
                Text(
                  note.body,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: onColor.withValues(alpha: 0.75)),
                ),
              const SizedBox(height: 12),
              Text(
                note.displayDate,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: onColor.withValues(alpha: 0.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
