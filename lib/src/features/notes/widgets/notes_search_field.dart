import 'package:flutter/material.dart';

/// Search input for the notes list. Stateless — it simply forwards changes.
class NotesSearchField extends StatelessWidget {
  const NotesSearchField({
    super.key,
    required this.onChanged,
    this.hintText = 'Search notes',
  });

  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search, size: 20),
      ),
    );
  }
}
