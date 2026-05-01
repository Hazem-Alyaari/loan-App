import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/core/locale/l10n_context.dart';
import 'package:loan/features/auth/application/providers/auth_providers.dart';
import 'package:loan/features/auth/presentation/screens/login_screen.dart';
import 'package:loan/features/auth/presentation/screens/privacy_policy_screen.dart';
import 'package:loan/features/auth/presentation/screens/profile_screen.dart';
import 'package:loan/features/auth/presentation/screens/register_screen.dart';
import 'package:loan/features/groups/presentation/screens/groups_list_screen.dart';
import 'package:loan/features/groups/presentation/screens/create_group_screen.dart';
import 'package:loan/features/groups/presentation/screens/group_details_screen.dart';
import 'package:loan/features/transactions/presentation/screens/create_transaction_screen.dart';
import 'package:loan/features/transactions/presentation/screens/transaction_details_screen.dart';
import 'package:loan/features/notifications/presentation/screens/notifications_screen.dart';

/// Rebuilds [GoRouter] redirect logic when auth changes without disposing/recreating
/// the router (recreating [GoRouter] on every auth tick breaks matching on web).
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefreshNotifier(ref);
  final router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final isLoggedIn = auth.value != null;
      final loc = state.uri.path;
      final isPublicAuthRoute = loc == '/login' ||
          loc == '/register' ||
          loc == '/privacy';

      if (!isLoggedIn && !isPublicAuthRoute) return '/login';
      if (isLoggedIn && (loc == '/login' || loc == '/register')) {
        return '/groups';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/login',
      ),
      // ── Auth ────────────────────────────────────────────────
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // ── Groups ──────────────────────────────────────────────
      GoRoute(
        path: '/groups',
        builder: (context, state) => const GroupsListScreen(),
      ),
      GoRoute(
        path: '/create-group',
        builder: (context, state) => const CreateGroupScreen(),
      ),
      GoRoute(
        path: '/groups/:groupId',
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;
          return GroupDetailsScreen(groupId: groupId);
        },
        routes: [
          GoRoute(
            path: 'create-transaction',
            builder: (context, state) {
              final groupId = state.pathParameters['groupId']!;
              return CreateTransactionScreen(groupId: groupId);
            },
          ),
          GoRoute(
            path: 'transactions/:transactionId',
            builder: (context, state) {
              final groupId = state.pathParameters['groupId']!;
              final transactionId = state.pathParameters['transactionId']!;
              return TransactionDetailsScreen(
                groupId: groupId,
                transactionId: transactionId,
              );
            },
          ),
        ],
      ),

      // ── Notifications ───────────────────────────────────────
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          context.l10n.routerNotFound(state.error?.toString() ?? ''),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
});
