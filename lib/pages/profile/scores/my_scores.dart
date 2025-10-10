import "package:expressive_loading_indicator/expressive_loading_indicator.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/appbars/top_app_bar.dart";
import "package:intellihire/components/charts/test_average_chart.dart";
import "package:intellihire/components/lists/list_row.dart";
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
      appBar: TopAppBar(title: "My Scores"),
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
          final keys = averageScores.keys.toList();

          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: TestAverageChart(
                  scores: averageScores,
                  groupedScores: groupedScores,
                ),
              ),

              Column(
                spacing: 2,
                children: List.generate(keys.length, (index) {
                  final title = keys[index];
                  final average = averageScores[title]!;
                  final isPassed = average >= 80.0;
                  final color = isPassed
                      ? Colors.greenAccent.shade700
                      : theme.colorScheme.error;

                  final attempts = groupedScores[title] ?? [];

                  return ListRow.navigate(
                    startIcon: Icon(
                      isPassed
                          ? Symbols.check_circle_rounded
                          : Symbols.cancel_rounded,
                      color: color,
                    ),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title),
                        Text(
                          "${average.toStringAsFixed(1)}%",
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    first: index == 0,
                    last: index == keys.length - 1,
                    title: Text("Tests Attempted"),
                    navigateTo: TestAttemptHistory(
                      title: title,
                      attempts: attempts,
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
