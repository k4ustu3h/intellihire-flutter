import "package:flutter/material.dart";
import "package:intellihire/components/cards/test_card.dart";
import "package:intellihire/components/skeletons/cards/test_card_skeleton.dart";
import "package:intellihire/pages/tests/test_questions.dart";
import "package:intellihire/services/api_service.dart";
import "package:skeletonizer/skeletonizer.dart";

class Tests extends StatefulWidget {
  const Tests({super.key});

  @override
  State<Tests> createState() => _TestsState();
}

class _TestsState extends State<Tests> {
  late final Future<List<Map<String, dynamic>>> _testsFuture;

  @override
  void initState() {
    super.initState();
    _testsFuture = ApiService.fetchTests();
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.all(16);

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _testsFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == .waiting;
          final tests = snapshot.data ?? [];

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!isLoading && tests.isEmpty) {
            return const Center(child: Text("No tests available."));
          }

          if (isLoading) {
            return Skeletonizer(
              enabled: true,
              child: ListView.builder(
                padding: padding,
                itemCount: 5,
                itemBuilder: (context, index) => const TestCardSkeleton(),
              ),
            );
          }

          return ListView.builder(
            padding: padding,
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final test = tests[index];
              final testId = test["_id"].toString();
              final title = test["title"] as String;

              return TestCard(
                test: test,
                onStart: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TestQuestions(testId: testId, title: title),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
