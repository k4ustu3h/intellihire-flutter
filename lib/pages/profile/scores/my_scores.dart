import "package:expressive_loading_indicator/expressive_loading_indicator.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/charts/test_average_chart.dart";
import "package:intellihire/components/top_app_bar.dart";
import "package:intellihire/pages/profile/scores/test_attempt_history.dart";
import "package:intellihire/services/test_service.dart";
import "package:material_symbols_icons/symbols.dart";

class MyScores extends StatelessWidget {
  const MyScores({super.key});

  Map<String, double> _getAverageScores(List<Map<String, dynamic>> scores) {
    final Map<String, List<double>> scoreMap = {};
    for (var score in scores) {
      final title = score["testTitle"] as String? ?? "Unknown Test";
      final percentage = (score["percentage"] as num?)?.toDouble() ?? 0.0;
      scoreMap.putIfAbsent(title, () => []).add(percentage);
    }
    final Map<String, double> averageScores = {};
    scoreMap.forEach((title, percentages) {
      final average = percentages.reduce((a, b) => a + b) / percentages.length;
      averageScores[title] = double.parse(average.toStringAsFixed(1));
    });
    return averageScores;
  }

  Map<String, List<Map<String, dynamic>>> _groupScoresByTest(
    List<Map<String, dynamic>> scores,
  ) {
    final Map<String, List<Map<String, dynamic>>> map = {};
    for (var score in scores) {
      final title = score["testTitle"] as String? ?? "Unknown Test";
      map.putIfAbsent(title, () => []).add(score);
    }
    return map;
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

          final averageScores = _getAverageScores(scores);
          final groupedScores = _groupScoresByTest(scores);
          final theme = Theme.of(context);

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: TestAverageChart(
                  scores: averageScores,
                  groupedScores: groupedScores,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  "Tests Attempted",
                  style: theme.textTheme.titleMedium,
                ),
              ),

              Card.outlined(
                child: Column(
                  children: averageScores.entries.map((entry) {
                    final title = entry.key;
                    final average = entry.value;
                    final isPassed = average >= 80.0;
                    final color = isPassed
                        ? Colors.greenAccent.shade700
                        : theme.colorScheme.error;

                    return ListTile(
                      leading: Icon(
                        isPassed
                            ? Symbols.check_circle_rounded
                            : Symbols.cancel_rounded,
                        color: color,
                      ),
                      title: Text(title),
                      trailing: Text(
                        "${average.toStringAsFixed(1)}%",
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        final attempts = groupedScores[title] ?? [];
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TestAttemptHistory(
                              title: title,
                              attempts: attempts,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
