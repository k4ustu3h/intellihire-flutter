import "package:flutter/material.dart";
import "package:intellihire/components/cards/job_card.dart";
import "package:intellihire/components/skeletons/jobs_skeleton.dart";
import "package:intellihire/services/api_service.dart";

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<Map<String, dynamic>> _allJobs = [];
  List<Map<String, dynamic>> _filteredJobs = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchJobs();

    _searchController.addListener(() {
      final query = _searchController.text.trim().toLowerCase();
      setState(() {
        _filteredJobs = _allJobs.where((job) {
          final title = (job["jobTitle"] as String?)?.toLowerCase() ?? "";
          final company = (job["companyName"] as String?)?.toLowerCase() ?? "";
          final city = (job["city"] as String?)?.toLowerCase() ?? "";
          final state = (job["state"] as String?)?.toLowerCase() ?? "";
          final skills = (job["skills"] as List?)?.cast<String>() ?? [];
          final skillsString = skills.join(" ").toLowerCase();

          return title.contains(query) ||
              company.contains(query) ||
              city.contains(query) ||
              state.contains(query) ||
              skillsString.contains(query);
        }).toList();
      });
    });
  }

  Future<void> _fetchJobs() async {
    try {
      final jobs = await ApiService.fetchJobs();
      if (mounted) {
        setState(() {
          _allJobs = jobs;
          _filteredJobs = jobs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load jobs: $e")));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search jobs...",
            border: .none,
          ),
        ),
      ),
      body: _isLoading
          ? const JobsSkeleton(chips: false)
          : _filteredJobs.isEmpty
          ? const Center(child: Text("No jobs match your search."))
          : ListView.separated(
              padding: const .all(16),
              itemCount: _filteredJobs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) =>
                  JobCard(job: _filteredJobs[index]),
            ),
    );
  }
}
