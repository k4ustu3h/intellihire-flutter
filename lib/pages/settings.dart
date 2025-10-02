import "package:flutter/material.dart";
import "package:intellihire/util/ui/theme_controller.dart";
import "package:material_symbols_icons/symbols.dart";

class SettingsPage extends StatefulWidget {
  final ThemeController themeController;

  const SettingsPage({super.key, required this.themeController});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SwitchListTile(
            secondary: Icon(Symbols.palette_rounded),
            title: Text("Use Dynamic Theming"),
            value: widget.themeController.value,
            onChanged: (val) {
              setState(() {
                widget.themeController.setUseDynamicTheme(val);
              });
            },
          ),
        ],
      ),
    );
  }
}
