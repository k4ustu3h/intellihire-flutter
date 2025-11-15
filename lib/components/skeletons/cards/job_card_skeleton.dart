import "package:flutter/material.dart";

class JobCardSkeleton extends StatelessWidget {
  const JobCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card.outlined(
      margin: const .only(bottom: 16),
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: .circular(8),
                  ),
                ),
                Column(
                  crossAxisAlignment: .end,
                  mainAxisSize: .min,
                  spacing: 6,
                  children: [
                    Container(
                      width: 180,
                      height: 24,
                      color: theme.colorScheme.secondaryContainer,
                    ),
                    Container(
                      width: 100,
                      height: 14,
                      color: theme.colorScheme.secondaryContainer,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              spacing: 4,
              children: List.generate(
                2,
                (_) => Container(
                  width: .infinity,
                  height: 12,
                  color: theme.colorScheme.secondaryContainer,
                ),
                growable: false,
              ),
            ),
            Padding(
              padding: const .only(bottom: 4, top: 8),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Container(
                    width: 90,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: .circular(8),
                    ),
                  ),
                  Container(
                    width: 102,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: .circular(20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
