import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../providers/app_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/folder.dart';
import '../../../../domain/entities/note.dart';
import '../../../../data/datasources/file_system/file_system_service.dart';

/// The left sidebar showing the file tree.
class SidebarWidget extends ConsumerWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>();
    final vaultAsync = ref.watch(vaultProvider);

    return Container(
      color: appColors?.sidebarBackground ?? theme.colorScheme.surface,
      child: Column(
        children: [
          _SidebarHeader(),
          const Divider(height: 1),
          Expanded(
            child: vaultAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (vault) {
                if (vault == null) return const SizedBox.shrink();

                return Column(
                  children: [
                    // Root-level files
                    _RootNotesList(vaultPath: vault.path),
                    // Folders tree
                    Expanded(
                      child: ListView.builder(
                        itemCount: vault.rootFolders.length,
                        itemBuilder: (context, index) {
                          return _FolderTile(
                            folder: vault.rootFolders[index],
                            depth: 0,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1),
          _SidebarFooter(),
        ],
      ),
    );
  }
}

class _SidebarHeader extends ConsumerWidget {
  const _SidebarHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final vaultAsync = ref.watch(vaultProvider);
    final vaultName = vaultAsync.valueOrNull?.name ?? 'No Vault';

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      child: Row(
        children: [
          const Icon(Icons.book_outlined, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              vaultName,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // New note button
          Tooltip(
            message: 'New Note (Cmd+N)',
            child: InkWell(
              onTap: () => _createNote(context, ref),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.add, size: 16),
              ),
            ),
          ),
          // Refresh button
          Tooltip(
            message: 'Refresh',
            child: InkWell(
              onTap: () => ref.read(vaultProvider.notifier).refreshVault(),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.refresh, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createNote(BuildContext context, WidgetRef ref) async {
    final vault = ref.read(vaultProvider).valueOrNull;
    if (vault == null) return;

    final selectedFolder = ref.read(selectedFolderProvider) ?? vault.path;

    // Show dialog to get note name
    final name = await _showCreateNoteDialog(context);
    if (name == null || name.trim().isEmpty) return;

    final repo = ref.read(noteRepositoryProvider);
    final path = await repo.createNote(selectedFolder, name.trim());
    await ref.read(activeNoteProvider.notifier).openNote(path);
    await ref.read(vaultProvider.notifier).refreshVault();
  }

  Future<String?> _showCreateNoteDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Note name...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (v) => Navigator.of(context).pop(v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _SidebarFooter extends ConsumerWidget {
  const _SidebarFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final vaultAsync = ref.watch(vaultProvider);
    final noteCount = vaultAsync.valueOrNull?.totalNoteCount ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Text(
            '$noteCount notes',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          const Spacer(),
          // Change vault
          Tooltip(
            message: 'Change Vault',
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.folder_open_outlined,
                  size: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows root-level .md files (not inside any subfolder).
class _RootNotesList extends ConsumerWidget {
  const _RootNotesList({required this.vaultPath});
  final String vaultPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesInFolderProvider(vaultPath));

    return notesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (notes) {
        if (notes.isEmpty) return const SizedBox.shrink();
        return Column(
          children: notes
              .map((note) => _NoteTile(note: note, depth: 0))
              .toList(),
        );
      },
    );
  }
}

/// A folder item in the sidebar tree.
class _FolderTile extends ConsumerStatefulWidget {
  const _FolderTile({required this.folder, required this.depth});
  final Folder folder;
  final int depth;

  @override
  ConsumerState<_FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends ConsumerState<_FolderTile> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected =
        ref.watch(selectedFolderProvider) == widget.folder.path;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
              ref.read(selectedFolderProvider.notifier).state =
                  widget.folder.path;
            },
            onSecondaryTap: () => _showContextMenu(context),
            child: Container(
              height: 28,
              padding: EdgeInsets.only(
                left: 8.0 + widget.depth * 16.0,
                right: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : _isHovered
                        ? theme.colorScheme.onSurface.withOpacity(0.05)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded
                        ? Icons.folder_open
                        : Icons.folder,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.folder.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.folder.noteCount > 0)
                    Text(
                      '${widget.folder.noteCount}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded) ...[
          // Notes in this folder
          _FolderNotesList(
              folderPath: widget.folder.path, depth: widget.depth + 1),
          // Sub-folders
          ...widget.folder.children.map(
            (child) => _FolderTile(
              folder: child,
              depth: widget.depth + 1,
            ),
          ),
        ],
      ],
    );
  }

  void _showContextMenu(BuildContext context) {
    // TODO: Native context menu
  }
}

class _FolderNotesList extends ConsumerWidget {
  const _FolderNotesList(
      {required this.folderPath, required this.depth});
  final String folderPath;
  final int depth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesInFolderProvider(folderPath));

    return notesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (notes) => Column(
        children: notes
            .map((note) => _NoteTile(note: note, depth: depth))
            .toList(),
      ),
    );
  }
}

/// A note file item in the sidebar.
class _NoteTile extends ConsumerStatefulWidget {
  const _NoteTile({required this.note, required this.depth});
  final Note note;
  final int depth;

  @override
  ConsumerState<_NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends ConsumerState<_NoteTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeNotePath = ref.watch(activeNoteProvider).valueOrNull?.path;
    final isActive = activeNotePath == widget.note.path;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () async {
          await ref
              .read(activeNoteProvider.notifier)
              .openNote(widget.note.path);
        },
        onSecondaryTap: () => _showContextMenu(context),
        child: Container(
          height: 28,
          padding: EdgeInsets.only(
            left: 12.0 + widget.depth * 16.0,
            right: 8,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary.withOpacity(0.15)
                : _isHovered
                    ? theme.colorScheme.onSurface.withOpacity(0.05)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 12,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.note.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    // TODO: Native context menu
  }
}
