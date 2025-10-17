import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:intellihire/components/loading/loading_indicator.dart";
import "package:material_symbols_icons/symbols.dart";

class TestLogo extends StatelessWidget {
  const TestLogo({super.key, required this.test, this.size = 48});

  final Map<String, dynamic> test;
  final double size;

  String _colorToHex(Color color) =>
      color.toARGB32().toRadixString(16).substring(2).toUpperCase();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = _colorToHex(theme.colorScheme.onSecondaryContainer);

    final iconSlug = test["icon"] as String?;
    final iconColor = test["color"] as String?;
    final hasIcon = iconSlug != null && iconSlug.isNotEmpty;

    final String svgUrl = hasIcon
        ? "https://cdn.simpleicons.org/$iconSlug/${iconColor ?? defaultColor}"
        : "";

    final Widget loadingIndicator = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.5,
          height: size * 0.5,
          child: LoadingIndicator(
            backgroundColor: theme.colorScheme.secondaryContainer,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );

    final Widget errorIconPlaceholder = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Symbols.code_rounded,
        color: theme.colorScheme.onSecondaryContainer,
        size: size * 0.6,
      ),
    );

    if (!hasIcon) return errorIconPlaceholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        color: theme.colorScheme.secondaryContainer,
        child: Padding(
          padding: EdgeInsets.all(size * 0.167), // ~8px for 48px
          child: SvgPicture.network(
            svgUrl,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => loadingIndicator,
            errorBuilder: (context, error, stackTrace) => errorIconPlaceholder,
          ),
        ),
      ),
    );
  }
}
