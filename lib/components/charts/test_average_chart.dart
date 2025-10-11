import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:intellihire/pages/profile/scores/test_attempt_history.dart";
import "package:intellihire/util/code_labeler.dart";

class TestAverageChart extends StatelessWidget {
  final Map<String, double> scores;
  final Map<String, List<Map<String, dynamic>>> groupedScores;

  const TestAverageChart({
    super.key,
    required this.scores,
    required this.groupedScores,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titles = scores.keys.toList();
    final values = scores.values.toList();

    if (titles.isEmpty) return SizedBox.shrink();

    final totalWidth = titles.length * 60.0;

    final double screenWidth = MediaQuery.of(context).size.width - 72;

    return Card.outlined(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            Text(
              "Average Score by Test",
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: totalWidth < screenWidth ? screenWidth : totalWidth,
                height: 300,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: BarChart(
                    BarChartData(
                      barGroups: List.generate(titles.length, (index) {
                        final value = values[index];
                        final isPassed = value >= 80.0;
                        final color = isPassed
                            ? theme.colorScheme.primary
                            : theme.colorScheme.error;

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: value,
                              color: color,
                              width: 24,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                          showingTooltipIndicators: [0],
                        );
                      }),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),

                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) =>
                                Text("${value.toInt()}%"),
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= titles.length) {
                                return SizedBox.shrink();
                              }
                              final rawTestId = titles[index];
                              final label = labelForCode(rawTestId);
                              return Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: SizedBox(
                                  width: 60,
                                  child: Text(
                                    label,
                                    style: theme.textTheme.labelSmall,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      barTouchData: BarTouchData(
                        enabled: true,
                        handleBuiltInTouches: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) =>
                              theme.colorScheme.surfaceVariant,
                          tooltipPadding: EdgeInsets.all(8),
                          tooltipBorderRadius: BorderRadius.circular(8),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final rawTestId = titles[group.x];
                            final label = labelForCode(rawTestId);
                            return BarTooltipItem(
                              "$label\n${rod.toY.toStringAsFixed(1)}%",
                              TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        touchCallback: (event, response) {
                          if (event is! FlTapUpEvent) return;

                          if (response != null && response.spot != null) {
                            final index = response.spot!.touchedBarGroupIndex;
                            if (index >= 0 && index < titles.length) {
                              final rawTestId = titles[index];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TestAttemptHistory(
                                    title: labelForCode(rawTestId),
                                    attempts: groupedScores[rawTestId] ?? [],
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      maxY: 100,
                    ),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
