const Map<String, String> skillLabelMap = {
  "cpp": "C++",
  "dsa": "DSA (Data Structures & Algorithms)",
  "flutter": "Flutter",
  "javascript": "JavaScript",
  "python": "Python",
  "sql": "SQL",
  "dart": "Dart",
};

String getSkillDisplayLabel(String code) {
  final cleanCode = code.trim().toLowerCase();
  return skillLabelMap[cleanCode] ?? code;
}

String? getSkillCodeFromLabel(String label) {
  final entry = skillLabelMap.entries.firstWhere(
    (entry) => entry.value == label,
    orElse: () => const MapEntry("", ""),
  );
  return entry.key.isNotEmpty ? entry.key : null;
}
