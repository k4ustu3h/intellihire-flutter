import "package:flutter/material.dart";

class TestCardSkeleton extends StatelessWidget {
  const TestCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.colorScheme.secondaryContainer;
    final primaryColor = theme.colorScheme.primary;

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
                    color: secondaryColor,
                    borderRadius: .circular(8),
                  ),
                ),
                Column(
                  crossAxisAlignment: .end,
                  mainAxisSize: .min,
                  spacing: 6,
                  children: [
                    Container(width: 180, height: 24, color: secondaryColor),
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
                  color: secondaryColor,
                ),
              ),
            ),
            Padding(
              padding: const .only(bottom: 4, top: 8),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Container(
                    width: 60,
                    height: 32,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: .circular(8),
                    ),
                  ),
                  Container(
                    width: 102,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryColor,
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
