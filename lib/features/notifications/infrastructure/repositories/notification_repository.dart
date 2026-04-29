import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan/features/notifications/domain/models/app_notification.dart';
import 'package:loan/features/notifications/domain/repositories/i_notification_repository.dart';

class NotificationRepository implements INotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _notifRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('notifications');

  @override
  Stream<List<AppNotification>> watchUserNotifications(String userId) {
    return _notifRef(userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppNotification.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    await _notifRef(userId).doc(notificationId).update({'isRead': true});
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final unread =
        await _notifRef(userId).where('isRead', isEqualTo: false).get();

    for (final doc in unread.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  @override
  Stream<int> watchUnreadCount(String userId) {
    return _notifRef(userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
