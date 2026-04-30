import 'package:loan/features/notifications/domain/models/app_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Contract for notification operations.
abstract class INotificationRepository {
  /// Watch notifications for a user, ordered by creation date (newest first).
  Stream<List<AppNotification>> watchUserNotifications(String userId);

  /// Fetch notifications page for pagination.
  Future<
      ({
        List<AppNotification> items,
        QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
        bool hasMore,
      })> fetchUserNotificationsPage(
    String userId, {
    QueryDocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 8,
  });

  /// Mark a single notification as read.
  Future<void> markAsRead(String userId, String notificationId);

  /// Mark all notifications for a user as read.
  Future<void> markAllAsRead(String userId);

  /// Get unread notification count.
  Stream<int> watchUnreadCount(String userId);
}
