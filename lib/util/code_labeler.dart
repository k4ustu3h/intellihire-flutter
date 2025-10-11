const Map<String, String> codeLabels = {
  "cpp": "C++",
  "dart": "Dart",
  "dsa": "DSA (Data Structures & Algorithms)",
  "flutter": "Flutter",
  "javascript": "JavaScript",
  "python": "Python",
  "sql": "SQL",
};

String labelForCode(String code) {
  final normalizedCode = code.trim().toLowerCase();
  return codeLabels[normalizedCode] ?? code;
}

String? codeForLabel(String label) {
  final entry = codeLabels.entries.firstWhere(
    (entry) => entry.value == label,
    orElse: () => MapEntry("", ""),
  );
  return entry.key.isNotEmpty ? entry.key : null;
}
