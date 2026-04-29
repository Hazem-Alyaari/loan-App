import 'package:loan/features/notifications/domain/models/app_notification.dart';

/// Contract for notification operations.
abstract class INotificationRepository {
  /// Watch notifications for a user, ordered by creation date (newest first).
  Stream<List<AppNotification>> watchUserNotifications(String userId);

  /// Mark a single notification as read.
  Future<void> markAsRead(String userId, String notificationId);

  /// Mark all notifications for a user as read.
  Future<void> markAllAsRead(String userId);

  /// Get unread notification count.
  Stream<int> watchUnreadCount(String userId);
}
