import 'package:flutter/material.dart';

import '../../../core/theme/note_background.dart';
import '../../../models/note.dart';

/// Single note tile used inside the masonry grid. Renders any background
/// (colour / gradient / photo) and picks text colours that stay legible.
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
    final scheme = theme.colorScheme;
    final bg = NoteBackground.fromToken(note.background);

    final primary = bg.primaryText(scheme, theme.brightness);
    final secondary = bg.secondaryText(scheme, theme.brightness);
    final tertiary = bg.tertiaryText(scheme, theme.brightness);

    return DecoratedBox(
      decoration: bg.decoration(scheme).copyWith(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.32 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            if (bg.needsScrim)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        Colors.black.withValues(alpha: 0.55),
                      ],
                    ),
                  ),
                ),
              ),
            Material(
              type: MaterialType.transparency,
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
                          padding: const EdgeInsets.only(bottom: 8),
                          child:
                              Icon(Icons.push_pin, size: 16, color: secondary),
                        ),
                      if (note.title.trim().isNotEmpty) ...[
                        Text(
                          note.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (note.body.trim().isNotEmpty)
                        Text(
                          note.body,
                          maxLines: 7,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: secondary, height: 1.35),
                        ),
                      if (note.tags.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final tag in note.tags)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: secondary.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: theme.textTheme.labelSmall
                                      ?.copyWith(color: secondary),
                                ),
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 14),
                      Text(
                        note.displayDate,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: tertiary),
                      ),
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
