import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:intellihire/components/loading/loading_indicator.dart";
import "package:material_symbols_icons/symbols.dart";

class EntityLogo extends StatelessWidget {
  final Map<String, dynamic> data;
  final double size;
  final IconData fallbackIcon;
  final String iconSlugKey;
  final String iconColorKey;

  const EntityLogo({
    super.key,
    required this.data,
    required this.size,
    required this.fallbackIcon,
    required this.iconSlugKey,
    required this.iconColorKey,
  });

  factory EntityLogo.company({
    Key? key,
    required Map<String, dynamic> job,
    double size = 48,
  }) {
    return EntityLogo(
      key: key,
      data: job,
      size: size,
      fallbackIcon: Symbols.business_center_rounded,
      iconSlugKey: "iconSlug",
      iconColorKey: "iconColor",
    );
  }

  factory EntityLogo.test({
    Key? key,
    required Map<String, dynamic> test,
    double size = 48,
  }) {
    return EntityLogo(
      key: key,
      data: test,
      size: size,
      fallbackIcon: Symbols.code_rounded,
      iconSlugKey: "icon",
      iconColorKey: "color",
    );
  }

  String _colorToHex(Color color) =>
      color.toARGB32().toRadixString(16).substring(2).toUpperCase();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final iconBackground = isDark
        ? theme.colorScheme.inverseSurface
        : theme.colorScheme.secondaryContainer;
    final iconForeground = isDark
        ? theme.colorScheme.onInverseSurface
        : theme.colorScheme.onSecondaryContainer;

    final defaultColor = _colorToHex(iconForeground);

    final iconSlug = data[iconSlugKey] as String?;
    final iconColor = data[iconColorKey] as String?;
    final hasIcon = iconSlug != null && iconSlug.isNotEmpty;

    final String svgUrl = hasIcon
        ? "https://cdn.simpleicons.org/$iconSlug/${iconColor ?? defaultColor}"
        : "";

    final Widget loadingIndicator = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: iconBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.5,
          height: size * 0.5,
          child: LoadingIndicator(
            backgroundColor: iconBackground,
            color: iconForeground,
          ),
        ),
      ),
    );

    final Widget errorIconPlaceholder = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: iconBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(fallbackIcon, color: iconForeground, size: size * 0.6),
    );

    if (!hasIcon) {
      return errorIconPlaceholder;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        color: iconBackground,
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
