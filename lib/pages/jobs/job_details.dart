import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:intellihire/components/icons/company_logo.dart";
import "package:intellihire/util/code_labeler.dart";
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

  String colorToHex(Color color) =>
      color.toARGB32().toRadixString(16).substring(2).toUpperCase();

  Widget _buildCard({required Widget child}) {
    return Card.outlined(
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final jobType = job["jobType"] as String?;
    final isRemote = jobType == "Remote";
    final locationText = isRemote
        ? ""
        : "${job["city"] ?? "Unknown"}, ${job["state"] ?? ""}";

    final skills = List<String>.from(job["skills"] ?? []);

    final defaultColor = colorToHex(theme.colorScheme.onSecondaryContainer);

    final headlineStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final titleMediumStyle = theme.textTheme.titleMedium?.copyWith(
      color: theme.colorScheme.primary,
    );
    final labelMediumStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSecondaryContainer,
    );

    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        actions: const [
          IconButton(icon: Icon(Symbols.share_rounded), onPressed: null),
          IconButton(
            icon: Icon(Symbols.bookmark_border_rounded),
            onPressed: null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            _buildCard(
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
                              style: headlineStyle,
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              job["companyName"] ?? "",
                              style: titleMediumStyle,
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
                          icon: const Icon(Symbols.check_rounded),
                          label: const Text("Apply Now"),
                          onPressed: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Application submitted successfully!",
                                  ),
                                ),
                              ),
                        ),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Symbols.bookmark_border_rounded),
                        label: const Text("Save"),
                        onPressed: null,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (job["description"] != null)
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    _sectionTitle(context, "Job Description"),
                    Text(job["description"], style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),

            if (skills.isNotEmpty)
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    _sectionTitle(context, "Skills Required"),
                    Wrap(
                      spacing: 16,
                      children: skills.map((skill) {
                        final label = labelForCode(skill);
                        return Chip(
                          backgroundColor: theme.colorScheme.secondaryContainer,
                          side: BorderSide.none,
                          avatar: SvgPicture.network(
                            "https://cdn.simpleicons.org/$skill/$defaultColor",
                            width: 18,
                            height: 18,
                            placeholderBuilder: (context) => Icon(
                              Symbols.code_rounded,
                              size: 18,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                          label: Text(label, style: labelMediumStyle),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            _buildCard(
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
                              style: theme.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: onSurfaceVariant,
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
                      if (!isRemote)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                "Location",
                                style: theme.textTheme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: onSurfaceVariant,
                                ),
                              ),
                              Row(
                                spacing: 4,
                                children: [
                                  Icon(
                                    Symbols.location_on_rounded,
                                    size: 16,
                                    color: onSurface,
                                  ),
                                  Expanded(
                                    child: Text(
                                      locationText,
                                      style: theme.textTheme.titleSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: onSurface,
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
          ],
        ),
      ),
    );
  }
}
