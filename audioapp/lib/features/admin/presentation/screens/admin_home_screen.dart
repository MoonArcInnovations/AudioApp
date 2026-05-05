import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:audioapp/core/router/app_router.dart';
import 'package:audioapp/core/theme/app_theme.dart';
import 'package:audioapp/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:audioapp/modules/shared_profile_settings/presentation/screens/profile_screen.dart';
import 'package:audioapp/core/presentation/widgets/luxury_header.dart';
import 'package:audioapp/core/presentation/widgets/luxury_card.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _OverviewTab(),
          _UsersTab(),
          _AnalyticsTab(),
          _AdminMoreTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analytics',
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

/// Overview tab
class _OverviewTab extends ConsumerWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: LuxuryHeader(
              title: 'Admin Dashboard',
              subtitle: 'Welcome, ${authState.user?.name ?? 'Admin'}',
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
                      Icons.admin_panel_settings,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              delegate: SliverChildListDelegate([
                _buildStatCard(
                  context,
                  icon: Icons.people,
                  value: '156',
                  label: 'Total Users',
                  trend: '+12%',
                  color: AppTheme.primaryColor,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.hearing,
                  value: '89',
                  label: 'Audiologists',
                  trend: '+5%',
                  color: AppTheme.successColor,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.person,
                  value: '67',
                  label: 'Patients',
                  trend: '+18%',
                  color: AppTheme.tertiaryColor,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.assessment,
                  value: '342',
                  label: 'Tests This Month',
                  trend: '+23%',
                  color: AppTheme.warningColor,
                ),
              ]),
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
                    childAspectRatio: 2.3,
                    children: [
                      _buildQuickAction(
                        context,
                        Icons.person_add,
                        'Add User',
                        AppTheme.primaryColor,
                      ),
                      _buildQuickAction(
                        context,
                        Icons.verified_user,
                        'Verify Audiologists',
                        AppTheme.secondaryColor,
                        onTap: () => context.push(AppRoutes.adminVerification),
                      ),
                      _buildQuickAction(
                        context,
                        Icons.analytics,
                        'View Reports',
                        AppTheme.tertiaryColor,
                      ),
                      _buildQuickAction(
                        context,
                        Icons.settings,
                        'Settings',
                        Colors.grey,
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
                'Recent Activity',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final activities = [
                  (
                    'New audiologist registered',
                    'Dr. Sarah Johnson',
                    '5 min ago',
                    Icons.person_add,
                    AppTheme.successColor,
                  ),
                  (
                    'Test completed',
                    'Patient: John Doe',
                    '15 min ago',
                    Icons.hearing,
                    AppTheme.primaryColor,
                  ),
                  (
                    'User deactivated',
                    'Michael Brown',
                    '1 hour ago',
                    Icons.person_off,
                    AppTheme.errorColor,
                  ),
                  (
                    'System backup',
                    'Automatic backup completed',
                    '2 hours ago',
                    Icons.backup,
                    AppTheme.secondaryColor,
                  ),
                ];
                if (index >= activities.length) return null;
                final activity = activities[index];

                return LuxuryCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: activity.$5.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(activity.$4, color: activity.$5, size: 20),
                    ),
                    title: Text(
                      activity.$1,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(activity.$2),
                    trailing: Text(
                      activity.$3,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }, childCount: 4),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required String trend,
    required Color color,
  }) {
    return LuxuryCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return LuxuryCard(
      onTap: onTap ?? () {},
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Users management tab
class _UsersTab extends ConsumerWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          LuxuryHeader(
            title: 'User Management',
            showBackButton: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => _showAddUserDialog(context),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.surfaceLight,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
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
              itemCount: 10,
              itemBuilder: (context, index) {
                final isAudiologist = index % 3 == 0;
                return LuxuryCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isAudiologist
                          ? AppTheme.secondaryColor.withValues(alpha: 0.2)
                          : AppTheme.primaryColor.withValues(alpha: 0.1),
                      child: Icon(
                        isAudiologist ? Icons.hearing : Icons.person,
                        color: isAudiologist
                            ? AppTheme.primaryColor
                            : AppTheme.textPrimaryLight,
                      ),
                    ),
                    title: Text(
                      'User ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(isAudiologist ? 'Audiologist' : 'Patient'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {},
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Text('View Details'),
                        ),
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(color: AppTheme.errorColor),
                          ),
                        ),
                      ],
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

  void _showAddUserDialog(BuildContext context) {
    // Dialog logic
  }
}

/// Analytics tab
class _AnalyticsTab extends StatelessWidget {
  const _AnalyticsTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const LuxuryHeader(title: 'Analytics', showBackButton: false),

            LuxuryCard(
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Tests Completed',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.bar_chart,
                      size: 64,
                      color: AppTheme.primaryColor,
                    ),
                    const Spacer(),
                    const Text('342 tests this month (+23%)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildMiniStat(
                    context,
                    'Avg Tests/Day',
                    '11.4',
                    Icons.trending_up,
                    AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMiniStat(
                    context,
                    'Active Users',
                    '89',
                    Icons.people,
                    AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMiniStat(
                    context,
                    'Reports',
                    '256',
                    Icons.description,
                    AppTheme.secondaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMiniStat(
                    context,
                    'Avg Response',
                    '2.3s',
                    Icons.speed,
                    AppTheme.warningColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(
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
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _AdminMoreTab extends StatelessWidget {
  const _AdminMoreTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const LuxuryHeader(title: 'More', showBackButton: false),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                LuxuryCard(
                  child: ListTile(
                    leading: const Icon(
                      Icons.admin_panel_settings,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Admin Profile'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
