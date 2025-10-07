import "package:flutter/material.dart";
import "package:intellihire/data/india_states_cities.dart";
import "package:material_symbols_icons/symbols.dart";

class StateDropdown extends StatelessWidget {
  final String? selectedState;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const StateDropdown({
    super.key,
    required this.selectedState,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        menuMaxHeight: 300,
        value: selectedState,
        decoration: InputDecoration(
          labelText: "State/Region",
          prefixIcon: Icon(Symbols.location_on_rounded),
          border: OutlineInputBorder(),
        ),
        items: (indiaStatesCities.keys.toList()..sort())
            .map(
              (state) => DropdownMenuItem<String>(
                value: state,
                child: Text(state, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: enabled ? onChanged : null,
        validator: (value) =>
            value == null || value.isEmpty ? "State cannot be empty" : null,
      ),
    );
  }
}
