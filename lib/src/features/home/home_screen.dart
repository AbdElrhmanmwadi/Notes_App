import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/tasks_controller.dart';
import '../notes/note_editor_screen.dart';
import '../notes/widgets/notes_tab.dart';
import '../settings/settings_screen.dart';
import '../tasks/widgets/task_editor_sheet.dart';
import '../tasks/widgets/tasks_tab.dart';

/// Root screen hosting the Notes and Tasks tabs. Kept stateful so the FAB can
/// react to the active tab without rebuilding the whole tree.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _isNotesTab => _tabController.index == 0;

  void _onFabPressed() {
    if (_isNotesTab) {
      Get.to(() => const NoteEditorScreen());
    } else {
      final tasks = Get.find<TasksController>();
      Get.bottomSheet(
        TaskEditorSheet(
          hint: 'Enter a task to save',
          onSubmit: (value, reminderAt, priority) =>
              tasks.add(value, reminderAt: reminderAt, priority: priority),
        ),
        isScrollControlled: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text(
          'Notes',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Get.to(() => const SettingsScreen()),
          ),
          const SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(icon: Icon(Icons.sticky_note_2_outlined), text: 'Notes'),
            Tab(icon: Icon(Icons.task_alt_outlined), text: 'Tasks'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFabPressed,
        icon: const Icon(Icons.add),
        label: Text(_isNotesTab ? 'New note' : 'New task'),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [NotesTab(), TasksTab()],
      ),
    );
  }
}
