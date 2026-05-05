import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:audioapp/core/router/app_router.dart';
import 'package:audioapp/core/theme/app_theme.dart';
import 'package:audioapp/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:audioapp/modules/clinician_testing/presentation/providers/clinician_testing_providers.dart';
import 'package:audioapp/modules/shared_profile_settings/presentation/screens/profile_screen.dart';
import 'package:audioapp/core/presentation/widgets/luxury_header.dart';
import 'package:audioapp/core/presentation/widgets/luxury_card.dart';
import 'package:audioapp/features/audiologist/presentation/screens/patients_list_screen.dart';

class AudiologistHomeScreen extends ConsumerStatefulWidget {
  const AudiologistHomeScreen({super.key});

  @override
  ConsumerState<AudiologistHomeScreen> createState() =>
      _AudiologistHomeScreenState();
}

class _AudiologistHomeScreenState extends ConsumerState<AudiologistHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _DashboardTab(),
          _PatientsTab(),
          _TestsTab(),
          _MoreTab(),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.audiologistTest),
              icon: const Icon(Icons.add),
              label: const Text('New Test'),
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Patients',
          ),
          NavigationDestination(
            icon: Icon(Icons.hearing_outlined),
            selectedIcon: Icon(Icons.hearing),
            label: 'Tests',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

/// Dashboard tab
class _DashboardTab extends ConsumerWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final patients = ref.watch(clinicianPatientsProvider);
    final tests = ref.watch(clinicianTestResultsProvider);

    final today = DateTime.now();
    final todayTests = tests
        .where(
          (t) =>
              t.testDate.year == today.year &&
              t.testDate.month == today.month &&
              t.testDate.day == today.day,
        )
        .length;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: LuxuryHeader(
              title: 'Dashboard',
              subtitle: 'Welcome, ${authState.user?.name ?? 'Doctor'}',
              showBackButton: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.surfaceLight,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                  child: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Patients',
                      patients.length.toString(),
                      Icons.people_outline,
                      AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Today',
                      todayTests.toString(),
                      Icons.today,
                      AppTheme.secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Total Tests',
                      tests.length.toString(),
                      Icons.hearing,
                      AppTheme.tertiaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildActionCard(
                        context,
                        'New Test',
                        Icons.add_circle_outline,
                        AppTheme.primaryColor,
                        () => context.push(AppRoutes.audiologistTest),
                      ),
                      _buildActionCard(
                        context,
                        'Bone Conduction',
                        Icons.vibration,
                        AppTheme.secondaryColor,
                        () => context.push(AppRoutes.audiologistBoneConduction),
                      ),
                      _buildActionCard(
                        context,
                        'Add Patient',
                        Icons.person_add_outlined,
                        AppTheme.tertiaryColor,
                        () => context.push(AppRoutes.audiologistPatients),
                      ),
                      _buildActionCard(
                        context,
                        'Calibration',
                        Icons.tune,
                        AppTheme.warningColor,
                        () => context.push(AppRoutes.audiologistCalibration),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Recent Tests',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index >= tests.length) return null;
                final test = tests[index];
                final patient = ref.watch(
                  clinicianPatientProvider(test.patientId),
                );

                return LuxuryCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.hearing,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    title: Text(
                      patient?.name ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat('MMM d, h:mm a').format(test.testDate),
                    ),
                    trailing: Chip(
                      label: Text(
                        test.overallClassification,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                      backgroundColor: test.overallStatusColor,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onTap: () {
                      // Navigate to test details
                    },
                  ),
                );
              }, childCount: tests.length > 5 ? 5 : tests.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return LuxuryCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return LuxuryCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PatientsTab extends ConsumerWidget {
  const _PatientsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(clinicianPatientsProvider);

    return SafeArea(
      child: Column(
        children: [
          LuxuryHeader(
            title: 'Patients',
            showBackButton: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => _showAddPatientDialog(context),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search patients...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppTheme.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return LuxuryCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.secondaryColor.withValues(
                        alpha: 0.2,
                      ),
                      child: Text(
                        patient.initials,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      patient.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Age: ${patient.age} • ID: ${patient.id.substring(0, 4)}',
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppTheme.textSecondaryLight,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PatientDetailScreen(patientId: patient.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    // Implementation would go here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add Patient Dialog')));
  }
}

class _TestsTab extends ConsumerWidget {
  const _TestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(clinicianTestResultsProvider);

    return SafeArea(
      child: Column(
        children: [
          const LuxuryHeader(title: 'All Tests', showBackButton: false),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tests.length,
              itemBuilder: (context, index) {
                final test = tests[index];
                final patient = ref.watch(
                  clinicianPatientProvider(test.patientId),
                );

                return LuxuryCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(patient?.name ?? 'Unknown'),
                    subtitle: Text(
                      DateFormat('MMM d, yyyy').format(test.testDate),
                    ),
                    trailing: Text(
                      test.overallClassification,
                      style: TextStyle(
                        color: test.overallStatusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreTab extends StatelessWidget {
  const _MoreTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const LuxuryHeader(title: 'More', showBackButton: false),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  LuxuryCard(
                    child: ListTile(
                      leading: const Icon(
                        Icons.settings_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Settings'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 12),
                  LuxuryCard(
                    child: ListTile(
                      leading: const Icon(
                        Icons.headphones,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Headphone Calibration'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(
                        AppRoutes.audiologistHeadphoneCalibration,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  LuxuryCard(
                    child: ListTile(
                      leading: const Icon(
                        Icons.help_outline,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Help & Support'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 12),
                  LuxuryCard(
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: AppTheme.errorColor,
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: AppTheme.errorColor),
                      ),
                      onTap: () {
                        // Logout logic
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
