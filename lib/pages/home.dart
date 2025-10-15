import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/cards/job_card.dart";
import "package:intellihire/components/skeletons/cards/suggested_jobs_skeleton.dart";
import "package:intellihire/models/user_profile.dart";
import "package:intellihire/services/api_service.dart";
import "package:intellihire/services/test_service.dart";
import "package:intellihire/services/user_service.dart";
import "package:intellihire/util/job_suggester.dart";
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
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _jobsFuture = _loadSuggestedJobs();
  }

  Future<List<Map<String, dynamic>>> _loadSuggestedJobs() async {
    final uid = _user?.uid;
    final results = await Future.wait([
      ApiService.fetchJobs(),
      TestService.getPassedSkills(),
      if (uid != null) _userService.getUserProfile(uid) else Future.value(null),
    ]);

    final fetchedJobs = results[0] as List<Map<String, dynamic>>;
    final fetchedSkills = results[1] as Set<String>;
    final userProfile = results.length > 2 ? results[2] as UserProfile? : null;

    if (mounted) setState(() => _userPassedSkills = fetchedSkills);

    if (fetchedJobs.isEmpty) return [];

    return JobSuggester.suggest(
      jobs: fetchedJobs,
      userSkills: fetchedSkills,
      userCity: userProfile?.city ?? "",
      userState: userProfile?.state ?? "",
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = _user?.displayName ?? "IntelliHire User";
    final firstName = displayName.split(" ").first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            "Hello, $firstName",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Let's land your dream job",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 16.0;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _jobsFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final jobs = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            _buildGreeting(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Jobs suggested for you",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            isLoading
                ? const SuggestedJobsSkeleton()
                : jobs.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
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
                : SizedBox(
                    height: 210,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: jobs.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) => SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: JobCard(job: jobs[index]),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
