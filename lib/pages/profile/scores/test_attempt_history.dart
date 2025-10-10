import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/top_app_bar.dart";
import "package:material_symbols_icons/symbols.dart";

class TestAttemptHistory extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> attempts;

  const TestAttemptHistory({
    super.key,
    required this.title,
    required this.attempts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sortedAttempts = List<Map<String, dynamic>>.from(attempts);
    sortedAttempts.sort((a, b) {
      final aTime = (a["timestamp"] as Timestamp?) ?? Timestamp.now();
      final bTime = (b["timestamp"] as Timestamp?) ?? Timestamp.now();
      return bTime.compareTo(aTime);
    });

    return Scaffold(
      appBar: TopAppBar(title: title),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        itemCount: sortedAttempts.length,
        separatorBuilder: (_, _) => Divider(height: 1),
        itemBuilder: (context, index) {
          final attempt = sortedAttempts[index];
          final score = attempt["score"] as int? ?? 0;
          final total = attempt["totalQuestions"] as int? ?? 20;
          final percentage = (attempt["percentage"] as num?)?.toDouble() ?? 0.0;
          final status = attempt["status"] as String? ?? "Pending";
          final timestamp =
              (attempt["timestamp"] as Timestamp?)?.toDate() ?? DateTime.now();

          final isPassed = status.toLowerCase() == "passed";
          final statusColor = isPassed
              ? Colors.greenAccent.shade700
              : theme.colorScheme.error;
          final statusIcon = isPassed
              ? Symbols.check_circle_rounded
              : Symbols.cancel_rounded;

          final formattedTime =
              "${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, "0")}";

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            leading: Icon(statusIcon, color: statusColor),
            title: Text(
              "Attempt ${sortedAttempts.length - index} (Score: $score/$total)",
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              "$status • ${percentage.toStringAsFixed(1)}%",
              style: theme.textTheme.bodyMedium!.copyWith(color: statusColor),
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
            isThreeLine: false,
          );
        },
      ),
    );
  }
}
