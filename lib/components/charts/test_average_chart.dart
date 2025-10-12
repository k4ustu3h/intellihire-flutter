import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:intellihire/pages/profile/scores/test_attempt_history.dart";
import "package:intellihire/util/code_labeler.dart";
import "package:motor/motor.dart";

class TestAverageChart extends StatefulWidget {
  final Map<String, double> scores;
  final Map<String, List<Map<String, dynamic>>> groupedScores;

  const TestAverageChart({
    super.key,
    required this.scores,
    required this.groupedScores,
  });

  @override
  State<TestAverageChart> createState() => _TestAverageChartState();
}

class _TestAverageChartState extends State<TestAverageChart> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titles = widget.scores.keys.toList();
    final values = widget.scores.values.toList();

    if (titles.isEmpty) return SizedBox.shrink();

    final double screenWidth = MediaQuery.of(context).size.width - 72;
    final double totalWidth = titles.length * 60.0;

    return Card.outlined(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: MotionBuilder<List<double>>(
                    motion: MaterialSpringMotion.expressiveEffectsDefault(),
                    value: values,
                    from: List.filled(values.length, 0.0),
                    converter: MotionConverter.custom(
                      normalize: (list) => list.cast<double>(),
                      denormalize: (list) => list,
                    ),
                    builder: (context, animatedValues, child) {
                      return BarChart(
                        BarChartData(
                          barGroups: List.generate(titles.length, (index) {
                            final value = animatedValues[index];
                            final isPassed =
                                widget.scores[titles[index]]! >= 80.0;
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
                          maxY: 100,
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
                              getTooltipColor: (_) =>
                                  theme.colorScheme.surfaceVariant,
                              tooltipPadding: EdgeInsets.all(8),
                              tooltipBorderRadius: BorderRadius.circular(8),
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
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
                              final index =
                                  response?.spot?.touchedBarGroupIndex;
                              if (index == null ||
                                  index < 0 ||
                                  index >= titles.length) {
                                return;
                              }

                              final rawTestId = titles[index];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TestAttemptHistory(
                                    title: labelForCode(rawTestId),
                                    attempts:
                                        widget.groupedScores[rawTestId] ?? [],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
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
