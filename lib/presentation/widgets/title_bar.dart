import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/app_providers.dart';

/// Custom macOS-style title bar with traffic light buttons simulation.
class AppTitleBar extends ConsumerWidget {
  const AppTitleBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeNote = ref.watch(activeNoteProvider).valueOrNull;
    final editorMode = ref.watch(editorModeProvider);
    final zenMode = ref.watch(zenModeProvider);

    return GestureDetector(
      onPanStart: (_) => windowManager.startDragging(),
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(color: theme.dividerColor),
          ),
        ),
        child: Row(
          children: [
            // Padding for traffic lights (native macOS)
            const SizedBox(width: 72),
            // Sidebar toggle
            _TitleBarButton(
              tooltip: 'Toggle Sidebar',
              icon: Icons.view_sidebar_outlined,
              onTap: () {
                ref.read(sidebarVisibleProvider.notifier).state =
                    !ref.read(sidebarVisibleProvider);
              },
            ),
            const SizedBox(width: 4),
            // Note title
            Expanded(
              child: Center(
                child: Text(
                  activeNote?.name ?? 'MarkCraft',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // View mode toggle
            _ViewModeToggle(currentMode: editorMode),
            const SizedBox(width: 8),
            // Zen mode
            _TitleBarButton(
              tooltip: zenMode ? 'Exit Zen Mode' : 'Zen Mode',
              icon: zenMode ? Icons.fullscreen_exit : Icons.fullscreen,
              onTap: () {
                ref.read(zenModeProvider.notifier).state = !zenMode;
              },
            ),
            const SizedBox(width: 8),
            // Theme toggle
            _TitleBarButton(
              tooltip: 'Toggle Theme',
              icon: theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              onTap: () {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class _TitleBarButton extends StatelessWidget {
  const _TitleBarButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}

class _ViewModeToggle extends ConsumerWidget {
  const _ViewModeToggle({required this.currentMode});
  final EditorMode currentMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeButton(
            icon: Icons.edit_outlined,
            tooltip: 'Editor Only',
            isActive: currentMode == EditorMode.editorOnly,
            onTap: () => ref.read(editorModeProvider.notifier).state =
                EditorMode.editorOnly,
          ),
          _ModeButton(
            icon: Icons.view_column_outlined,
            tooltip: 'Split View',
            isActive: currentMode == EditorMode.split,
            onTap: () => ref.read(editorModeProvider.notifier).state =
                EditorMode.split,
          ),
          _ModeButton(
            icon: Icons.preview_outlined,
            tooltip: 'Preview Only',
            isActive: currentMode == EditorMode.previewOnly,
            onTap: () => ref.read(editorModeProvider.notifier).state =
                EditorMode.previewOnly,
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.icon,
    required this.tooltip,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
