import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/cards/job_card.dart";
import "package:intellihire/components/skeletons/jobs_skeleton.dart";
import "package:intellihire/services/api_service.dart";
import "package:intellihire/services/test_service.dart";
import "package:material_symbols_icons/symbols.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final Future<List<Map<String, dynamic>>> _jobsFuture;

  Set<String> _userPassedSkills = {};
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _jobsFuture = _fetchAndFilterJobs();
  }

  Future<List<Map<String, dynamic>>> _fetchAndFilterJobs() async {
    final results = await Future.wait([
      ApiService.fetchJobs(),
      TestService.getPassedSkills(),
    ]);

    final fetchedJobs = results[0] as List<Map<String, dynamic>>;
    final fetchedSkills = results[1] as Set<String>;

    if (fetchedJobs.isEmpty) return fetchedJobs;

    final relevantJobs = fetchedJobs.where((job) {
      if (fetchedSkills.isEmpty) {
        return false;
      }

      final jobSkills = List<String>.from(job["skills"]);

      return jobSkills.any(fetchedSkills.contains);
    }).toList();

    if (mounted) {
      setState(() {
        _userPassedSkills = fetchedSkills;
      });
    }
    return relevantJobs;
  }

  Widget _buildGreeting(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = _user?.displayName ?? "IntelliHire User";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            "Hello, ${displayName.split(' ')[0]}",
            style: theme.textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Let's land your dream job",
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _jobsFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final jobs = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(context),
            Expanded(
              child: isLoading
                  ? JobsSkeleton()
                  : jobs.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 16,
                          children: [
                            Icon(
                              Symbols.lightbulb_rounded,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Text(
                              _userPassedSkills.isEmpty
                                  ? "Complete your first assessment to unlock personalized jobs!"
                                  : "No jobs matching your passed skills found.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) =>
                          JobCard(job: jobs[index]),
                    ),
            ),
          ],
        );
      },
    );
  }
}
