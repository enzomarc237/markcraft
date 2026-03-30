import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../providers/app_providers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/datasources/file_system/file_system_service.dart';
import '../../../../data/repositories/note_repository.dart';

/// Quick capture window – a lightweight popover for jotting notes.
class QuickCaptureWindow extends ConsumerStatefulWidget {
  const QuickCaptureWindow({super.key});

  @override
  ConsumerState<QuickCaptureWindow> createState() =>
      _QuickCaptureWindowState();
}

class _QuickCaptureWindowState extends ConsumerState<QuickCaptureWindow> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: AppConstants.quickCaptureWidth,
        height: AppConstants.quickCaptureHeight,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
              child: Row(
                children: [
                  const Icon(Icons.flash_on, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Quick Capture',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Saves to Inbox/',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Text area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write your thought here...',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Cmd+Enter to save',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _dismiss,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    icon: _isSaving
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                                strokeWidth: 2),
                          )
                        : const Icon(Icons.save, size: 14),
                    label: const Text('Save'),
                    onPressed: _isSaving ? null : _saveCapture,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveCapture() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _dismiss();
      return;
    }

    setState(() => _isSaving = true);

    try {
      final vault = ref.read(vaultProvider).valueOrNull;
      if (vault == null) return;

      final inboxPath = p.join(vault.path, AppConstants.inboxFolderName);
      final now = DateTime.now();
      final timestamp =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_'
          '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

      final content = '# Quick Capture\n\n$text';
      final repo = ref.read(noteRepositoryProvider);
      final path = await repo.createNote(inboxPath, timestamp);

      final fs = ref.read(fileSystemServiceProvider);
      await fs.writeFile(path, content);

      await ref.read(vaultProvider.notifier).refreshVault();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to Inbox')),
      );
      _dismiss();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _dismiss() {
    Navigator.of(context).maybePop();
  }
}
