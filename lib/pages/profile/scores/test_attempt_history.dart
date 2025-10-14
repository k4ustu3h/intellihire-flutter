import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/lists/list_row.dart";
import "package:material_symbols_icons/symbols.dart";

class TestAttemptHistory extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> attempts;

  const TestAttemptHistory({
    super.key,
    required this.title,
    required this.attempts,
  });

  Widget _buildStartIcon(IconData icon, Color color, double percentage) {
    const double size = 48;
    const double iconRadius = 24;

    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: percentage / 100),
        duration: Duration(seconds: 1),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: color.withValues(alpha: 0.15),
                color: color,
                strokeWidth: 4,
                strokeCap: StrokeCap.round,
                value: value,
              ),
              Icon(icon, color: color, size: iconRadius),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sortedAttempts = List<Map<String, dynamic>>.from(attempts)
      ..sort((a, b) {
        final aTime = (a["timestamp"] as Timestamp?)?.toDate() ?? DateTime(0);
        final bTime = (b["timestamp"] as Timestamp?)?.toDate() ?? DateTime(0);
        return bTime.compareTo(aTime);
      });

    final attemptsCount = sortedAttempts.length;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: ListRow.basePadding),
        child: Column(
          spacing: 2,
          children: List.generate(attemptsCount, (index) {
            final attempt = sortedAttempts[index];

            final score = (attempt["score"] as num?)?.toInt() ?? 0;
            final total = (attempt["totalQuestions"] as num?)?.toInt() ?? 20;
            final passed = attempt["passed"] as bool? ?? false;

            final double percentage = ((score / total) * 100).clamp(0, 100);
            final timestamp =
                (attempt["timestamp"] as Timestamp?)?.toDate() ??
                DateTime.now();

            final color = passed
                ? Colors.greenAccent.shade700
                : theme.colorScheme.error;
            final icon = passed
                ? Symbols.check_circle_rounded
                : Symbols.cancel_rounded;

            final dateStr =
                "${timestamp.day.toString().padLeft(2, '0')}/"
                "${timestamp.month.toString().padLeft(2, '0')}/"
                "${timestamp.year}";
            final timeStr =
                "${timestamp.hour.toString().padLeft(2, '0')}:"
                "${timestamp.minute.toString().padLeft(2, '0')}";

            final attemptNumber = attemptsCount - index;

            return ListRow(
              label: Text("Attempt $attemptNumber | Score: $score/$total"),
              description: Text(
                "${passed ? 'Passed' : 'Failed'} • ${percentage.toStringAsFixed(1)}%",
              ),
              startIcon: _buildStartIcon(icon, color, percentage),
              endIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    dateStr,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    timeStr,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              first: index == 0,
              last: index == attemptsCount - 1,
              onClick: null,
            );
          }),
        ),
      ),
    );
  }
}
