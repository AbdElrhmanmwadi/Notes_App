import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/tasks_controller.dart';
import '../notes/note_editor_screen.dart';
import '../notes/widgets/notes_tab.dart';
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
          onSubmit: (value, reminderAt) =>
              tasks.add(value, reminderAt: reminderAt),
        ),
        isScrollControlled: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(icon: Icon(Icons.note_alt_outlined)),
            Tab(icon: Icon(Icons.check_box_outlined)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.add, size: 32),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [NotesTab(), TasksTab()],
      ),
    );
  }
}
