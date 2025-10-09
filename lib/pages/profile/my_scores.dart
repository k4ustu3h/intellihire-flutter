import "package:cloud_firestore/cloud_firestore.dart";
import "package:expressive_loading_indicator/expressive_loading_indicator.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/top_app_bar.dart";
import "package:intellihire/services/test_service.dart";
import "package:material_symbols_icons/symbols.dart";

class MyScores extends StatelessWidget {
  const MyScores({super.key});

  Map<String, List<Map<String, dynamic>>> _groupScoresByTest(
    List<Map<String, dynamic>> scores,
  ) {
    final Map<String, List<Map<String, dynamic>>> map = {};
    for (var score in scores) {
      final title = score["testTitle"] as String? ?? "Unknown Test";
      if (!map.containsKey(title)) {
        map[title] = [];
      }
      map[title]!.add(score);
    }
    return map;
  }

  Widget _buildTestGroup(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> attempts,
  ) {
    final theme = Theme.of(context);

    attempts.sort(
      (a, b) =>
          (b["timestamp"] as Timestamp).compareTo(a["timestamp"] as Timestamp),
    );

    return Card(
      margin: EdgeInsets.only(bottom: 20),
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: true,
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        title: Text(
          title,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text("${attempts.length} attempts recorded"),
        children: attempts.map((attempt) {
          final score = attempt["score"] as int? ?? 0;
          final total = attempt["totalQuestions"] as int? ?? 20;
          final percentage = attempt["percentage"] as double? ?? 0;
          final status = attempt["status"] as String? ?? "Pending";
          final timestamp =
              (attempt["timestamp"] as Timestamp?)?.toDate() ?? DateTime.now();

          final isPassed = status == "Passed";
          final statusColor = isPassed
              ? Colors.greenAccent.shade700
              : theme.colorScheme.error;
          final statusIcon = isPassed
              ? Symbols.check_circle_rounded
              : Symbols.cancel_rounded;

          final formattedTime =
              "${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute}";

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            leading: Icon(statusIcon, color: statusColor),
            title: Text(
              "Score: $score/$total (${percentage.toStringAsFixed(1)}%)",
              style: theme.textTheme.bodyLarge!.copyWith(color: statusColor),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  status,
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: statusColor,
                  ),
                ),
                Text(formattedTime, style: theme.textTheme.labelSmall),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(title: "My Test History"),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: TestService.getUserTestHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ExpressiveLoadingIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final scores = snapshot.data ?? [];

          if (scores.isEmpty) {
            return Center(
              child: Text(
                "You haven't completed any tests yet.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final groupedScores = _groupScoresByTest(scores);

          return ListView(
            padding: EdgeInsets.all(16),
            children: groupedScores.entries.map((entry) {
              return _buildTestGroup(context, entry.key, entry.value);
            }).toList(),
          );
        },
      ),
    );
  }
}
