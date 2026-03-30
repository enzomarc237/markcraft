import 'package:flutter_test/flutter_test.dart';
import 'package:markcraft/domain/entities/note.dart';
import 'package:markcraft/domain/entities/folder.dart';
import 'package:markcraft/domain/entities/vault.dart';
import 'package:markcraft/core/constants/app_constants.dart';

void main() {
  final now = DateTime(2024, 1, 1, 12, 0, 0);

  group('Note entity', () {
    test('creates Note with required fields', () {
      final note = Note(
        path: '/vault/test.md',
        name: 'test',
        content: '# Hello World\n\nThis is a test note.',
        modifiedAt: now,
        createdAt: now,
      );
      expect(note.path, '/vault/test.md');
      expect(note.name, 'test');
    });

    test('Note equality is based on path', () {
      final note1 = Note(
        path: '/vault/test.md',
        name: 'test',
        content: '# Hello',
        modifiedAt: now,
        createdAt: now,
      );
      final note2 = Note(
        path: '/vault/test.md',
        name: 'test-copy',
        content: '# Different content',
        modifiedAt: now,
        createdAt: now,
      );
      expect(note1, equals(note2));
    });

    test('Note preview strips heading markers', () {
      final note = Note(
        path: '/vault/test.md',
        name: 'test',
        content: '# My Note Title\n\nSome body text.',
        modifiedAt: now,
        createdAt: now,
      );
      expect(note.preview, 'My Note Title');
    });

    test('Note preview skips frontmatter', () {
      final note = Note(
        path: '/vault/test.md',
        name: 'test',
        content: '---\ntitle: Test\ntags: [flutter]\n---\n\n# My Title',
        modifiedAt: now,
        createdAt: now,
      );
      expect(note.contentWithoutFrontmatter.trim(), '# My Title');
    });

    test('Note copyWith returns updated note', () {
      final original = Note(
        path: '/vault/test.md',
        name: 'test',
        content: 'Original content',
        modifiedAt: now,
        createdAt: now,
      );
      final updated = original.copyWith(content: 'Updated content');
      expect(updated.content, 'Updated content');
      expect(updated.path, original.path);
      expect(updated.name, original.name);
    });

    test('Note tags default to empty list', () {
      final note = Note(
        path: '/vault/test.md',
        name: 'test',
        content: '',
        modifiedAt: now,
        createdAt: now,
      );
      expect(note.tags, isEmpty);
    });
  });

  group('Folder entity', () {
    test('creates Folder with required fields', () {
      const folder = Folder(
        path: '/vault/notes',
        name: 'notes',
        noteCount: 5,
      );
      expect(folder.path, '/vault/notes');
      expect(folder.name, 'notes');
      expect(folder.noteCount, 5);
    });

    test('Folder equality is based on path', () {
      const folder1 = Folder(path: '/vault/notes', name: 'notes');
      const folder2 = Folder(
        path: '/vault/notes',
        name: 'notes-different',
        noteCount: 10,
      );
      expect(folder1, equals(folder2));
    });

    test('Folder isExpanded defaults to false', () {
      const folder = Folder(path: '/vault/notes', name: 'notes');
      expect(folder.isExpanded, isFalse);
    });
  });

  group('Vault entity', () {
    test('creates Vault with required fields', () {
      const vault = Vault(
        path: '/Users/user/MyVault',
        name: 'MyVault',
      );
      expect(vault.path, '/Users/user/MyVault');
      expect(vault.name, 'MyVault');
      expect(vault.totalNoteCount, 0);
    });

    test('Vault equality is based on path', () {
      const vault1 = Vault(path: '/Users/user/MyVault', name: 'MyVault');
      const vault2 =
          Vault(path: '/Users/user/MyVault', name: 'Different Name');
      expect(vault1, equals(vault2));
    });
  });

  group('AppConstants', () {
    test('markdown extension is .md', () {
      expect(AppConstants.markdownExtension, '.md');
    });

    test('inbox folder name is Inbox', () {
      expect(AppConstants.inboxFolderName, 'Inbox');
    });

    test('snippets map contains expected keys', () {
      expect(AppConstants.snippets.containsKey('tip'), isTrue);
      expect(AppConstants.snippets.containsKey('note'), isTrue);
      expect(AppConstants.snippets.containsKey('warning'), isTrue);
      expect(AppConstants.snippets.containsKey('code'), isTrue);
      expect(AppConstants.snippets.containsKey('table'), isTrue);
    });

    test('wiki link pattern matches [[Note Name]]', () {
      final regex = RegExp(AppConstants.wikiLinkPattern);
      final match = regex.firstMatch('See [[Other Note]] for details');
      expect(match, isNotNull);
      expect(match!.group(1), 'Other Note');
    });

    test('wiki link pattern handles multiple links', () {
      final regex = RegExp(AppConstants.wikiLinkPattern);
      final matches =
          regex.allMatches('[[Link 1]] and [[Link 2]] are here').toList();
      expect(matches.length, 2);
      expect(matches[0].group(1), 'Link 1');
      expect(matches[1].group(1), 'Link 2');
    });

    test('frontmatter pattern extracts yaml block', () {
      final regex = RegExp(AppConstants.frontmatterPattern);
      const content = '---\ntitle: My Note\ntags: [flutter, dart]\n---\n\n# Hello';
      final match = regex.firstMatch(content);
      expect(match, isNotNull);
      expect(match!.group(1)!.contains('title'), isTrue);
    });
  });
}
