import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/cards/job_card.dart";
import "package:intellihire/components/skeletons/jobs_skeleton.dart";
import "package:intellihire/services/api_service.dart";

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> bookmarkedJobs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();

      final List<dynamic> jobIds = List.from(
        doc.data()?["bookmarkedJobs"] ?? [],
      );
      final fetchedJobs = <Map<String, dynamic>>[];

      for (final id in jobIds) {
        try {
          final job = await ApiService.getJobById(id.toString());
          fetchedJobs.add(job);
        } catch (_) {}
      }

      setState(() {
        bookmarkedJobs = fetchedJobs;
        loading = false;
      });
    } catch (_) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookmarks")),
      body: loading
          ? const JobsSkeleton(chips: false)
          : bookmarkedJobs.isEmpty
          ? const Center(child: Text("No bookmarked jobs found."))
          : ListView.separated(
              padding: const .all(16),
              itemCount: bookmarkedJobs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) => JobCard(job: bookmarkedJobs[index]),
            ),
    );
  }
}
