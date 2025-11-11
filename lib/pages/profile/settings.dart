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

  void _toggleDynamicTheme([bool? newValue]) async {
    final value = newValue ?? !widget.themeController.value;
    await widget.themeController.setUseDynamicTheme(value);
    setState(() {});
  }

  void _toggleDarkMode([bool? newValue]) async {
    final value = newValue ?? !widget.themeController.useDarkMode;
    await widget.themeController.setUseDarkMode(value);
    setState(() {});
  }

  void _showDynamicThemeWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Disable dynamic theming to use manual dark mode."),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = widget.themeController;
    final useDynamicTheme = themeController.value;
    final useDarkMode = themeController.useDarkMode;

    final themeItems = [
      {
        "icon": Symbols.palette_rounded,
        "label": "Use Dynamic Theming",
        "desc": "Uses system wallpaper colors",
        "value": useDynamicTheme,
        "onChanged": _toggleDynamicTheme,
        "onClick": _toggleDynamicTheme,
        "disabled": false,
      },
      {
        "icon": Symbols.dark_mode_rounded,
        "label": "Dark Mode",
        "desc": "Manually enable dark theme",
        "value": useDarkMode,
        "onChanged": useDynamicTheme ? null : _toggleDarkMode,
        "onClick": useDynamicTheme ? _showDynamicThemeWarning : _toggleDarkMode,
        "disabled": useDynamicTheme,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          Column(
            spacing: 2,
            children: themeItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return ListRow(
                title: index == 0
                    ? const Text("Theme")
                    : null,
                startIcon: _buildLeadingIcon(item["icon"] as IconData),
                label: Text(item["label"] as String),
                description: Text(item["desc"] as String),
                endIcon: Switch(
                  value: item["value"] as bool,
                  onChanged: item["onChanged"] as void Function(bool)?,
                ),
                first: index == 0,
                last: index == themeItems.length - 1,
                onClick: item["onClick"] as void Function()?,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
