import "package:flutter/material.dart";

class ListRow extends StatelessWidget {
  final Widget label;
  final Widget? description;
  final Widget? startIcon;
  final Widget? endIcon;
  final bool background;
  final bool first;
  final bool last;
  final VoidCallback? onClick;

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
    this.onClick,
  });

  TextStyle _labelStyle(BuildContext context) => Theme.of(
    context,
  ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 16);

  TextStyle _descriptionStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 13,
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

    return Container(
      margin: background ? EdgeInsets.symmetric(horizontal: basePadding) : null,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          color: background
              ? theme.colorScheme.surfaceVariant
              : Colors.transparent,
          child: InkWell(
            onTap: onClick,
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
                      spacing: verticalTextSpacing,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        styledLabel,
                        if (styledDescription != null) styledDescription,
                      ],
                    ),
                  ),
                  if (endIcon != null) ...[
                    SizedBox(width: basePadding),
                    endIcon!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
