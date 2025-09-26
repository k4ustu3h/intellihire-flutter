import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:material_symbols_icons/symbols.dart";

class TestCard extends StatelessWidget {
  const TestCard({super.key, required this.test, required this.onStart});

  final Map<String, dynamic> test;
  final VoidCallback onStart;

  String colorToHex(Color color) {
    return color.toARGB32().toRadixString(16).substring(2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSlug = test["icon"] as String?;
    final iconColor = test["color"] as String?;
    final hasIcon = iconSlug != null && iconSlug.isNotEmpty;

    final defaultColor = colorToHex(theme.colorScheme.onSecondaryContainer);

    return Card.outlined(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: hasIcon
                      ? Padding(
                          padding: EdgeInsets.all(8),
                          child: SvgPicture.network(
                            "https://cdn.simpleicons.org/$iconSlug/${iconColor ?? defaultColor}",
                            width: 32,
                            height: 32,
                            placeholderBuilder: (context) => Icon(
                              Symbols.image_rounded,
                              size: 32,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        )
                      : Icon(
                          Symbols.code_rounded,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                ),
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
                  side: BorderSide(width: 0),
                  iconTheme: IconThemeData(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  avatar: Icon(Symbols.bar_chart_rounded, size: 18),
                  label: Text(
                    "${test["difficulty"]}",
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                FilledButton.icon(
                  onPressed: onStart,
                  icon: Icon(Symbols.play_arrow_rounded),
                  label: Text("Start"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
