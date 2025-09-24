import "package:flutter/material.dart";
import "package:intellihire/components/cards/job_card.dart";
import "package:intellihire/components/skeletons/job_card_skeleton.dart";
import "package:intellihire/services/jobs_service.dart";
import "package:skeletonizer/skeletonizer.dart";

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  late final Future<List<Map<String, dynamic>>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = JobsService.fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final jobs = snapshot.data ?? [];
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!isLoading && jobs.isEmpty) {
            return Center(child: Text("No jobs found."));
          }
          if (isLoading) {
            return Skeletonizer(
              enabled: true,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) => JobCardSkeleton(),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) => JobCard(job: jobs[index]),
          );
        },
      ),
    );
  }
}
