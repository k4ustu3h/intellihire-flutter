import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:intellihire/components/loading/loading_indicator.dart";
import "package:material_symbols_icons/symbols.dart";

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job});

  final Map<String, dynamic> job;

  String colorToHex(Color color) {
    return color.toARGB32().toRadixString(16).substring(2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultColor = colorToHex(theme.colorScheme.onSecondaryContainer);

    final iconSlug = job["iconSlug"] as String?;
    final iconColor = job["iconColor"] as String?;
    final hasIconData = iconSlug != null && iconSlug.isNotEmpty;

    final jobType = job["jobType"] as String?;
    final isRemote = jobType == "Remote";

    final locationText = isRemote
        ? "Remote"
        : "${job["city"] as String}, ${job["state"] as String}";

    final locationIcon = isRemote
        ? Symbols.public_rounded
        : Symbols.location_on_rounded;

    final String svgUrl = hasIconData
        ? "https://cdn.simpleicons.org/$iconSlug/${iconColor ?? defaultColor}"
        : "";

    final Widget loadingIndicator = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: LoadingIndicator(
            backgroundColor: theme.colorScheme.secondaryContainer,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );

    final Widget errorIconPlaceholder = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Symbols.business_center_rounded,
        color: theme.colorScheme.onSecondaryContainer,
      ),
    );

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
                hasIconData
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 48,
                          height: 48,
                          color: theme.colorScheme.secondaryContainer,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: SvgPicture.network(
                              svgUrl,
                              fit: BoxFit.contain,
                              placeholderBuilder: (context) => loadingIndicator,
                              errorBuilder: (context, error, stackTrace) =>
                                  errorIconPlaceholder,
                            ),
                          ),
                        ),
                      )
                    : errorIconPlaceholder,

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          job["jobTitle"] as String,
                          style: theme.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          job["companyName"] as String,
                          style: theme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              job["description"] as String,
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
                  avatar: Icon(locationIcon, size: 18),
                  label: Text(
                    locationText,
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {},
                  icon: Icon(Symbols.check_rounded),
                  label: Text("Apply"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
