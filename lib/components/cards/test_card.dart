import "package:flutter/material.dart";
import "package:intellihire/components/icons/entity_logo.dart";
import "package:material_symbols_icons/symbols.dart";

class TestCard extends StatelessWidget {
  const TestCard({super.key, required this.test, required this.onStart});

  final Map<String, dynamic> test;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EntityLogo.test(test: test),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      test["title"] as String,
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
            Text(
              test["description"] as String,
              style: theme.textTheme.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  side: BorderSide.none,
                  iconTheme: IconThemeData(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  avatar: const Icon(Symbols.bar_chart_rounded, size: 18),
                  label: Text(
                    "${test["difficulty"]}",
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                FilledButton.icon(
                  onPressed: onStart,
                  icon: const Icon(Symbols.play_arrow_rounded),
                  label: const Text("Start"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
