class JobSuggester {
  static List<Map<String, dynamic>> suggest({
    required List<Map<String, dynamic>> jobs,
    required Set<String> userSkills,
    required String userCity,
    required String userState,
  }) {
    if (jobs.isEmpty) return const [];

    final normalizedUserCity = userCity.trim();
    final normalizedUserState = userState.trim();
    final bool hasUserSkills = userSkills.isNotEmpty;

    final Set<String> skillLookup = hasUserSkills ? userSkills : <String>{};

    final List<Map<String, dynamic>> scoredJobs = [];

    for (final job in jobs) {
      final List<String> jobSkills = List<String>.from(
        job["skills"] ?? const [],
      );
      final int numMatchingSkills = hasUserSkills
          ? jobSkills.where((skill) => skillLookup.contains(skill)).length
          : 0;

      final String jobType = job["jobType"] as String? ?? "";
      final String jobCity = (job["city"] as String? ?? "").trim();
      final String jobState = (job["state"] as String? ?? "").trim();

      int locationScore = 0;
      if (jobType == "Remote") locationScore += 1;
      if (normalizedUserState.isNotEmpty && jobState == normalizedUserState) {
        locationScore += 2;
      }
      if (normalizedUserCity.isNotEmpty && jobCity == normalizedUserCity) {
        locationScore += 3;
      }

      final int score = numMatchingSkills * 10 + locationScore;

      if (!hasUserSkills || numMatchingSkills > 0) {
        scoredJobs.add({
          ...job,
          "__score": score,
          "__matches": numMatchingSkills,
        });
      }
    }

    scoredJobs.sort((a, b) {
      final int scoreDiff = (b["__score"] as int).compareTo(
        a["__score"] as int,
      );
      return scoreDiff != 0
          ? scoreDiff
          : (b["__matches"] as int).compareTo(a["__matches"] as int);
    });

    return scoredJobs.map((job) {
      final copy = Map<String, dynamic>.from(job);
      copy.remove("__score");
      copy.remove("__matches");
      return copy;
    }).toList();
  }
}
