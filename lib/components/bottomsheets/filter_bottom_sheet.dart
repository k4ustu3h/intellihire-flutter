import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";

class FilterBottomSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onSelected;

  const FilterBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: theme.textTheme.titleSmall),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildFilterTile(
                  context: context,
                  title: "All",
                  isSelected: selectedValue == null,
                  onTap: () {
                    onSelected(null);
                    Navigator.pop(context);
                  },
                ),
                ...options.map(
                  (option) => _buildFilterTile(
                    context: context,
                    title: option,
                    isSelected: selectedValue == option,
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTile({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: isSelected
          ? Icon(Symbols.check_rounded, color: theme.colorScheme.primary)
          : const SizedBox(width: 24),
      title: Text(title),
      onTap: onTap,
      dense: true,
    );
  }
}

Future<void> showFilterBottomSheet({
  required BuildContext context,
  required String title,
  required List<String> options,
  required String? selectedValue,
  required ValueChanged<String?> onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => FilterBottomSheet(
      title: title,
      options: options,
      selectedValue: selectedValue,
      onSelected: onSelected,
    ),
  );
}
