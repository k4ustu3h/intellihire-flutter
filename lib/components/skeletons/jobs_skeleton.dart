import "package:flutter/material.dart";
import "package:intellihire/components/skeletons/cards/job_card_skeleton.dart";
import "package:intellihire/components/skeletons/chips/filter_chip_skeleton.dart";
import "package:skeletonizer/skeletonizer.dart";

class JobsSkeleton extends StatelessWidget {
  const JobsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              spacing: 8,
              children: [
                FilterChipSkeleton(),
                FilterChipSkeleton(),
                FilterChipSkeleton(),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              "Showing 00 of 00 jobs.",
              style: theme.textTheme.bodySmall,
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) => JobCardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}
