import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../modules/clinician_testing/presentation/providers/clinician_testing_providers.dart';
import '../../../../modules/patient_screening/presentation/providers/patient_screening_providers.dart';
import '../../../../modules/patient_screening/presentation/view_models/screening_summary_view_model.dart';

class BcImportScreen extends ConsumerStatefulWidget {
  const BcImportScreen({super.key});

  @override
  ConsumerState<BcImportScreen> createState() => _BcImportScreenState();
}

class _BcImportScreenState extends ConsumerState<BcImportScreen> {
  String? _selectedPatientId;
  String? _selectedFilePath;
  String _fileType = 'pdf';
  String? _selectedScreeningId;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(clinicianPatientsProvider);
    final saveState = ref.watch(clinicianBcImportSaveProvider);
    final screeningAsync = _selectedPatientId == null
        ? const AsyncValue<List<ScreeningSummaryViewModel>>.data([])
        : ref.watch(screeningHistorySummaryProvider(_selectedPatientId!));

    return Scaffold(
      appBar: AppBar(title: const Text('Import BC Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Patient',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedPatientId,
              items: patients
                  .map(
                    (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedPatientId = value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Choose patient',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Link Screening (optional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            screeningAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Unable to load screenings: $error'),
              data: (screenings) {
                if (screenings.isEmpty) {
                  return Text(
                    'No screenings found for this patient',
                    style: TextStyle(color: Colors.grey.shade600),
                  );
                }
                return DropdownButtonFormField<String>(
                  initialValue: _selectedScreeningId,
                  items: screenings
                      .map(
                        (s) => DropdownMenuItem(
                          value: s.id,
                          child: Text(
                            DateFormat(
                              'MMM d, yyyy • h:mm a',
                            ).format(s.testDate),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedScreeningId = value),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select screening (optional)',
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text('File Type', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _fileType,
              items: const [
                DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                DropdownMenuItem(value: 'xml', child: Text('XML')),
                DropdownMenuItem(value: 'hl7', child: Text('HL7')),
              ],
              onChanged: (value) => setState(() => _fileType = value ?? 'pdf'),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text('Select File', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedFilePath ?? 'No file selected',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Choose'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saveState.isLoading ? null : _saveImport,
                icon: const Icon(Icons.upload),
                label: const Text('Import BC Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            if (saveState.isLoading) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
            if (saveState.hasError) ...[
              const SizedBox(height: 16),
              Text(
                'Failed to import: ${saveState.error}',
                style: const TextStyle(color: AppTheme.errorColor),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [_fileType],
    );
    if (result == null || result.files.single.path == null) return;
    setState(() => _selectedFilePath = result.files.single.path);
  }

  Future<void> _saveImport() async {
    if (_selectedPatientId == null || _selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select patient and file first')),
      );
      return;
    }

    final file = File(_selectedFilePath!);
    final saved = await ref
        .read(clinicianBcImportSaveProvider.notifier)
        .save(
          patientId: _selectedPatientId!,
          screeningId: _selectedScreeningId,
          sourceFile: file,
          fileType: _fileType,
        );

    if (!mounted) return;
    if (saved == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Import failed')));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Imported ${saved.fileName}')));
    Navigator.of(context).pop();
  }
}

class BcImportList extends ConsumerWidget {
  const BcImportList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importsAsync = ref.watch(clinicianBcImportListProvider);
    return importsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (imports) {
        if (imports.isEmpty) {
          return Center(
            child: Text(
              'No BC imports yet',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          );
        }
        return ListView.builder(
          itemCount: imports.length,
          itemBuilder: (context, index) {
            final item = imports[index];
            return ListTile(
              leading: const Icon(Icons.upload_file),
              title: Text(item.fileName),
              subtitle: Text(
                '${item.fileType.toUpperCase()} • ${DateFormat('MMM d, yyyy').format(item.importedAt)}',
              ),
              trailing: Text(item.status.toUpperCase()),
            );
          },
        );
      },
    );
  }
}
