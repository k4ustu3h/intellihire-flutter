import "package:expressive_loading_indicator/expressive_loading_indicator.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/top_app_bar.dart";
import "package:intellihire/services/api_service.dart";
import "package:material_symbols_icons/material_symbols_icons.dart";

class TestQuestions extends StatefulWidget {
  final String testId;
  final String title;

  const TestQuestions({super.key, required this.testId, required this.title});

  @override
  State<TestQuestions> createState() => _TestQuestionsState();
}

class _TestQuestionsState extends State<TestQuestions> {
  late final Future<List<Map<String, dynamic>>> _questionsFuture;

  final Map<int, String> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _questionsFuture = ApiService.fetchTestQuestions(widget.testId);
  }

  Widget _buildStyledText(
    BuildContext context,
    String text, {
    TextStyle? baseStyle,
  }) {
    final theme = Theme.of(context);
    final List<TextSpan> spans = [];

    final RegExp codeRegex = RegExp(r"`([^`]+)`");
    int lastMatchEnd = 0;

    final TextStyle codeStyle = theme.textTheme.labelLarge!.copyWith(
      fontFamily: "monospace",
      fontWeight: FontWeight.w600,
      backgroundColor: theme.colorScheme.surfaceVariant,
      color: theme.colorScheme.onSurfaceVariant,
    );

    final TextStyle normalStyle =
        baseStyle ??
        theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600);

    for (final match in codeRegex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: normalStyle,
          ),
        );
      }

      spans.add(TextSpan(text: match.group(1), style: codeStyle));

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(text: text.substring(lastMatchEnd), style: normalStyle),
      );
    }

    return RichText(
      text: TextSpan(style: normalStyle, children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: TopAppBar(title: widget.title),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ExpressiveLoadingIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final questions = snapshot.data ?? [];
          if (questions.isEmpty) {
            return Center(child: Text("No questions found."));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final q = questions[index];
                    final options = List<String>.from(q["options"]);

                    return Card.outlined(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                Text(
                                  "Q${index + 1}",
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                _buildStyledText(context, q["question"]),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: options.map((opt) {
                                final optionStyle = theme.textTheme.bodyMedium;

                                return RadioListTile<String>(
                                  activeColor: theme.colorScheme.primary,
                                  groupValue: _selectedAnswers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAnswers[index] = value!;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  title: _buildStyledText(
                                    context,
                                    opt,
                                    baseStyle: optionStyle,
                                  ),
                                  value: opt,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: FilledButton.icon(
                  icon: Icon(Symbols.check_rounded),
                  label: Text("Submit"),
                  onPressed: _selectedAnswers.length == questions.length
                      ? () {
                          debugPrint("Submitted answers: $_selectedAnswers");
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
