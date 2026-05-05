import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:audioapp/core/router/app_router.dart';
import 'package:audioapp/core/theme/app_theme.dart';
import 'package:audioapp/modules/admin/presentation/providers/admin_providers.dart';
import 'package:audioapp/modules/admin/presentation/view_models/admin_user_view_model.dart';
import 'package:audioapp/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:audioapp/modules/shared_profile_settings/presentation/screens/profile_screen.dart';
import 'package:audioapp/core/presentation/widgets/luxury_header.dart';
import 'package:audioapp/core/presentation/widgets/luxury_card.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 3);
  }

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
    final usersAsync = ref.watch(adminUserSummariesProvider);

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
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No new admin notifications')),
                  ),
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
            sliver: SliverToBoxAdapter(
              child: usersAsync.when(
                loading: () => const _DashboardLoadingGrid(),
                error: (error, _) => _DashboardError(
                  message: 'Unable to load user metrics: $error',
                  onRetry: () => ref.invalidate(adminUserSummariesProvider),
                ),
                data: (users) => _buildStatsGrid(context, users),
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
                    childAspectRatio: 2.3,
                    children: [
                      _buildQuickAction(
                        context,
                        Icons.person_add,
                        'Add User',
                        AppTheme.primaryColor,
                        onTap: () => context.push(AppRoutes.adminUsers),
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
                        onTap: () => context.push(AppRoutes.adminAnalytics),
                      ),
                      _buildQuickAction(
                        context,
                        Icons.settings,
                        'Settings',
                        Colors.grey,
                        onTap: () => context.push(AppRoutes.adminSettings),
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
            sliver: SliverToBoxAdapter(
              child: usersAsync.when(
                loading: () => const _RecentActivityLoading(),
                error: (error, _) => _DashboardError(
                  message: 'Unable to load recent activity: $error',
                  onRetry: () => ref.invalidate(adminUserSummariesProvider),
                ),
                data: (users) => _buildRecentUsers(context, users),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, List<AdminUserViewModel> users) {
    final active = users.where((user) => user.isActive != false).length;
    final suspended = users.where((user) => user.isSuspended == true).length;
    final audiologists = users
        .where((user) => user.role.toLowerCase() == 'audiologist')
        .length;
    final pending = users
        .where(
          (user) =>
              user.role.toLowerCase() == 'audiologist' &&
              user.isVerified != true,
        )
        .length;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          context,
          icon: Icons.people,
          value: users.length.toString(),
          label: 'Total Users',
          trend: '$active active',
          color: AppTheme.primaryColor,
        ),
        _buildStatCard(
          context,
          icon: Icons.hearing,
          value: audiologists.toString(),
          label: 'Audiologists',
          trend: '$pending pending',
          color: AppTheme.successColor,
        ),
        _buildStatCard(
          context,
          icon: Icons.verified_user,
          value: active.toString(),
          label: 'Active Accounts',
          trend: '${users.length - active} inactive',
          color: AppTheme.tertiaryColor,
        ),
        _buildStatCard(
          context,
          icon: Icons.block,
          value: suspended.toString(),
          label: 'Suspended',
          trend: suspended == 0 ? 'clear' : 'review',
          color: suspended == 0 ? AppTheme.successColor : AppTheme.errorColor,
        ),
      ],
    );
  }

  Widget _buildRecentUsers(
    BuildContext context,
    List<AdminUserViewModel> users,
  ) {
    final recentUsers = [...users]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final visible = recentUsers.take(4).toList();

    if (visible.isEmpty) {
      return LuxuryCard(
        child: ListTile(
          leading: const Icon(
            Icons.history,
            color: AppTheme.textSecondaryLight,
          ),
          title: const Text('No recent user activity'),
          subtitle: const Text(
            'New registrations and account changes appear here.',
          ),
          trailing: TextButton(
            onPressed: () => context.push(AppRoutes.adminUsers),
            child: const Text('Manage'),
          ),
        ),
      );
    }

    return Column(
      children: visible.map((user) {
        final color = user.isSuspended == true
            ? AppTheme.errorColor
            : user.isVerified == true
            ? AppTheme.successColor
            : AppTheme.warningColor;
        return LuxuryCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_roleIcon(user.role), color: color, size: 20),
            ),
            title: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${_roleLabel(user.role)} • ${user.email}'),
            trailing: Text(
              _relativeDate(user.createdAt),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            onTap: () => context.push(AppRoutes.adminUsers),
          ),
        );
      }).toList(),
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
    final usersAsync = ref.watch(adminUserSummariesProvider);

    return SafeArea(
      child: Column(
        children: [
          LuxuryHeader(
            title: 'User Management',
            showBackButton: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => context.push(AppRoutes.adminUsers),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.surfaceLight,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.adminUsers),
                icon: const Icon(Icons.manage_accounts),
                label: const Text('Open Full User Management'),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: usersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _DashboardError(
                message: 'Unable to load users: $error',
                onRetry: () => ref.invalidate(adminUserSummariesProvider),
              ),
              data: (users) {
                if (users.isEmpty) {
                  return const _EmptyAdminList(
                    icon: Icons.people_outline,
                    title: 'No users yet',
                    message: 'Create the first account from User Management.',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final color = user.isSuspended == true
                        ? AppTheme.errorColor
                        : user.role.toLowerCase() == 'audiologist'
                        ? AppTheme.secondaryColor
                        : AppTheme.primaryColor;
                    return LuxuryCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withValues(alpha: 0.15),
                          child: Icon(_roleIcon(user.role), color: color),
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${_roleLabel(user.role)} • ${user.email}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(AppRoutes.adminUsers),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
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
                    onTap: () => context.push(AppRoutes.profile),
                  ),
                ),
                const SizedBox(height: 12),
                LuxuryCard(
                  child: ListTile(
                    leading: const Icon(
                      Icons.settings_outlined,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(AppRoutes.adminSettings),
                  ),
                ),
                const SizedBox(height: 12),
                LuxuryCard(
                  child: ListTile(
                    leading: const Icon(
                      Icons.history,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('AI Audit Log'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(AppRoutes.adminAudit),
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

IconData _roleIcon(String role) {
  switch (role.toLowerCase()) {
    case 'audiologist':
      return Icons.hearing;
    case 'superadmin':
    case 'admin':
      return Icons.admin_panel_settings;
    case 'patient':
      return Icons.person;
    default:
      return Icons.account_circle;
  }
}

String _roleLabel(String role) {
  switch (role.toLowerCase()) {
    case 'audiologist':
      return 'Audiologist';
    case 'superadmin':
      return 'Super Admin';
    case 'admin':
      return 'Admin';
    case 'patient':
      return 'Patient';
    default:
      return role;
  }
}

String _relativeDate(DateTime value) {
  final difference = DateTime.now().difference(value);
  if (difference.inMinutes < 1) {
    return 'Just now';
  }
  if (difference.inHours < 1) {
    return '${difference.inMinutes}m ago';
  }
  if (difference.inDays < 1) {
    return '${difference.inHours}h ago';
  }
  if (difference.inDays < 30) {
    return '${difference.inDays}d ago';
  }
  return '${value.month}/${value.day}/${value.year}';
}

class _DashboardLoadingGrid extends StatelessWidget {
  const _DashboardLoadingGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: List.generate(
        4,
        (_) =>
            const LuxuryCard(child: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}

class _RecentActivityLoading extends StatelessWidget {
  const _RecentActivityLoading();

  @override
  Widget build(BuildContext context) {
    return const LuxuryCard(child: Center(child: CircularProgressIndicator()));
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return LuxuryCard(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.errorColor),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyAdminList extends StatelessWidget {
  const _EmptyAdminList({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppTheme.textSecondaryLight),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
