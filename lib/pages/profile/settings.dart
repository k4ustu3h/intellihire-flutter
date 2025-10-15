import "package:flutter/material.dart";
import "package:intellihire/components/lists/list_row.dart";
import "package:intellihire/util/ui/theme_controller.dart";
import "package:material_symbols_icons/symbols.dart";

class Settings extends StatefulWidget {
  final ThemeController themeController;

  const Settings({super.key, required this.themeController});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Widget _buildLeadingIcon(IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: colorScheme.onPrimary, size: 24),
    );
  }

  void _toggleDynamicTheme([bool? newValue]) {
    final value = newValue ?? !widget.themeController.value;
    setState(() {
      widget.themeController.setUseDynamicTheme(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeControllerValue = widget.themeController.value;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          Column(
            spacing: ListRow.basePadding,
            children: [
              ListRow(
                startIcon: _buildLeadingIcon(Symbols.palette_rounded),
                label: const Text("Use Dynamic Theming"),
                description: const Text("Uses system wallpaper colors"),
                endIcon: Switch(
                  value: themeControllerValue,
                  onChanged: _toggleDynamicTheme,
                ),
                first: true,
                last: true,
                onClick: _toggleDynamicTheme,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
