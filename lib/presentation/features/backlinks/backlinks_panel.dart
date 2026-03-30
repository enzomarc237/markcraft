import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../../../domain/entities/backlink.dart';

/// Panel shown at the bottom of the preview pane listing backlinks.
class BacklinksPanel extends ConsumerWidget {
  const BacklinksPanel({super.key, required this.noteName});

  final String noteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final backlinksAsync = ref.watch(backlinksProvider(noteName));

    return backlinksAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (backlinks) {
        if (backlinks.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: theme.dividerColor),
            const SizedBox(height: 8),
            Text(
              'Backlinks (${backlinks.length})',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.5),
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...backlinks.cast<Backlink>().map(
                  (bl) => _BacklinkItem(backlink: bl),
                ),
          ],
        );
      },
    );
  }
}

class _BacklinkItem extends ConsumerWidget {
  const _BacklinkItem({required this.backlink});
  final Backlink backlink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        await ref
            .read(activeNoteProvider.notifier)
            .openNote(backlink.sourcePath);
      },
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.link,
                  size: 12,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  backlink.sourceName,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              backlink.context,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.5),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
