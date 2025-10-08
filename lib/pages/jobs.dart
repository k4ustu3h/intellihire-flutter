import "package:flutter/material.dart";
import "package:intellihire/components/bottomsheets/filter_bottom_sheet.dart";
import "package:intellihire/components/cards/job_card.dart";
import "package:intellihire/components/chips/filter_chip_button.dart";
import "package:intellihire/components/skeletons/job_card_skeleton.dart";
import "package:intellihire/services/api_service.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:skeletonizer/skeletonizer.dart";

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  late final Future<List<Map<String, dynamic>>> _jobsFuture;

  String? _selectedState;
  String? _selectedCity;
  String? _selectedSkill;

  List<Map<String, dynamic>> _allJobs = [];
  List<String> _availableStates = [];
  List<String> _availableSkills = [];

  @override
  void initState() {
    super.initState();
    _jobsFuture = _fetchAndProcessJobs();
  }

  Future<List<Map<String, dynamic>>> _fetchAndProcessJobs() async {
    final jobs = await ApiService.fetchJobs();
    if (jobs.isEmpty) return jobs;

    final states = <String>{};
    final skills = <String>{};

    for (var job in jobs) {
      states.add(job["state"] as String);
      if (job["skills"] is List) {
        skills.addAll(List<String>.from(job["skills"]));
      }
    }

    if (mounted) {
      setState(() {
        _allJobs = jobs;
        _availableStates = states.toList()..sort();
        _availableSkills = skills.toList()..sort();
      });
    }
    return jobs;
  }

  List<Map<String, dynamic>> _getFilteredJobs() {
    if (_selectedState == null &&
        _selectedCity == null &&
        _selectedSkill == null) {
      return _allJobs;
    }

    return _allJobs.where((job) {
      final matchesState =
          _selectedState == null || job["state"] == _selectedState;
      final matchesCity =
          _selectedCity == null ||
          (job["city"] == _selectedCity && job["state"] == _selectedState);
      final matchesSkill = _selectedSkill == null
          ? true
          : List<String>.from(job["skills"]).contains(_selectedSkill);

      return matchesState && matchesCity && matchesSkill;
    }).toList();
  }

  List<String> _getAvailableCities() {
    if (_selectedState == null) return [];

    return _allJobs
        .where((job) => job["state"] == _selectedState)
        .map((job) => job["city"] as String)
        .toSet()
        .toList()
      ..sort();
  }

  void _openFilterSheet({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String?> onSelected,
  }) {
    showModalBottomSheet(
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final jobs = snapshot.data ?? [];
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!isLoading && jobs.isEmpty) {
            return Center(child: Text("No jobs found."));
          }
          if (isLoading) {
            return Skeletonizer(
              enabled: true,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) => JobCardSkeleton(),
              ),
            );
          }

          final filteredJobs = _getFilteredJobs();
          final availableCities = _getAvailableCities();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  spacing: 8,
                  children: [
                    FilterChipButton(
                      label: "State",
                      icon: Symbols.location_on,
                      selectedValue: _selectedState,
                      onTap: () => _openFilterSheet(
                        title: "Filter by State",
                        options: _availableStates,
                        selectedValue: _selectedState,
                        onSelected: (val) {
                          setState(() {
                            _selectedState = val;
                            _selectedCity = null;
                          });
                        },
                      ),
                    ),
                    FilterChipButton(
                      label: "City",
                      icon: Symbols.location_city,
                      selectedValue: _selectedCity,
                      onTap: () {
                        if (_selectedState == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Select a State first.")),
                          );
                          return;
                        }
                        _openFilterSheet(
                          title: "Cities in $_selectedState",
                          options: availableCities,
                          selectedValue: _selectedCity,
                          onSelected: (val) =>
                              setState(() => _selectedCity = val),
                        );
                      },
                    ),
                    FilterChipButton(
                      label: "Skill",
                      icon: Symbols.code,
                      selectedValue: _selectedSkill,
                      onTap: () => _openFilterSheet(
                        title: "Filter by Skill",
                        options: _availableSkills,
                        selectedValue: _selectedSkill,
                        onSelected: (val) =>
                            setState(() => _selectedSkill = val),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  "Showing ${filteredJobs.length} of ${_allJobs.length} jobs.",
                  style: theme.textTheme.bodySmall,
                ),
              ),

              Expanded(
                child: filteredJobs.isEmpty
                    ? Center(child: Text("No jobs match your criteria."))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredJobs.length,
                        itemBuilder: (context, index) =>
                            JobCard(job: filteredJobs[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
