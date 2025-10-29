import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:intellihire/components/loading/loading_indicator.dart";
import "package:material_symbols_icons/symbols.dart";

class CompanyLogo extends StatelessWidget {
  const CompanyLogo({super.key, required this.job, this.size = 48});

  final Map<String, dynamic> job;
  final double size;

  String _colorToHex(Color color) =>
      color.toARGB32().toRadixString(16).substring(2).toUpperCase();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = _colorToHex(theme.colorScheme.onSecondaryContainer);

    final iconSlug = job["iconSlug"] as String?;
    final iconColor = job["iconColor"] as String?;
    final hasIconData = iconSlug != null && iconSlug.isNotEmpty;

    final String svgUrl = hasIconData
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
        color: theme.colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Symbols.business_center_rounded,
        color: theme.colorScheme.onInverseSurface,
        size: size * 0.6,
      ),
    );

    if (!hasIconData) {
      return errorIconPlaceholder;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        color: theme.colorScheme.inverseSurface,
        child: Padding(
          padding: EdgeInsets.all(size * 0.167), // 8px for 48px size
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
