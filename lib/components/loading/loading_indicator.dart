import "package:expressive_loading_indicator/expressive_loading_indicator.dart";
import "package:flutter/material.dart";

class LoadingIndicator extends StatelessWidget {
  final Color? backgroundColor;
  final Color? color;

  const LoadingIndicator({super.key, this.backgroundColor, this.color});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: ExpressiveLoadingIndicator(color: color),
    );
  }
}
