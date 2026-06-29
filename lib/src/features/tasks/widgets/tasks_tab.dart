import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/empty_state.dart';
import '../../../common/widgets/loading_indicator.dart';
import '../../../controllers/tasks_controller.dart';
import '../../../models/task.dart';
import 'task_editor_sheet.dart';
import 'task_tile.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  void _edit(TasksController controller, Task task) {
    Get.bottomSheet(
      TaskEditorSheet(
        initialValue: task.title,
        initialReminder: task.reminderAt,
        initialPriority: task.priority,
        initialRecurrence: task.recurrence,
        initialSubtasks: task.subtasks,
        hint: 'Edit task',
        onSubmit: (draft) => controller.edit(
          task,
          title: draft.title,
          reminderAt: draft.reminderAt,
          priority: draft.priority,
          recurrence: draft.recurrence,
          subtasks: draft.subtasks,
          clearReminder: draft.reminderAt == null,
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _deleteWithUndo(
      BuildContext context, TasksController controller, Task task) {
    controller.delete(task.id!);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Task deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => controller.restore(task),
          ),
        ),
      );
  }

  Widget _dismissibleTile(
      BuildContext context, TasksController controller, Task task) {
    return Dismissible(
      key: ValueKey('task_${task.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteWithUndo(context, controller, task),
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline,
            color: Theme.of(context).colorScheme.onErrorContainer),
      ),
      child: TaskTile(
        task: task,
        onToggle: (_) => controller.toggleComplete(task),
        onTap: () => _edit(controller, task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TasksController>();
    final theme = Theme.of(context);

    return Obx(() {
      if (controller.isLoading.value) return const LoadingIndicator();

      final active = controller.activeTasks;
      final completed = controller.completedTasks;

      if (active.isEmpty && completed.isEmpty) {
        return const EmptyState(
          icon: Icons.check_box_outlined,
          message: 'No tasks yet.\nTap + to add one.',
        );
      }

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          ...active.map((t) => _dismissibleTile(context, controller, t)),
          if (completed.isNotEmpty) ...[
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(controller.showCompleted.value
                  ? Icons.expand_more
                  : Icons.chevron_right),
              title: Text('Completed (${completed.length})',
                  style: theme.textTheme.titleSmall),
              onTap: controller.showCompleted.toggle,
            ),
            if (controller.showCompleted.value)
              ...completed.map((t) => _dismissibleTile(context, controller, t)),
          ],
        ],
      );
    });
  }
}
