import 'package:flutter/material.dart';

/// Search input for the notes list, with a clear button that appears once the
/// user has typed something.
class NotesSearchField extends StatefulWidget {
  const NotesSearchField({
    super.key,
    required this.onChanged,
    this.hintText = 'Search notes',
  });

  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  State<NotesSearchField> createState() => _NotesSearchFieldState();
}

class _NotesSearchFieldState extends State<NotesSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    widget.onChanged(value);
    setState(() {}); // refresh the clear-button visibility
  }

  void _clear() {
    _controller.clear();
    _handleChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _handleChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close, size: 20),
                tooltip: 'Clear',
                onPressed: _clear,
              ),
      ),
    );
  }
}
