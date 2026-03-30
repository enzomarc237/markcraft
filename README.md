# MarkCraft

A high-tier macOS Markdown note-taking app built with Flutter & Dart.

[![Build and Release macOS](https://github.com/enzomarc237/markcraft/actions/workflows/build-release.yml/badge.svg)](https://github.com/enzomarc237/markcraft/actions/workflows/build-release.yml)

## Overview

MarkCraft is a local-first, keyboard-driven Markdown editor for macOS targeting developers, writers, and power users. It blends the minimalism of iA Writer with the power of Obsidian, built with Flutter for native macOS performance.

## Features

### Core Features
- **Local-First Vault**: Store notes as plain `.md` files in any directory
- **File Tree Sidebar**: Collapsible tree with nested folder support
- **Split-Pane View**: Side-by-side editor and live preview, with a draggable sash
- **Zen Mode**: Distraction-free writing with centered content
- **Auto-Save**: Debounced auto-save with 1-second delay

### Editor
- Monospaced editor with Markdown syntax awareness
- Toolbar for bold, italic, headings, code blocks, lists, quotes
- Keyboard shortcuts: `Cmd+B` (bold), `Cmd+I` (italic), `Cmd+Up/Down` (move block)
- Snippet expansion: type `tip` + Tab → inserts formatted blockquote
- Wiki-style linking: `[[Note Name]]` with auto-indexing

### Preview (powered by `markdown_widget`)
- GFM rendering with custom builders
- Syntax highlighting for code blocks (`flutter_highlight`)
- LaTeX math rendering (`flutter_math_fork`)
- Mermaid diagram rendering via embedded WebView
- Task list checkboxes with bi-directional sync
- Backlinks panel at the bottom of each note

### Power User Features
- **Command Palette** (`Cmd+K`): Fuzzy search files, toggle themes, execute actions
- **Quick Capture** (`Cmd+Shift+N`): Floating window to jot notes to Inbox/
- **Full-Text Search**: Powered by SQLite/Drift with FTS5
- **Backlinks Index**: See all notes linking to the current note

### Technical
- **Clean Architecture**: Presentation → Domain → Data layers
- **State Management**: Riverpod (fully reactive, testable)
- **Database**: Drift (SQLite) for backlinks, tags, and search index
- **File Watcher**: Detects external changes (e.g., from VS Code) in real-time

## Architecture

```
lib/
├── core/                   # Constants, themes, utils
│   ├── theme/app_theme.dart
│   ├── constants/app_constants.dart
│   └── utils/
├── data/
│   ├── datasources/
│   │   ├── local_db/       # Drift database & DAOs
│   │   └── file_system/    # dart:io wrappers + watcher
│   └── repositories/
├── domain/
│   └── entities/           # Note, Folder, Vault, Backlink, SearchResult
└── presentation/
    ├── features/
    │   ├── editor/         # EditorPane, PreviewPane, MermaidWidget
    │   ├── sidebar/        # File tree
    │   ├── command_palette/
    │   ├── quick_capture/
    │   ├── search/
    │   ├── backlinks/
    │   └── vault/          # Vault selection screen
    ├── providers/          # Riverpod providers
    └── widgets/            # SplitPane, TitleBar
```

## Tech Stack

| Concern | Library |
|---------|---------|
| Framework | Flutter 3.24+ |
| State Management | `flutter_riverpod` |
| Markdown | `markdown_widget` |
| Database | `drift` (SQLite) |
| Code Highlighting | `flutter_highlight` |
| LaTeX | `flutter_math_fork` |
| Diagrams | `webview_flutter` + Mermaid.js |
| Fuzzy Search | `fuzzy` |
| File Picker | `file_picker` |
| Window Manager | `window_manager` |
| Fonts | `google_fonts` |

## Getting Started

### Prerequisites
- Flutter SDK 3.24+
- macOS 10.14+
- Xcode 14+

### Setup

```bash
# Clone
git clone https://github.com/enzomarc237/markcraft.git
cd markcraft

# Install dependencies
flutter pub get

# Generate Drift database code
flutter pub run build_runner build

# Run on macOS
flutter run -d macos
```

### Building for Release

```bash
flutter build macos --release
```

The built app will be at `build/macos/Build/Products/Release/MarkCraft.app`.

## CI/CD

Every push to `main` triggers a GitHub Actions workflow that:
1. Builds the macOS release binary
2. Creates a `.dmg` archive
3. Drafts a GitHub Release with the DMG attached

See `.github/workflows/build-release.yml` for details.

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd+K` | Command Palette |
| `Cmd+Shift+N` | Quick Capture |
| `Cmd+E` | Cycle editor modes (split/editor/preview) |
| `Cmd+/` | Toggle sidebar |
| `Cmd+B` | Bold |
| `Cmd+I` | Italic |
| `Cmd+Up/Down` | Move line up/down |

## License

MIT
