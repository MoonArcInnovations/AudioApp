import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:audioapp/core/theme/app_theme.dart';
import 'package:audioapp/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:audioapp/modules/patient_screening/presentation/providers/patient_screening_providers.dart';
import 'package:audioapp/modules/shared_profile_settings/presentation/screens/profile_screen.dart';
import 'package:audioapp/core/presentation/widgets/luxury_header.dart';
import 'package:audioapp/core/presentation/widgets/luxury_card.dart';
import 'package:audioapp/features/patient/presentation/widgets/hearing_status_card.dart';
import 'package:audioapp/features/patient/presentation/widgets/quick_action_card.dart';
import 'package:audioapp/features/patient/presentation/screens/screening_history_screen.dart';

class PatientHomeScreen extends ConsumerStatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  ConsumerState<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends ConsumerState<PatientHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          const ScreeningHistoryScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final latestScreeningAsync = user == null
        ? const AsyncValue.data(null)
        : ref.watch(latestScreeningSummaryProvider(user.id));

    return SafeArea(
      child: Column(
        children: [
          LuxuryHeader(
            title: 'Welcome, ${user?.name.split(' ').first ?? 'Patient'}',
            subtitle: DateFormat('EEEE, MMMM d').format(DateTime.now()),
            showBackButton: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _showNotifications(context),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.surfaceLight,
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Hearing Status
                  latestScreeningAsync.when(
                    data: (data) => HearingStatusCard(screening: data),
                    loading: () => const HearingStatusCard(isLoading: true),
                    error: (e, s) => HearingStatusCard(error: e.toString()),
                  ),

                  const SizedBox(height: 24),

                  // 2. Quick Action
                  QuickActionCard(
                    onHistoryTap: () => setState(() => _selectedIndex = 1),
                  ),

                  const SizedBox(height: 32),

                  // 3. Tips Section
                  Text(
                    'Daily Insights',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  _buildTipCard(
                    context,
                    title: 'The 60/60 Rule',
                    content:
                        'Listen at 60% max volume for no more than 60 mins a day.',
                    icon: Icons.headphones_outlined,
                  ),
                  _buildTipCard(
                    context,
                    title: 'Annual Checkups',
                    content:
                        'Hearing changes are gradual. Test often to catch issues early.',
                    icon: Icons.calendar_today_outlined,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return LuxuryCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceSubtleLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Center(child: Text('No new notifications')),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
