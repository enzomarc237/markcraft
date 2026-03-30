import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../widgets/split_pane.dart';
import '../sidebar/sidebar_widget.dart';
import '../editor/editor_pane.dart';
import '../editor/preview_pane.dart';
import '../command_palette/command_palette_overlay.dart';
import '../../widgets/title_bar.dart';
import '../../../../core/utils/keyboard_shortcuts.dart';

/// The main 3-pane editor screen.
class MainEditorScreen extends ConsumerWidget {
  const MainEditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorMode = ref.watch(editorModeProvider);
    final sidebarVisible = ref.watch(sidebarVisibleProvider);
    final commandPaletteVisible = ref.watch(commandPaletteVisibleProvider);
    final zenMode = ref.watch(zenModeProvider);

    return Shortcuts(
      shortcuts: {
        KeyboardShortcuts.cmdK: const _ToggleCommandPaletteIntent(),
        KeyboardShortcuts.cmdShiftN: const _QuickCaptureIntent(),
        KeyboardShortcuts.cmdE: const _ToggleEditorModeIntent(),
        KeyboardShortcuts.cmdSlash: const _ToggleSidebarIntent(),
        KeyboardShortcuts.cmdF: const _FocusSearchIntent(),
      },
      child: Actions(
        actions: {
          _ToggleCommandPaletteIntent: CallbackAction<_ToggleCommandPaletteIntent>(
            onInvoke: (_) {
              ref.read(commandPaletteVisibleProvider.notifier).state =
                  !ref.read(commandPaletteVisibleProvider);
              return null;
            },
          ),
          _ToggleSidebarIntent: CallbackAction<_ToggleSidebarIntent>(
            onInvoke: (_) {
              ref.read(sidebarVisibleProvider.notifier).state =
                  !ref.read(sidebarVisibleProvider);
              return null;
            },
          ),
          _ToggleEditorModeIntent: CallbackAction<_ToggleEditorModeIntent>(
            onInvoke: (_) {
              final current = ref.read(editorModeProvider);
              EditorMode next;
              switch (current) {
                case EditorMode.split:
                  next = EditorMode.editorOnly;
                  break;
                case EditorMode.editorOnly:
                  next = EditorMode.previewOnly;
                  break;
                case EditorMode.previewOnly:
                  next = EditorMode.split;
                  break;
  
              }
              ref.read(editorModeProvider.notifier).state = next;
              return null;
            },
          ),
          _QuickCaptureIntent: CallbackAction<_QuickCaptureIntent>(
            onInvoke: (_) {
              // TODO: Show quick capture window
              return null;
            },
          ),
          _FocusSearchIntent: CallbackAction<_FocusSearchIntent>(
            onInvoke: (_) {
              ref.read(commandPaletteVisibleProvider.notifier).state = true;
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Stack(
            children: [
              _MainLayout(
                editorMode: editorMode,
                sidebarVisible: sidebarVisible && !zenMode,
                zenMode: zenMode,
              ),
              if (commandPaletteVisible) const CommandPaletteOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainLayout extends ConsumerWidget {
  const _MainLayout({
    required this.editorMode,
    required this.sidebarVisible,
    required this.zenMode,
  });

  final EditorMode editorMode;
  final bool sidebarVisible;
  final bool zenMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidebarWidth = ref.watch(sidebarWidthProvider);

    return Column(
      children: [
        // Custom title bar
        const AppTitleBar(),
        // Main content
        Expanded(
          child: Row(
            children: [
              // Sidebar
              if (sidebarVisible) ...[
                SizedBox(
                  width: sidebarWidth,
                  child: const SidebarWidget(),
                ),
                _VerticalDivider(
                  onDragUpdate: (dx) {
                    final newWidth = (sidebarWidth + dx).clamp(
                      180.0,
                      400.0,
                    );
                    ref.read(sidebarWidthProvider.notifier).state = newWidth;
                  },
                ),
              ],
              // Editor / Preview area
              Expanded(
                child: _EditorArea(editorMode: editorMode, zenMode: zenMode),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditorArea extends ConsumerWidget {
  const _EditorArea({
    required this.editorMode,
    required this.zenMode,
  });

  final EditorMode editorMode;
  final bool zenMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeNoteAsync = ref.watch(activeNoteProvider);
    final hasNote = activeNoteAsync.valueOrNull != null;

    if (!hasNote) {
      return const _EmptyEditorState();
    }

    if (zenMode) {
      return const _ZenModeLayout();
    }

    switch (editorMode) {
      case EditorMode.split:
        return const SplitPane(
          left: EditorPane(),
          right: PreviewPane(),
        );
      case EditorMode.editorOnly:
        return const EditorPane();
      case EditorMode.previewOnly:
        return const PreviewPane();

    }
  }
}

class _ZenModeLayout extends StatelessWidget {
  const _ZenModeLayout();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 750,
        child: EditorPane(isZenMode: true),
      ),
    );
  }
}

class _EmptyEditorState extends StatelessWidget {
  const _EmptyEditorState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.edit_note,
            size: 64,
            color: theme.colorScheme.onBackground.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a note to start editing',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cmd+K to search • Cmd+N to create',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.25),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({required this.onDragUpdate});
  final void Function(double dx) onDragUpdate;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) => onDragUpdate(details.delta.dx),
        child: Container(
          width: 4,
          color: Theme.of(context).dividerColor,
        ),
      ),
    );
  }
}

// --- Intent classes ---

class _ToggleCommandPaletteIntent extends Intent {
  const _ToggleCommandPaletteIntent();
}

class _QuickCaptureIntent extends Intent {
  const _QuickCaptureIntent();
}

class _ToggleEditorModeIntent extends Intent {
  const _ToggleEditorModeIntent();
}

class _ToggleSidebarIntent extends Intent {
  const _ToggleSidebarIntent();
}

class _FocusSearchIntent extends Intent {
  const _FocusSearchIntent();
}
