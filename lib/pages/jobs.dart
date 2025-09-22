import "package:flutter/material.dart";
import "package:intellihire/components/cards/job_card.dart";
import "package:intellihire/services/mongodb_service.dart";

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
    _jobsFuture = MongoDatabase.getJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final jobs = snapshot.data;
          if (jobs == null || jobs.isEmpty) {
            return Center(child: Text("No jobs found."));
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
