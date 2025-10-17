import "package:flutter/material.dart";
import "package:intellihire/data/india_states_cities.dart";
import "package:material_symbols_icons/symbols.dart";

class CityDropdown extends StatelessWidget {
  final String? selectedState;
  final String? selectedCity;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const CityDropdown({
    super.key,
    required this.selectedState,
    required this.selectedCity,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> cities = selectedState != null
        ? (indiaStatesCities[selectedState!]!.toList()..sort())
        : <String>[];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        menuMaxHeight: 300,
        initialValue: selectedCity,
        decoration: const InputDecoration(
          labelText: "City",
          prefixIcon: Icon(Symbols.location_city_rounded),
          border: OutlineInputBorder(),
        ),
        items: cities
            .map(
              (city) => DropdownMenuItem<String>(
                value: city,
                child: Text(city, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: enabled ? onChanged : null,
        validator: (value) =>
            value == null || value.isEmpty ? "City cannot be empty" : null,
      ),
    );
  }
}
