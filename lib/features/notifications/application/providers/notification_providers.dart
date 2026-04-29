import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan/features/auth/application/providers/auth_providers.dart';
import 'package:loan/features/notifications/domain/models/app_notification.dart';
import 'package:loan/features/notifications/domain/repositories/i_notification_repository.dart';
import 'package:loan/features/notifications/infrastructure/repositories/notification_repository.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------
final notificationRepositoryProvider =
    Provider<INotificationRepository>((ref) {
  return NotificationRepository(firestore: ref.watch(firestoreProvider));
});

// ---------------------------------------------------------------------------
// User notifications stream
// ---------------------------------------------------------------------------
final userNotificationsProvider =
    StreamProvider<List<AppNotification>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(notificationRepositoryProvider).watchUserNotifications(uid);
});

// ---------------------------------------------------------------------------
// Unread count stream
// ---------------------------------------------------------------------------
final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value(0);
  return ref.watch(notificationRepositoryProvider).watchUnreadCount(uid);
});

// ---------------------------------------------------------------------------
// Notification controller
// ---------------------------------------------------------------------------
final notificationControllerProvider =
    AsyncNotifierProvider<NotificationController, void>(
        NotificationController.new);

class NotificationController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> markAsRead(String notificationId) async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(notificationRepositoryProvider)
          .markAsRead(uid, notificationId),
    );
  }

  Future<void> markAllAsRead() async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(notificationRepositoryProvider).markAllAsRead(uid),
    );
  }
}
