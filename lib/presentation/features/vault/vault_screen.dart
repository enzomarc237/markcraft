import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../providers/app_providers.dart';
import '../editor/main_editor_screen.dart';

/// Screen shown when no vault is open.
class VaultScreen extends ConsumerWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaultAsync = ref.watch(vaultProvider);

    return vaultAsync.when(
      loading: () => const _LoadingScreen(),
      error: (err, _) => _ErrorScreen(error: err.toString()),
      data: (vault) {
        if (vault != null) {
          return const MainEditorScreen();
        }
        return const _WelcomeScreen();
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Opening vault...'),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeScreen extends ConsumerWidget {
  const _WelcomeScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / App name
            Text(
              'MarkCraft',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A beautiful Markdown editor for macOS',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 48),
            // Open vault button
            FilledButton.icon(
              icon: const Icon(Icons.folder_open),
              label: const Text('Open Vault'),
              onPressed: () => _openVault(context, ref),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.create_new_folder),
              label: const Text('Create New Vault'),
              onPressed: () => _createVault(context, ref),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'Your notes are stored locally as plain .md files',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openVault(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select Vault Folder',
    );
    if (result != null) {
      await ref.read(vaultProvider.notifier).openVault(result);
    }
  }

  Future<void> _createVault(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Choose Location for New Vault',
    );
    if (result != null) {
      await ref.read(vaultProvider.notifier).openVault(result);
    }
  }
}
