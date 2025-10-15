import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";

class FilterChipButton extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final IconData icon;
  final VoidCallback? onTap;

  const FilterChipButton({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final displayLabel = selectedValue ?? label;

    final isSelected = selectedValue != null;

    final Color backgroundColor = isSelected
        ? theme.secondaryContainer
        : theme.surface;
    final Color foregroundColor = isSelected
        ? theme.onSecondaryContainer
        : theme.onSurface;

    return InputChip(
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? theme.onSecondaryContainer : theme.primary,
      ),
      backgroundColor: backgroundColor,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Text(displayLabel, style: TextStyle(color: foregroundColor)),
          Icon(
            Symbols.arrow_drop_down_rounded,
            size: 18,
            color: foregroundColor,
          ),
        ],
      ),
      onPressed: onTap,
      selectedColor: theme.secondaryContainer,
      selected: isSelected,
      showCheckmark: false,
    );
  }
}
