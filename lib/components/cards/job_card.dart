import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job});

  final Map<String, dynamic> job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoUrl = job["companyLogo"] as String?;
    final hasLogo = logoUrl != null && logoUrl.isNotEmpty;

    final jobType = job["jobType"] as String?;
    final isRemote = jobType == "Remote";

    final locationText = isRemote
        ? "Remote"
        : "${job["city"] as String}, ${job["state"] as String}";

    final locationIcon = isRemote
        ? Symbols.public_rounded
        : Symbols.location_on_rounded;

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
                hasLogo
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: logoUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: theme.colorScheme.secondaryContainer,
                          ),
                          errorWidget: (context, url, error) => Container(
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
                          ),
                        ),
                      )
                    : Container(
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
                      ),

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
