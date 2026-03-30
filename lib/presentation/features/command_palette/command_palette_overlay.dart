import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzy/fuzzy.dart';

import '../../providers/app_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/note.dart';

/// Command palette overlay (Cmd+K).
class CommandPaletteOverlay extends ConsumerStatefulWidget {
  const CommandPaletteOverlay({super.key});

  @override
  ConsumerState<CommandPaletteOverlay> createState() =>
      _CommandPaletteOverlayState();
}

class _CommandPaletteOverlayState
    extends ConsumerState<CommandPaletteOverlay> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;
  int _selectedIndex = 0;
  List<_PaletteItem> _items = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>();

    return GestureDetector(
      onTap: _dismiss,
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Align(
          alignment: const Alignment(0, -0.3),
          child: GestureDetector(
            onTap: () {}, // Prevent dismissal when tapping inside
            child: Container(
              width: 640,
              constraints: const BoxConstraints(maxHeight: 480),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
                border: Border.all(
                  color: theme.dividerColor,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search input
                  _SearchInput(
                    controller: _searchController,
                    focusNode: _focusNode,
                    onChanged: _onQueryChanged,
                    onKeyEvent: _handleKeyEvent,
                  ),
                  if (_items.isNotEmpty) ...[
                    const Divider(height: 1),
                    Flexible(
                      child: _ResultsList(
                        items: _items,
                        selectedIndex: _selectedIndex,
                        onSelect: _selectItem,
                      ),
                    ),
                  ],
                  if (_items.isEmpty && _searchController.text.isEmpty)
                    _EmptyState(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onQueryChanged(String query) async {
    final vault = ref.read(vaultProvider).valueOrNull;
    if (vault == null) return;

    final items = <_PaletteItem>[];

    if (query.isEmpty) {
      // Show actions when no query
      items.addAll(_defaultActions());
    } else {
      // Fuzzy search files
      final allFiles = await ref
          .read(fileSystemServiceProvider)
          .listMarkdownFiles(vault.path);

      final fileNames = allFiles
          .map((f) => f.replaceFirst('${vault.path}/', ''))
          .toList();

      final fuzzy = Fuzzy<String>(
        fileNames,
        options: FuzzyOptions(threshold: 0.6),
      );
      final results = fuzzy.search(query);

      for (final result in results.take(10)) {
        final fullPath = '${vault.path}/${result.item}';
        items.add(_PaletteItem(
          title: result.item.split('/').last.replaceAll('.md', ''),
          subtitle: result.item,
          icon: Icons.description_outlined,
          type: _PaletteItemType.file,
          onSelect: () async {
            await ref.read(activeNoteProvider.notifier).openNote(fullPath);
            _dismiss();
          },
        ));
      }

      // Add actions
      items.addAll(_filterActions(query));
    }

    setState(() {
      _items = items;
      _selectedIndex = 0;
    });
  }

  List<_PaletteItem> _defaultActions() => [
        _PaletteItem(
          title: 'Toggle Dark/Light Mode',
          subtitle: 'Switch between light and dark themes',
          icon: Icons.dark_mode_outlined,
          type: _PaletteItemType.action,
          onSelect: () {
            ref.read(themeModeProvider.notifier).toggleTheme();
            _dismiss();
          },
        ),
        _PaletteItem(
          title: 'Toggle Zen Mode',
          subtitle: 'Distraction-free writing',
          icon: Icons.fullscreen,
          type: _PaletteItemType.action,
          onSelect: () {
            ref.read(zenModeProvider.notifier).state =
                !ref.read(zenModeProvider);
            _dismiss();
          },
        ),
        _PaletteItem(
          title: 'New Note',
          subtitle: 'Create a new Markdown note',
          icon: Icons.add,
          type: _PaletteItemType.action,
          onSelect: _dismiss,
        ),
        _PaletteItem(
          title: 'Toggle Sidebar',
          subtitle: 'Show or hide the sidebar',
          icon: Icons.menu,
          type: _PaletteItemType.action,
          onSelect: () {
            ref.read(sidebarVisibleProvider.notifier).state =
                !ref.read(sidebarVisibleProvider);
            _dismiss();
          },
        ),
        _PaletteItem(
          title: 'Split View',
          subtitle: 'Toggle split editor/preview',
          icon: Icons.view_column_outlined,
          type: _PaletteItemType.action,
          onSelect: () {
            ref.read(editorModeProvider.notifier).state = EditorMode.split;
            _dismiss();
          },
        ),
      ];

  List<_PaletteItem> _filterActions(String query) {
    final actions = _defaultActions();
    final lowerQuery = query.toLowerCase();
    return actions
        .where((a) =>
            a.title.toLowerCase().contains(lowerQuery) ||
            (a.subtitle?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return false;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _dismiss();
      return true;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1).clamp(0, _items.length - 1);
      });
      return true;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _selectedIndex = (_selectedIndex - 1).clamp(0, _items.length - 1);
      });
      return true;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (_selectedIndex < _items.length) {
        _selectItem(_items[_selectedIndex]);
      }
      return true;
    }

    return false;
  }

  void _selectItem(_PaletteItem item) {
    item.onSelect();
  }

  void _dismiss() {
    ref.read(commandPaletteVisibleProvider.notifier).state = false;
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool Function(KeyEvent) onKeyEvent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: onKeyEvent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 20,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Search notes or type a command...',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            // Keyboard shortcut hint
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'ESC',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<_PaletteItem> items;
  final int selectedIndex;
  final void Function(_PaletteItem) onSelect;

  @override
  Widget build(BuildContext context) {
    final grouped = _groupItems(items);

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (final entry in grouped.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              entry.key,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          ...entry.value.map(
            (item) => _PaletteItemTile(
              item: item,
              isSelected: items.indexOf(item) == selectedIndex,
              onTap: () => onSelect(item),
            ),
          ),
        ],
      ],
    );
  }

  Map<String, List<_PaletteItem>> _groupItems(List<_PaletteItem> items) {
    final files = items.where((i) => i.type == _PaletteItemType.file).toList();
    final actions =
        items.where((i) => i.type == _PaletteItemType.action).toList();
    final result = <String, List<_PaletteItem>>{};
    if (files.isNotEmpty) result['Files'] = files;
    if (actions.isNotEmpty) result['Actions'] = actions;
    return result;
  }
}

class _PaletteItemTile extends StatelessWidget {
  const _PaletteItemTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _PaletteItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: isSelected
            ? theme.colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 16,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.search,
            size: 32,
            color: theme.colorScheme.onSurface.withOpacity(0.2),
          ),
          const SizedBox(height: 8),
          Text(
            'Type to search notes or execute commands',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

enum _PaletteItemType { file, action, recent }

class _PaletteItem {
  const _PaletteItem({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.type,
    required this.onSelect,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final _PaletteItemType type;
  final VoidCallback onSelect;
}
