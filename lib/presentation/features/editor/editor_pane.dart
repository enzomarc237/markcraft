import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../domain/entities/note.dart';

/// The raw Markdown editor pane.
class EditorPane extends ConsumerStatefulWidget {
  const EditorPane({super.key, this.isZenMode = false});

  final bool isZenMode;

  @override
  ConsumerState<EditorPane> createState() => _EditorPaneState();
}

class _EditorPaneState extends ConsumerState<EditorPane> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final Debouncer _previewDebouncer;
  late final Debouncer _saveDebouncer;
  late final ScrollController _scrollController;

  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _previewDebouncer = Debouncer(
      duration: const Duration(milliseconds: AppConstants.previewDebounceMs),
    );
    _saveDebouncer = Debouncer(
      duration: const Duration(milliseconds: AppConstants.autoSaveDelayMs),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _previewDebouncer.dispose();
    _saveDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>();
    final noteAsync = ref.watch(activeNoteProvider);

    // Sync controller with note content when note changes
    ref.listen<AsyncValue<Note?>>(activeNoteProvider, (prev, next) {
      final note = next.valueOrNull;
      if (note != null) {
        final prevNote = prev?.valueOrNull;
        // Only update controller if the path changed (new note opened)
        if (prevNote?.path != note.path) {
          _controller.value = TextEditingValue(
            text: note.content,
            selection: TextSelection.collapsed(offset: 0),
          );
        }
      }
    });

    if (noteAsync.valueOrNull == null) {
      return const SizedBox.shrink();
    }

    return Container(
      color: appColors?.editorBackground ?? theme.colorScheme.surface,
      child: Column(
        children: [
          // Editor toolbar
          _EditorToolbar(controller: _controller),
          const Divider(height: 1),
          // Editor
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isZenMode ? 48 : 16,
                vertical: 16,
              ),
              child: _buildEditor(context, appColors),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor(BuildContext context, AppColors? appColors) {
    final theme = Theme.of(context);

    return CallbackShortcuts(
      bindings: {
        // Tab key for snippet expansion
        const SingleActivator(LogicalKeyboardKey.tab): _handleTab,
        // Cmd+B for bold
        SingleActivator(LogicalKeyboardKey.keyB, meta: true): () =>
            _insertFormatting('**', '**'),
        // Cmd+I for italic
        SingleActivator(LogicalKeyboardKey.keyI, meta: true): () =>
            _insertFormatting('*', '*'),
        // Cmd+U for underline (not standard MD but common)
        SingleActivator(LogicalKeyboardKey.keyK, meta: true): _insertLink,
        // Cmd+Up to move block up
        SingleActivator(LogicalKeyboardKey.arrowUp, meta: true): _moveBlockUp,
        // Cmd+Down to move block down
        SingleActivator(LogicalKeyboardKey.arrowDown, meta: true):
            _moveBlockDown,
      },
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        scrollController: _scrollController,
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          fontFamily: appColors?.editorFontFamily ?? 'monospace',
          fontSize: AppConstants.defaultEditorFontSize,
          height: 1.6,
          color: theme.colorScheme.onSurface,
          letterSpacing: 0.0,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        cursorColor: theme.colorScheme.primary,
        selectionControls: MaterialTextSelectionControls(),
        onChanged: _onTextChanged,
      ),
    );
  }

  void _onTextChanged(String text) {
    // Update preview with debounce
    _previewDebouncer.run(() {
      ref.read(activeNoteProvider.notifier).updateContent(text);
    });

    // Auto-save with debounce
    _saveDebouncer.run(() {
      final note = ref.read(activeNoteProvider).valueOrNull;
      if (note != null) {
        final updated = note.copyWith(
          content: text,
          modifiedAt: DateTime.now(),
        );
        ref.read(activeNoteProvider.notifier).saveNote(updated);
      }
    });
  }

  void _handleTab() {
    final text = _controller.text;
    final selection = _controller.selection;
    final cursorPos = selection.baseOffset;

    // Check for snippet expansion
    if (cursorPos > 0) {
      // Get word before cursor
      final beforeCursor = text.substring(0, cursorPos);
      final words = beforeCursor.split(RegExp(r'[\s\n]'));
      final lastWord = words.isNotEmpty ? words.last : '';

      if (AppConstants.snippets.containsKey(lastWord)) {
        final snippet = lastWord == 'date'
            ? '${DateTime.now().toIso8601String().split('T')[0]}'
            : AppConstants.snippets[lastWord]!;

        final newText = text.substring(0, cursorPos - lastWord.length) +
            snippet +
            text.substring(cursorPos);

        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: cursorPos - lastWord.length + snippet.length,
          ),
        );
        _onTextChanged(newText);
        return;
      }
    }

    // Default: insert 2-space indent
    final newText = text.substring(0, cursorPos) +
        '  ' +
        text.substring(cursorPos);
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPos + 2),
    );
  }

  void _insertFormatting(String prefix, String suffix) {
    final selection = _controller.selection;
    if (!selection.isValid) return;

    final text = _controller.text;
    final selected = selection.textInside(text);

    String newText;
    int newCursorPos;

    if (selected.isEmpty) {
      newText = text.substring(0, selection.baseOffset) +
          prefix +
          suffix +
          text.substring(selection.extentOffset);
      newCursorPos = selection.baseOffset + prefix.length;
    } else {
      newText = text.substring(0, selection.start) +
          prefix +
          selected +
          suffix +
          text.substring(selection.end);
      newCursorPos = selection.end + prefix.length + suffix.length;
    }

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
    _onTextChanged(newText);
  }

  void _insertLink() {
    final selection = _controller.selection;
    if (!selection.isValid) return;

    final text = _controller.text;
    final selected = selection.textInside(text);
    final linkText = selected.isEmpty ? 'Link Text' : selected;
    const linkUrl = 'https://';

    final inserted = '[$linkText]($linkUrl)';
    final newText = text.substring(0, selection.start) +
        inserted +
        text.substring(selection.end);

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection(
        baseOffset: selection.start + linkText.length + 3,
        extentOffset: selection.start + inserted.length - 1,
      ),
    );
    _onTextChanged(newText);
  }

  void _moveBlockUp() {
    final text = _controller.text;
    final selection = _controller.selection;
    if (!selection.isValid) return;

    final lines = text.split('\n');
    int currentLine = _getLineAtOffset(text, selection.baseOffset);

    if (currentLine <= 0) return;

    // Swap lines
    final temp = lines[currentLine];
    lines[currentLine] = lines[currentLine - 1];
    lines[currentLine - 1] = temp;

    final newText = lines.join('\n');
    final lineStart = _getLineStart(newText, currentLine - 1);

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: lineStart),
    );
    _onTextChanged(newText);
  }

  void _moveBlockDown() {
    final text = _controller.text;
    final selection = _controller.selection;
    if (!selection.isValid) return;

    final lines = text.split('\n');
    int currentLine = _getLineAtOffset(text, selection.baseOffset);

    if (currentLine >= lines.length - 1) return;

    // Swap lines
    final temp = lines[currentLine];
    lines[currentLine] = lines[currentLine + 1];
    lines[currentLine + 1] = temp;

    final newText = lines.join('\n');
    final lineStart = _getLineStart(newText, currentLine + 1);

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: lineStart),
    );
    _onTextChanged(newText);
  }

  int _getLineAtOffset(String text, int offset) {
    final before = text.substring(0, offset);
    return before.split('\n').length - 1;
  }

  int _getLineStart(String text, int lineNumber) {
    final lines = text.split('\n');
    int pos = 0;
    for (int i = 0; i < lineNumber && i < lines.length; i++) {
      pos += lines[i].length + 1; // +1 for \n
    }
    return pos.clamp(0, text.length);
  }
}

/// Toolbar above the editor with quick formatting actions.
class _EditorToolbar extends ConsumerWidget {
  const _EditorToolbar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final noteAsync = ref.watch(activeNoteProvider);
    final note = noteAsync.valueOrNull;

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: theme.colorScheme.surface,
      child: Row(
        children: [
          // Note name
          Expanded(
            child: Text(
              note?.name ?? '',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Toolbar buttons
          _ToolbarButton(
            tooltip: 'Bold (Cmd+B)',
            icon: Icons.format_bold,
            onTap: () => _insertAround('**', '**'),
          ),
          _ToolbarButton(
            tooltip: 'Italic (Cmd+I)',
            icon: Icons.format_italic,
            onTap: () => _insertAround('*', '*'),
          ),
          _ToolbarButton(
            tooltip: 'Heading',
            icon: Icons.title,
            onTap: _insertHeading,
          ),
          _ToolbarButton(
            tooltip: 'Code Block',
            icon: Icons.code,
            onTap: _insertCodeBlock,
          ),
          _ToolbarButton(
            tooltip: 'Quote',
            icon: Icons.format_quote,
            onTap: () => _insertAtLineStart('> '),
          ),
          _ToolbarButton(
            tooltip: 'Bullet List',
            icon: Icons.format_list_bulleted,
            onTap: () => _insertAtLineStart('- '),
          ),
          _ToolbarButton(
            tooltip: 'Numbered List',
            icon: Icons.format_list_numbered,
            onTap: () => _insertAtLineStart('1. '),
          ),
          _ToolbarButton(
            tooltip: 'Task List',
            icon: Icons.check_box_outline_blank,
            onTap: () => _insertAtLineStart('- [ ] '),
          ),
        ],
      ),
    );
  }

  void _insertAround(String prefix, String suffix) {
    final selection = controller.selection;
    if (!selection.isValid) return;

    final text = controller.text;
    final selected = selection.textInside(text);

    if (selected.isEmpty) {
      final newText = text.substring(0, selection.baseOffset) +
          prefix +
          suffix +
          text.substring(selection.extentOffset);
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
            offset: selection.baseOffset + prefix.length),
      );
    } else {
      final newText = text.substring(0, selection.start) +
          prefix +
          selected +
          suffix +
          text.substring(selection.end);
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
            offset: selection.end + prefix.length + suffix.length),
      );
    }
  }

  void _insertHeading() {
    _insertAtLineStart('## ');
  }

  void _insertCodeBlock() {
    final selection = controller.selection;
    if (!selection.isValid) return;
    final text = controller.text;
    const block = '```\n\n```';
    final newText = text.substring(0, selection.baseOffset) +
        block +
        text.substring(selection.extentOffset);
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
          offset: selection.baseOffset + 4),
    );
  }

  void _insertAtLineStart(String prefix) {
    final selection = controller.selection;
    if (!selection.isValid) return;
    final text = controller.text;

    // Find line start
    final before = text.substring(0, selection.baseOffset);
    final lineStart = before.lastIndexOf('\n') + 1;

    final newText = text.substring(0, lineStart) +
        prefix +
        text.substring(lineStart);
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
          offset: selection.baseOffset + prefix.length),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
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
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16),
        ),
      ),
    );
  }
}
