import "package:flutter/material.dart";
import "package:intellihire/components/bottomsheets/filter_bottom_sheet.dart";
import "package:intellihire/components/cards/job_card.dart";
import "package:intellihire/components/chips/filter_chip_button.dart";
import "package:intellihire/components/skeletons/jobs_skeleton.dart";
import "package:intellihire/services/api_service.dart";
import "package:intellihire/services/test_service.dart";
import "package:intellihire/util/code_labeler.dart";
import "package:material_symbols_icons/symbols.dart";

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
  String? _selectedJobType;
  bool _isMatchingSkillsActive = false;

  List<Map<String, dynamic>> _allJobs = [];
  List<String> _availableStates = [];
  List<String> _availableSkills = [];
  List<String> _availableJobTypes = [];
  Set<String> _userPassedSkills = {};

  @override
  void initState() {
    super.initState();
    _jobsFuture = _fetchAndProcessJobs();
  }

  Future<List<Map<String, dynamic>>> _fetchAndProcessJobs() async {
    final results = await Future.wait([
      ApiService.fetchJobs(),
      TestService.getPassedSkills(),
    ]);

    final fetchedSkills = results[1] as Set<String>;
    final jobsRaw = results[0] as List<Map<String, dynamic>>;

    if (jobsRaw.isEmpty) return jobsRaw;

    final states = <String>{};
    final skills = <String>{};
    final jobTypes = <String>{};

    final jobs = jobsRaw.map((job) {
      final jobSkills = (job["skills"] as List?)?.cast<String>() ?? [];
      states.add(job["state"] as String);
      skills.addAll(jobSkills);
      jobTypes.add(job["jobType"] as String);
      return {...job, "skills": jobSkills};
    }).toList();

    if (mounted) {
      setState(() {
        _allJobs = jobs;
        _availableStates = states.toList()..sort();
        _availableSkills = skills.toList()..sort();
        _availableJobTypes = jobTypes.toList()..sort();
        _userPassedSkills = fetchedSkills;
      });
    }

    return jobs;
  }

  List<Map<String, dynamic>> _getFilteredJobs() {
    if (_selectedState == null &&
        _selectedCity == null &&
        _selectedSkill == null &&
        _selectedJobType == null &&
        !_isMatchingSkillsActive) {
      return _allJobs;
    }

    return _allJobs.where((job) {
      final jobSkills = job["skills"] as List<String>;
      final matchesState =
          _selectedState == null || job["state"] == _selectedState;
      final matchesCity =
          _selectedCity == null ||
          (job["city"] == _selectedCity && job["state"] == _selectedState);
      final matchesSkill = _selectedSkill == null
          ? true
          : jobSkills.contains(_selectedSkill);
      final matchesJobType =
          _selectedJobType == null || job["jobType"] == _selectedJobType;

      final matchesPersonalSkills = !_isMatchingSkillsActive
          ? true
          : jobSkills.any(_userPassedSkills.contains);

      return matchesState &&
          matchesCity &&
          matchesSkill &&
          matchesJobType &&
          matchesPersonalSkills;
    }).toList();
  }

  List<String> _getAvailableCities() {
    if (_selectedState == null) return const [];
    final cityList = _allJobs
        .where((job) => job["state"] == _selectedState)
        .map((job) => job["city"] as String)
        .toSet()
        .toList();
    cityList.sort();
    return cityList;
  }

  void _openFilterSheet({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String?> onSelected,
  }) {
    final isSkillFilter = title.contains("Skill");

    final sheetOptions = isSkillFilter
        ? options.map(labelForCode).toList()
        : options;
    final sheetSelectedValue = isSkillFilter
        ? (selectedValue != null ? labelForCode(selectedValue) : null)
        : selectedValue;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        title: title,
        options: sheetOptions,
        selectedValue: sheetSelectedValue,
        onSelected: (label) {
          final finalValue = isSkillFilter && label != null
              ? codeForLabel(label)
              : label;

          onSelected(finalValue);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final availableCities = _selectedJobType == "Remote"
        ? const ["Remote"]
        : _getAvailableCities();

    final filteredJobs = _getFilteredJobs();

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
            return const Center(child: Text("No jobs found."));
          }
          if (isLoading) {
            return const JobsSkeleton();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text("Match my Skills"),
                      selected: _isMatchingSkillsActive,
                      onSelected: (bool newState) {
                        setState(() {
                          _isMatchingSkillsActive = newState;
                        });
                      },
                    ),

                    FilterChipButton(
                      label: "Job Type",
                      icon: Symbols.work_rounded,
                      selectedValue: _selectedJobType,
                      onTap: () => _openFilterSheet(
                        title: "Filter by Job Type",
                        options: _availableJobTypes,
                        selectedValue: _selectedJobType,
                        onSelected: (val) {
                          setState(() {
                            _selectedJobType = val;
                            if (val == "Remote" || val == null) {
                              _selectedState = null;
                              _selectedCity = null;
                            }
                          });
                        },
                      ),
                    ),
                    FilterChipButton(
                      label: "State",
                      icon: Symbols.location_on,
                      selectedValue: _selectedState,
                      onTap: _selectedJobType == "Remote"
                          ? null
                          : () => _openFilterSheet(
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
                      onTap: _selectedJobType == "Remote"
                          ? null
                          : () {
                              if (_selectedState == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Select a State first."),
                                  ),
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
                      selectedValue: _selectedSkill != null
                          ? labelForCode(_selectedSkill!)
                          : null,
                      onTap: () => _openFilterSheet(
                        title: "Filter by Skill",
                        options: _availableSkills,
                        selectedValue: _selectedSkill,
                        onSelected: (code) =>
                            setState(() => _selectedSkill = code),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Text(
                  "Showing ${filteredJobs.length} of ${_allJobs.length} jobs.",
                  style: theme.textTheme.bodySmall,
                ),
              ),

              Expanded(
                child: filteredJobs.isEmpty
                    ? const Center(child: Text("No jobs match your criteria."))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
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
