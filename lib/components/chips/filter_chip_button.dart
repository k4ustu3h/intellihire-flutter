import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";

class FilterChipButton extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final IconData icon;
  final VoidCallback onTap;
  final bool showTrailingIcon;

  const FilterChipButton({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.icon,
    required this.onTap,
    this.showTrailingIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final displayLabel = selectedValue ?? label;

    final isSelected = selectedValue != null;

    return InputChip(
      avatar: Icon(icon, size: 18),
      backgroundColor: isSelected ? theme.secondaryContainer : theme.surface,
      label: Text(displayLabel),
      labelStyle: TextStyle(
        color: isSelected ? theme.onSecondaryContainer : theme.onSurface,
      ),
      deleteIcon: showTrailingIcon
          ? Icon(
              Symbols.arrow_drop_down_rounded,
              size: 18,
              color: isSelected ? theme.onSecondaryContainer : theme.onSurface,
            )
          : null,
      iconTheme: IconThemeData(
        color: isSelected ? theme.onSecondaryContainer : theme.primary,
      ),
      onDeleted: showTrailingIcon ? onTap : null,
      onPressed: onTap,
    );
  }
}
