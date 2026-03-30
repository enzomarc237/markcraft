/// Application-wide constants for MarkCraft.
class AppConstants {
  // File & Vault
  static const String markdownExtension = '.md';
  static const String inboxFolderName = 'Inbox';
  static const String settingsKey = 'markcraft_settings';
  static const String vaultPathKey = 'vault_path';
  static const String themeModeKey = 'theme_mode';

  // Editor
  static const int autoSaveDelayMs = 1000;
  static const int previewDebounceMs = 300;
  static const int searchDebounceMs = 200;
  static const double defaultEditorFontSize = 14.0;
  static const double defaultPreviewFontSize = 16.0;
  static const double maxContentWidth = 750.0;
  static const double defaultLineHeight = 1.6;

  // Layout
  static const double defaultSidebarWidth = 260.0;
  static const double minSidebarWidth = 180.0;
  static const double maxSidebarWidth = 400.0;
  static const double minEditorWidth = 300.0;
  static const double sashWidth = 4.0;

  // Quick Capture
  static const double quickCaptureWidth = 500.0;
  static const double quickCaptureHeight = 300.0;

  // Patterns
  static const String wikiLinkPattern = r'\[\[([^\[\]]+)\]\]';
  static const String frontmatterPattern =
      r'^---\s*\n([\s\S]*?)\n---\s*\n?';
  static const String latexInlinePattern = r'\$([^\$\n]+)\$';
  static const String latexBlockPattern = r'\$\$([^\$]+)\$\$';
  static const String taskListPattern = r'- \[([ x])\] (.+)';

  // Snippets
  static const Map<String, String> snippets = {
    'tip': '> **💡 Tip:** ',
    'note': '> **📝 Note:** ',
    'warning': '> **⚠️ Warning:** ',
    'date': '',  // Filled at runtime
    'code': '```\n\n```',
    'table':
        '| Column 1 | Column 2 | Column 3 |\n|----------|----------|----------|\n| Cell     | Cell     | Cell     |',
  };
}
