import "package:flutter/material.dart";
import "package:material_symbols_icons/material_symbols_icons.dart";

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job});

  final Map<String, dynamic> job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoUrl = job["companyLogo"] as String?;
    final hasLogo = logoUrl != null && logoUrl.isNotEmpty;

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
                        child: Image.network(
                          logoUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      job["jobTitle"] as String,
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      job["companyName"] as String,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
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
                  side: BorderSide(width: 0),
                  iconTheme: IconThemeData(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  avatar: Icon(Symbols.location_on_rounded, size: 18),
                  label: Text(
                    job["location"] as String,
                    style: theme.textTheme.labelSmall,
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
