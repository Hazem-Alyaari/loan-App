/// Authentication providers supported by the app.
enum AuthProvider { email, google, apple }

/// Roles a user can have within a group.
enum MemberRole { owner, admin, member }

/// Status of a group member invitation.
enum MemberStatus { invited, active, removed }

/// Types of financial transactions.
enum TransactionType { loan, repayment, correction }

/// Status of a transaction in its lifecycle.
enum TransactionStatus { pending, approved, rejected, cancelled }

/// Status of an individual approval response.
enum ApprovalStatus { pending, approved, rejected }

/// Types of notifications.
enum NotificationType {
  approvalRequest,
  transactionApproved,
  transactionRejected,
  balanceUpdated,
}
