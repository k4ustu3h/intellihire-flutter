class JobSuggester {
  static List<Map<String, dynamic>> suggest({
    required List<Map<String, dynamic>> jobs,
    required Set<String> userSkills,
    required String userCity,
    required String userState,
  }) {
    if (jobs.isEmpty) return jobs;

    final normalizedUserCity = userCity.trim();
    final normalizedUserState = userState.trim();

    final scoredJobs = jobs.map((job) {
      final jobSkills = List<String>.from(job["skills"] ?? const []);
      final numMatchingSkills = userSkills.isEmpty
          ? 0
          : jobSkills.where(userSkills.contains).length;

      final jobType = job["jobType"] as String? ?? "";
      final jobCity = (job["city"] as String? ?? "").trim();
      final jobState = (job["state"] as String? ?? "").trim();

      int locationScore = 0;
      if (jobType == "Remote") locationScore += 1;
      if (normalizedUserState.isNotEmpty && jobState == normalizedUserState) {
        locationScore += 2;
      }
      if (normalizedUserCity.isNotEmpty && jobCity == normalizedUserCity) {
        locationScore += 3;
      }

      final score = numMatchingSkills * 10 + locationScore;

      return {...job, "__score": score, "__matches": numMatchingSkills};
    }).toList();

    final filtered = userSkills.isEmpty
        ? scoredJobs
        : scoredJobs.where((j) => (j["__matches"] as int) > 0).toList();

    filtered.sort((a, b) {
      final scoreDiff = (b["__score"] as int).compareTo(a["__score"] as int);
      if (scoreDiff != 0) return scoreDiff;
      return (b["__matches"] as int).compareTo(a["__matches"] as int);
    });

    return filtered.map((j) {
      final copy = Map<String, dynamic>.from(j);
      copy.remove("__score");
      copy.remove("__matches");
      return copy;
    }).toList();
  }
}
