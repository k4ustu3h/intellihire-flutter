import "package:flutter/material.dart";
import "package:intellihire/components/charts/test_average_chart.dart";
import "package:intellihire/components/lists/list_row.dart";
import "package:intellihire/components/loading/loading_indicator.dart";
import "package:intellihire/pages/profile/scores/test_attempt_history.dart";
import "package:intellihire/services/test_service.dart";
import "package:intellihire/util/code_labeler.dart";
import "package:material_symbols_icons/symbols.dart";

class MyScores extends StatelessWidget {
  const MyScores({super.key});

  Map<String, double> _getAverageScores(List<Map<String, dynamic>> scores) {
    final Map<String, List<double>> scoreMap = {};
    for (final score in scores) {
      final title = score["testId"] as String;
      final totalQuestions =
          (score["totalQuestions"] as num?)?.toDouble() ?? 1.0;
      final correct = (score["score"] as num?)?.toDouble() ?? 0.0;
      final percentage = (correct / totalQuestions) * 100.0;

      scoreMap.putIfAbsent(title, () => []).add(percentage);
    }

    final Map<String, double> averageScores = {};
    scoreMap.forEach((testId, values) {
      final average = values.reduce((a, b) => a + b) / values.length;
      averageScores[testId] = double.parse(average.toStringAsFixed(1));
    });
    return averageScores;
  }

  Map<String, List<Map<String, dynamic>>> _groupScoresByTest(
    List<Map<String, dynamic>> scores,
  ) {
    final Map<String, List<Map<String, dynamic>>> map = {};
    for (final score in scores) {
      final title = score["testId"] as String;
      map.putIfAbsent(title, () => []).add(score);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("My Scores")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: TestService.getUserTestHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final scores = snapshot.data ?? [];

          if (scores.isEmpty) {
            return const Center(
              child: Text(
                "You haven't completed any tests yet.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final averageScores = _getAverageScores(scores);
          final colorSchemeError = theme.colorScheme.error;
          final groupedScores = _groupScoresByTest(scores);
          final keys = averageScores.keys.toList();

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TestAverageChart(
                  scores: averageScores,
                  groupedScores: groupedScores,
                ),
              ),
              Column(
                spacing: 2,
                children: List.generate(keys.length, (index) {
                  final rawTitle = keys[index];
                  final title = labelForCode(rawTitle);
                  final average = averageScores[rawTitle]!;
                  final isPassed = average >= 80.0;
                  final color = isPassed
                      ? Colors.greenAccent.shade700
                      : colorSchemeError;

                  final attempts = groupedScores[rawTitle] ?? [];

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
                        Expanded(
                          child: Text(title, overflow: TextOverflow.ellipsis),
                        ),
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
                    title: const Text("Tests Attempted"),
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
