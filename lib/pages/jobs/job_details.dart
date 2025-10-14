import "package:flutter/material.dart";
import "package:intellihire/components/icons/company_logo.dart";
import "package:material_symbols_icons/symbols.dart";

class JobDetails extends StatelessWidget {
  const JobDetails({super.key, required this.job});

  final Map<String, dynamic> job;

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _infoRow(IconData icon, String text, BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final jobType = job["jobType"] as String?;
    final isRemote = jobType == "Remote";
    final locationText = isRemote
        ? "Remote"
        : "${job["city"] ?? "Unknown"}, ${job["state"] ?? ""}";
    final locationIcon = isRemote
        ? Symbols.public_rounded
        : Symbols.location_on_rounded;

    final skills = List<String>.from(job["skills"] ?? []);
    final requirements = List<String>.from(job["requirements"] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text("Job Details"),
        actions: [
          IconButton(icon: Icon(Symbols.share_rounded), onPressed: null),
          IconButton(
            icon: Icon(Symbols.bookmark_border_rounded),
            onPressed: null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Card.outlined(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  spacing: 20,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        CompanyLogo(job: job),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            spacing: 4,
                            children: [
                              Text(
                                job["jobTitle"] ?? "Untitled",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              Text(
                                job["companyName"] ?? "",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            icon: Icon(Symbols.check_rounded),
                            label: Text("Apply Now"),
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Application submitted successfully!",
                                    ),
                                  ),
                                ),
                          ),
                        ),
                        OutlinedButton.icon(
                          icon: Icon(Symbols.bookmark_border_rounded),
                          label: Text("Save"),
                          onPressed: null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (job["description"] != null)
              Card.outlined(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      _sectionTitle(context, "Job Description"),
                      Text(
                        job["description"],
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            if (skills.isNotEmpty)
              Card.outlined(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      _sectionTitle(context, "Skills Required"),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: skills
                            .map(
                              (s) => Chip(
                                backgroundColor:
                                    theme.colorScheme.secondaryContainer,
                                side: BorderSide.none,
                                label: Text(
                                  s,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            if (requirements.isNotEmpty)
              Card.outlined(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      _sectionTitle(context, "Requirements"),
                      ...requirements.map(
                        (r) => _infoRow(
                          Symbols.check_circle_outline_rounded,
                          r,
                          context,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Card.outlined(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    _sectionTitle(context, "Job Information"),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                "Job Type",
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                jobType ?? "Not specified",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                "Location",
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Row(
                                spacing: 4,
                                children: [
                                  Icon(
                                    locationIcon,
                                    size: 16,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  Expanded(
                                    child: Text(
                                      locationText,
                                      style: theme.textTheme.titleSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
