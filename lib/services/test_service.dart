import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";

class TestService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<List<Map<String, dynamic>>> getUserTestHistory() {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection("test_results")
        .doc(currentUser.uid)
        .collection("attempts")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  static Future<void> submitTestAndSaveScore({
    required BuildContext context,
    required String testId,
    required String title,
    required List<Map<String, dynamic>> questions,
    required Map<int, String> selectedAnswers,
  }) async {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    const int totalQuestions = 20;
    const double passingThreshold = 80.0;
    int correctAnswers = 0;

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final selected = selectedAnswers[i];
      final correct = question["answer"] as String?;

      if (selected != null && selected == correct) {
        correctAnswers++;
      }
    }

    final double scorePercentage = (correctAnswers / totalQuestions) * 100.0;
    final String status = scorePercentage >= passingThreshold
        ? "Passed"
        : "Failed";

    final bool isPassed = status == "Passed";

    final Color backgroundColor = isPassed
        ? Colors.greenAccent.shade700
        : colorScheme.error;

    final Color foregroundColor = isPassed
        ? colorScheme.onPrimary
        : colorScheme.onError;

    final IconData statusIcon = isPassed
        ? Symbols.check_circle_rounded
        : Symbols.cancel_rounded;

    final Map<String, dynamic> scoreData = {
      "userId": currentUser.uid,
      "testId": testId,
      "testTitle": title,
      "score": correctAnswers,
      "percentage": scorePercentage,
      "totalQuestions": totalQuestions,
      "status": status,
      "timestamp": FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
          .collection("test_results")
          .doc(currentUser.uid)
          .collection("attempts")
          .add(scoreData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              spacing: 12,
              children: [
                Icon(statusIcon, color: foregroundColor),
                Text(
                  "Test Submitted! Status: $status (${scorePercentage.toStringAsFixed(1)}%)",
                  style: TextStyle(color: foregroundColor),
                ),
              ],
            ),
            backgroundColor: backgroundColor,
            duration: Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Submission failed: $e"),
            backgroundColor: colorScheme.error,
            duration: Duration(seconds: 7),
          ),
        );
      }
    }
  }

  static Future<Set<String>> getPassedSkills() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return {};

    try {
      final snapshot = await _firestore
          .collection("test_results")
          .doc(currentUser.uid)
          .collection("attempts")
          .where("status", isEqualTo: "Passed")
          .get();

      final Set<String> passedSkills = {};
      for (var doc in snapshot.docs) {
        final testTitle = doc.data()["testTitle"] as String?;
        if (testTitle != null) {
          final skillCode = testTitle.toLowerCase().split(" ")[0];
          passedSkills.add(skillCode);
        }
      }
      return passedSkills;
    } catch (e) {
      return {};
    }
  }
}
