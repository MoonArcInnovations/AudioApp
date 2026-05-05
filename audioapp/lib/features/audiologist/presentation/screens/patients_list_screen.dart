import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../modules/ai_review/application/use_cases/ai_decision_export_params.dart';
import '../../../../modules/ai_review/presentation/providers/ai_review_providers.dart';
import '../../../../modules/clinician_testing/presentation/providers/clinician_testing_providers.dart';
import '../../../../modules/clinician_testing/presentation/view_models/clinician_patient_view_model.dart';
import '../../../../modules/clinician_testing/presentation/view_models/clinician_test_summary_view_model.dart';
import 'bone_conduction_screen.dart';
import 'test_detail_screen.dart';

class PatientsListScreen extends ConsumerStatefulWidget {
  const PatientsListScreen({super.key});

  @override
  ConsumerState<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends ConsumerState<PatientsListScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ClinicianPatientViewModel> _filterPatients(
    List<ClinicianPatientViewModel> patients,
  ) {
    if (_searchQuery.isEmpty) return patients;
    final query = _searchQuery.toLowerCase();
    return patients.where((p) {
      return p.name.toLowerCase().contains(query) ||
          (p.email?.toLowerCase().contains(query) ?? false) ||
          (p.phoneNumber?.contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(clinicianPatientSummariesProvider);
    final filteredPatients = _filterPatients(patients);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Add sorting options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search patients...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredPatients.length} patient${filteredPatients.length != 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Patient list
          Expanded(
            child: filteredPatients.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      return _buildPatientCard(
                        context,
                        filteredPatients[index],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddPatientDialog(context);
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Patient'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No patients yet' : 'No patients found',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Add your first patient to get started'
                : 'Try a different search term',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(
    BuildContext context,
    ClinicianPatientViewModel patient,
  ) {
    final tests = ref.watch(clinicianPatientTestSummariesProvider(patient.id));
    final lastTest = tests.isNotEmpty ? tests.first : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PatientDetailScreen(patientId: patient.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                child: Text(
                  patient.initials,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Age: ${patient.age} years',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (lastTest != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: lastTest.overallStatusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Last: ${lastTest.overallClassification}',
                            style: TextStyle(
                              fontSize: 12,
                              color: lastTest.overallStatusColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.hearing,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () {
                      context.push(
                        '${AppRoutes.audiologistTest}/${patient.id}',
                      );
                    },
                    tooltip: 'Start Test',
                  ),
                  Text(
                    '${tests.length} tests',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddPatientSheet(),
    );
  }
}

/// Add patient bottom sheet
class AddPatientSheet extends ConsumerStatefulWidget {
  const AddPatientSheet({super.key});

  @override
  ConsumerState<AddPatientSheet> createState() => _AddPatientSheetState();
}

class _AddPatientSheetState extends ConsumerState<AddPatientSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _dateOfBirth = DateTime.now().subtract(
    const Duration(days: 365 * 30),
  );

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Add New Patient',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date of Birth
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dateOfBirth,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _dateOfBirth = date);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth *',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(DateFormat('MMMM d, yyyy').format(_dateOfBirth)),
                ),
              ),
              const SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: _submit,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('Add Patient'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final patient = await ref
        .read(clinicianPatientsProvider.notifier)
        .addPatientRecord(
          name: _nameController.text.trim(),
          dateOfBirth: _dateOfBirth,
          phoneNumber: _phoneController.text.trim().isNotEmpty
              ? _phoneController.text.trim()
              : null,
          email: _emailController.text.trim().isNotEmpty
              ? _emailController.text.trim()
              : null,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        );

    if (!mounted) return;

    if (patient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add patients')),
      );
      return;
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Patient added successfully')));
  }
}

/// Patient detail screen
class PatientDetailScreen extends ConsumerWidget {
  final String patientId;

  const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = ref.watch(clinicianPatientSummaryProvider(patientId));
    final tests = ref.watch(clinicianPatientTestSummariesProvider(patientId));

    if (patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Patient')),
        body: const Center(child: Text('Patient not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditPatientSheet(context, patient);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete(context, ref, patient);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppTheme.errorColor),
                    SizedBox(width: 8),
                    Text(
                      'Delete Patient',
                      style: TextStyle(color: AppTheme.errorColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        patient.initials,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      patient.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.cake, 'Age: ${patient.age} years'),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'DOB: ${DateFormat('MMMM d, yyyy').format(patient.dateOfBirth)}',
                    ),
                    if (patient.phoneNumber != null)
                      _buildInfoRow(Icons.phone, patient.phoneNumber!),
                    if (patient.email != null)
                      _buildInfoRow(Icons.email, patient.email!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(
                        '${AppRoutes.audiologistTest}/${patient.id}',
                      );
                    },
                    icon: const Icon(Icons.hearing),
                    label: const Text('New Test'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              BoneConductionScreen(patientId: patient.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.vibration),
                    label: const Text('BC Test'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Test history
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Test History',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '${tests.length} test${tests.length != 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (tests.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.hearing_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No tests yet',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tests.length,
                itemBuilder: (context, index) {
                  return _buildTestCard(context, tests[index]);
                },
              ),
            const SizedBox(height: 24),

            // AI decision history
            Text(
              'AI Decision History',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _exportPatientAiCsv(context, ref, patient),
                  icon: const Icon(Icons.download),
                  label: const Text('CSV'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _exportPatientAiPdf(context, ref, patient),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('PDF'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildAiDecisionHistory(context, ref, tests),
          ],
        ),
      ),
    );
  }

  Widget _buildAiDecisionHistory(
    BuildContext context,
    WidgetRef ref,
    List<ClinicianTestSummaryViewModel> tests,
  ) {
    if (tests.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'No AI decisions yet',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    final recommendationsAsync = ref.watch(
      aiDecisionHistoryItemsForTestsProvider(
        AiDecisionHistoryItemsForTestsRequest(
          testIds: tests.map((test) => test.id).toList(),
        ),
      ),
    );

    return recommendationsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Failed to load AI decisions: $error'),
        ),
      ),
      data: (historyItems) {
        if (historyItems.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No AI decisions yet',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
          );
        }

        final itemsByTestId = {
          for (final item in historyItems) item.testId: item,
        };

        return Column(
          children: tests.where((test) => itemsByTestId.containsKey(test.id)).map((
            test,
          ) {
            final item = itemsByTestId[test.id]!;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.psychology),
                title: Text('AI: ${item.suggestionType}'),
                subtitle: Text(
                  '${(item.confidence * 100).toStringAsFixed(0)}% • ${item.decisionLabel}',
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildTestCard(
    BuildContext context,
    ClinicianTestSummaryViewModel test,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: test.overallStatusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.hearing, color: test.overallStatusColor),
        ),
        title: Text(DateFormat('MMMM d, yyyy').format(test.testDate)),
        subtitle: Text(
          'R: ${test.rightClassification} | L: ${test.leftClassification}',
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: test.overallStatusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            test.overallClassification,
            style: TextStyle(
              color: test.overallStatusColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  TestDetailScreen(testId: test.id, patientId: test.patientId),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ClinicianPatientViewModel patient,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Patient'),
        content: Text('Are you sure you want to delete ${patient.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(clinicianPatientsProvider.notifier)
                  .deletePatient(patient.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Patient deleted')));
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditPatientSheet(
    BuildContext context,
    ClinicianPatientViewModel patient,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => EditPatientSheet(patient: patient),
    );
  }

  Future<void> _exportPatientAiCsv(
    BuildContext context,
    WidgetRef ref,
    ClinicianPatientViewModel patient,
  ) async {
    final count = await ref.read(shareAiDecisionCsvUseCaseProvider)(
      AiDecisionExportParams(patientId: patient.id, patientName: patient.name),
    );
    if (!context.mounted) {
      return;
    }
    if (count == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No AI decisions to export')),
      );
    }
  }

  Future<void> _exportPatientAiPdf(
    BuildContext context,
    WidgetRef ref,
    ClinicianPatientViewModel patient,
  ) async {
    final count = await ref.read(shareAiDecisionPdfUseCaseProvider)(
      AiDecisionExportParams(patientId: patient.id, patientName: patient.name),
    );
    if (!context.mounted) {
      return;
    }
    if (count == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No AI decisions to export')),
      );
    }
  }
}

class EditPatientSheet extends ConsumerStatefulWidget {
  const EditPatientSheet({super.key, required this.patient});

  final ClinicianPatientViewModel patient;

  @override
  ConsumerState<EditPatientSheet> createState() => _EditPatientSheetState();
}

class _EditPatientSheetState extends ConsumerState<EditPatientSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _notesController;
  late DateTime _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient.name);
    _phoneController = TextEditingController(
      text: widget.patient.phoneNumber ?? '',
    );
    _emailController = TextEditingController(text: widget.patient.email ?? '');
    _notesController = TextEditingController(text: widget.patient.notes ?? '');
    _dateOfBirth = widget.patient.dateOfBirth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Edit Patient',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dateOfBirth,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _dateOfBirth = date);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth *',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(DateFormat('MMMM d, yyyy').format(_dateOfBirth)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('Save Changes'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(clinicianPatientsProvider.notifier)
        .updatePatientRecord(
          patient: widget.patient,
          name: _nameController.text.trim(),
          dateOfBirth: _dateOfBirth,
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Patient updated successfully')),
    );
  }
}
