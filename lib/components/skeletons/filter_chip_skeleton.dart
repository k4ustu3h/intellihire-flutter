import "package:flutter/material.dart";

class FilterChipSkeleton extends StatelessWidget {
  const FilterChipSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 108,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
