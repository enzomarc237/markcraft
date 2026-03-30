import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../providers/app_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import 'mermaid_widget.dart';
import '../backlinks/backlinks_panel.dart';

/// The Markdown preview pane.
class PreviewPane extends ConsumerWidget {
  const PreviewPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>();
    final noteAsync = ref.watch(activeNoteProvider);
    final isDark = theme.brightness == Brightness.dark;

    final note = noteAsync.valueOrNull;
    if (note == null) return const SizedBox.shrink();

    return Container(
      color: appColors?.previewBackground ?? theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // Preview label
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Preview',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Markdown content
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppConstants.maxContentWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMarkdown(context, note.contentWithoutFrontmatter, isDark, appColors),
                        const SizedBox(height: 32),
                        // Backlinks panel
                        BacklinksPanel(noteName: note.name),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkdown(
    BuildContext context,
    String content,
    bool isDark,
    AppColors? appColors,
  ) {
    final theme = Theme.of(context);
    final codeTheme = isDark ? monokaiSublimeTheme : githubTheme;

    return MarkdownWidget(
      data: content,
      shrinkWrap: true,
      config: MarkdownConfig(
        configs: [
          // H1
          H1Config(
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: appColors?.contentFontFamily ?? 'sans-serif',
              color: theme.colorScheme.onBackground,
              height: 1.3,
            ),
          ),
          // H2
          H2Config(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: appColors?.contentFontFamily ?? 'sans-serif',
              color: theme.colorScheme.onBackground,
              height: 1.4,
            ),
          ),
          // H3
          H3Config(
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: appColors?.contentFontFamily ?? 'sans-serif',
              color: theme.colorScheme.onBackground,
              height: 1.4,
            ),
          ),
          // Paragraph
          PConfig(
            textStyle: TextStyle(
              fontSize: AppConstants.defaultPreviewFontSize,
              height: AppConstants.defaultLineHeight,
              fontFamily: appColors?.contentFontFamily ?? 'sans-serif',
              color: theme.colorScheme.onBackground,
            ),
          ),
          // Code blocks (syntax highlighting)
          PreConfig(
            theme: codeTheme,
            builder: (code, language) {
              // Mermaid diagram
              if (language == 'mermaid') {
                return MermaidWidget(code: code, isDark: isDark);
              }
              return HighlightView(
                code,
                language: language.isNotEmpty ? language : 'plaintext',
                theme: codeTheme,
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.5,
                ),
              );
            },
          ),
          // Inline code
          CodeConfig(
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: isDark
                  ? const Color(0xFFFC6A5D)
                  : const Color(0xFFE83E8C),
              backgroundColor: appColors?.codeBackground ??
                  const Color(0xFFF0F0F0),
            ),
          ),
          // Blockquote
          BlockquoteConfig(
            sideColor: theme.colorScheme.primary,
            textColor: theme.colorScheme.onBackground.withOpacity(0.75),
          ),
          // Links
          LinkConfig(
            style: TextStyle(
              color: theme.colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
          // Checkboxes (task lists) - bi-directional sync
          // Note: markdown_widget handles checkboxes via its built-in support
        ],
      ),
    );
  }
}
