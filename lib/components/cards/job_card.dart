import "package:flutter/material.dart";
import "package:intellihire/components/icons/company_logo.dart";
import "package:intellihire/pages/jobs/job_details.dart";
import "package:material_symbols_icons/symbols.dart";

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job});

  final Map<String, dynamic> job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                CompanyLogo(job: job),
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => JobDetails(job: job),
                      ),
                    );
                  },
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
