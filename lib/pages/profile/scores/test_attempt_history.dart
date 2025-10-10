import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/appbars/top_app_bar.dart";
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: color.withValues(alpha: 0.15),
            color: color,
            strokeCap: StrokeCap.round,
            value: percentage / 100,
          ),
          Icon(icon, color: color, size: iconRadius),
        ],
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
      appBar: TopAppBar(title: title),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: ListRow.basePadding),
        child: Column(
          spacing: 2,
          children: List.generate(attemptsCount, (index) {
            final attempt = sortedAttempts[index];
            final score = attempt["score"] as int? ?? 0;
            final total = attempt["totalQuestions"] as int? ?? 20;
            final percentage =
                (attempt["percentage"] as num?)?.toDouble() ?? 0.0;
            final status = (attempt["status"] as String?) ?? "Pending";
            final timestamp =
                (attempt["timestamp"] as Timestamp?)?.toDate() ??
                DateTime.now();

            final isPassed = status.toLowerCase() == "passed";
            final statusColor = isPassed
                ? Colors.greenAccent.shade700
                : theme.colorScheme.error;
            final statusIcon = isPassed
                ? Symbols.check_circle_rounded
                : Symbols.cancel_rounded;

            final formattedTime =
                "${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, "0")}";

            final attemptNumber = attemptsCount - index;

            return ListRow(
              label: Text("Attempt $attemptNumber | Score: $score/$total"),
              description: Text("$status • ${percentage.toStringAsFixed(1)}%"),
              startIcon: _buildStartIcon(statusIcon, statusColor, percentage),
              endIcon: Text(
                formattedTime,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
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
