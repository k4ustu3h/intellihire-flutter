import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";

class ListRow extends StatelessWidget {
  final Widget label;
  final Widget? description;
  final Widget? startIcon;
  final Widget? endIcon;
  final bool background;
  final bool first;
  final bool last;
  final VoidCallback? onClick;
  final Widget? title;
  final Widget? navigateTo;

  static const double basePadding = 16;
  static const double rowHeight = 72;
  static const double verticalTextSpacing = 4;

  const ListRow({
    super.key,
    required this.label,
    this.description,
    this.startIcon,
    this.endIcon,
    this.background = true,
    this.first = false,
    this.last = false,
    this.title,
    required this.onClick,
  }) : navigateTo = null;

  const ListRow.navigate({
    super.key,
    required this.label,
    this.description,
    this.startIcon,
    this.background = true,
    this.first = false,
    this.last = false,
    this.title,
    required this.navigateTo,
  }) : endIcon = null,
       onClick = null;

  TextStyle _labelStyle(BuildContext context) => Theme.of(
    context,
  ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 16);

  TextStyle _descriptionStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 13,
      );

  TextStyle _titleStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderRadius = BorderRadius.vertical(
      top: Radius.circular(first ? 16 : 2),
      bottom: Radius.circular(last ? 16 : 2),
    );

    final styledLabel = DefaultTextStyle.merge(
      style: _labelStyle(context),
      child: label,
    );

    final styledDescription = description == null
        ? null
        : DefaultTextStyle.merge(
            style: _descriptionStyle(context),
            child: description!,
          );

    final onTapAction = navigateTo != null
        ? () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => navigateTo!))
        : onClick;

    final effectiveEndIcon = navigateTo != null
        ? Icon(
            Symbols.navigate_next_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          )
        : endIcon;

    return Container(
      margin: background ? EdgeInsets.symmetric(horizontal: basePadding) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          if (first && title != null)
            Padding(
              padding: EdgeInsets.only(
                bottom: 4,
                left: basePadding,
                right: basePadding,
              ),
              child: DefaultTextStyle.merge(
                style: _titleStyle(context),
                child: title!,
              ),
            ),
          ClipRRect(
            borderRadius: borderRadius,
            child: Material(
              color: background
                  ? theme.colorScheme.surfaceContainer
                  : Colors.transparent,
              child: InkWell(
                onTap: onTapAction,
                child: Container(
                  height: rowHeight,
                  padding: EdgeInsets.symmetric(horizontal: basePadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (startIcon != null) ...[
                        startIcon!,
                        SizedBox(width: basePadding),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: verticalTextSpacing,
                          children: [
                            styledLabel,
                            if (styledDescription != null) styledDescription,
                          ],
                        ),
                      ),
                      if (effectiveEndIcon != null) ...[
                        SizedBox(width: basePadding),
                        effectiveEndIcon,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
