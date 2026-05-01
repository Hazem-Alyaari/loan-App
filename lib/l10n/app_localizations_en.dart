// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Loan Track';

  @override
  String errorPrefix(String details) {
    return 'Error: $details';
  }

  @override
  String get userNotLoggedIn => 'You are not signed in';

  @override
  String get loginWelcomeBack => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to manage shared expenses';

  @override
  String get hintPassword => 'Password';

  @override
  String get valPasswordRequired => 'Password is required';

  @override
  String get valPasswordMin6 => 'Password must be at least 6 characters';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get createAccountLink => 'Create account';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get snackPhoneRequired => 'Phone number is required';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Start managing your group expenses today';

  @override
  String get hintFullName => 'Full name';

  @override
  String get valNameRequired => 'Name is required';

  @override
  String get hintConfirmPassword => 'Confirm password';

  @override
  String get valPasswordMismatch => 'Passwords do not match';

  @override
  String get createAccountBtn => 'Create account';

  @override
  String get haveAccount => 'Already have an account? ';

  @override
  String get signInLink => 'Sign in';

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileMissing => 'Profile could not be loaded';

  @override
  String get labelPhone => 'Phone';

  @override
  String get labelAuthMethod => 'Sign-in method';

  @override
  String get defaultPasswordBanner =>
      'Your account uses the default password. Please change it now.';

  @override
  String get privacyRelated => 'Privacy policy';

  @override
  String get privacyRelatedSub => 'See how your data is used';

  @override
  String get changePassword => 'Change password';

  @override
  String get hintCurrentPassword => 'Current password';

  @override
  String get hintNewPassword => 'New password';

  @override
  String get savePassword => 'Save password';

  @override
  String get passwordChangedSnack => 'Password updated';

  @override
  String get valCurrentPasswordRequired => 'Current password is required';

  @override
  String get valNewPasswordRequired => 'New password is required';

  @override
  String get valNewPasswordMin8 => 'New password must be at least 8 characters';

  @override
  String get hintConfirmNewPassword => 'Confirm new password';

  @override
  String get updatePasswordButton => 'Update password';

  @override
  String get authProviderEmail => 'Phone and password';

  @override
  String get authProviderGoogle => 'Google';

  @override
  String get labelLanguage => 'Language';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageEnglish => 'English';

  @override
  String get groupsTitle => 'My groups';

  @override
  String get groupsSubtitle => 'Manage shared expenses';

  @override
  String get emptyGroupsTitle => 'No groups yet';

  @override
  String get emptyGroupsHint => 'Create your first group to get started';

  @override
  String get newGroupFab => 'New group';

  @override
  String membersCountLine(int count, String currency) {
    return '$count members • $currency';
  }

  @override
  String get createGroupTitle => 'Create group';

  @override
  String get groupNameLabel => 'Group name';

  @override
  String get groupNameHint => 'e.g. Weekend trip';

  @override
  String get valGroupNameRequired => 'Group name is required';

  @override
  String get valGroupNameTooLong => 'Group name is too long';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get createGroupBtn => 'Create group';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get notifEmptyTitle => 'No notifications';

  @override
  String get notifEmptySub => 'Nothing new right now';

  @override
  String get loadMore => 'Load more';

  @override
  String get timeNow => 'Just now';

  @override
  String timeMinutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String timeDate(int day, int month, int year) {
    return '$day/$month/$year';
  }

  @override
  String get privacyScreenTitle => 'Privacy policy';

  @override
  String privacyUpdated(int year) {
    return 'Last updated: $year';
  }

  @override
  String get privacyS1t => '1. Introduction';

  @override
  String get privacyS1b =>
      'We respect your privacy. This policy explains how we collect, use, and share information when you use the app (groups, transactions, balances, and notifications). By using the app you agree to this policy.';

  @override
  String get privacyS2t => '2. Data we collect';

  @override
  String get privacyS2b =>
      '• Account: name, phone or email, and sign-in via identity providers (e.g. Google) when enabled.\n• Groups & transactions: amounts, parties, statuses, and notes you enter.\n• Device & usage: technical identifiers needed to run the service.\n• Notifications: content related to transactions, approvals, and settlements.';

  @override
  String get privacyS3t => '3. How we use data';

  @override
  String get privacyS3b =>
      'We use data to run the app, show balances and transactions, send notifications to affected users, improve security and stability, and comply with legal obligations when required.';

  @override
  String get privacyS4t => '4. Third parties';

  @override
  String get privacyS4b =>
      'We may rely on providers (hosting, authentication, notifications) to process data under their terms. We do not sell your personal data for marketing.';

  @override
  String get privacyS5t => '5. Storage & security';

  @override
  String get privacyS5b =>
      'We apply reasonable technical and organizational measures. No system is 100% secure—use a strong password and do not share your account.';

  @override
  String get privacyS6t => '6. Retention';

  @override
  String get privacyS6b =>
      'We keep data while your account is active or as needed to provide the service and meet legal duties. You may request deletion subject to product and legal limits.';

  @override
  String get privacyS7t => '7. Your rights';

  @override
  String get privacyS7b =>
      'Depending on your jurisdiction, you may access, correct, delete, or restrict processing. Contact official support channels.';

  @override
  String get privacyS8t => '8. Updates';

  @override
  String get privacyS8b =>
      'We may update this policy from time to time. Material changes will be communicated as required by law or the product.';

  @override
  String get privacyS9t => '9. Contact';

  @override
  String get privacyS9b =>
      'For privacy questions, contact the official support channel listed in the app or developer page.';

  @override
  String routerNotFound(String error) {
    return 'Page not found: $error';
  }

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get searchCountryHint => 'Search country';

  @override
  String get mobileHint => 'Mobile number';

  @override
  String get txnNewTitle => 'New transaction';

  @override
  String get txnType => 'Type';

  @override
  String get amountLabel => 'Amount';

  @override
  String get amountHint => '0.00';

  @override
  String get valAmountRequired => 'Amount is required';

  @override
  String get valAmountInvalid => 'Enter a valid amount';

  @override
  String get amountNegativeHint =>
      'If the amount is negative, creditor and debtor will swap automatically';

  @override
  String get creditorLabel => 'Creditor (lender)';

  @override
  String get creditorHint => 'Current creditor';

  @override
  String get debtorLabel => 'Debtor (borrower)';

  @override
  String get debtorHint => 'Choose debtor';

  @override
  String get noteLabel => 'Note (optional)';

  @override
  String get noteHint => 'Note about this transaction';

  @override
  String get createTxnBtn => 'Create transaction';

  @override
  String get me => 'Me';

  @override
  String txnError(String e) {
    return 'Error: $e';
  }

  @override
  String get pickDebtorSnack => 'Please choose a debtor';

  @override
  String get selfDebtorSnack => 'You cannot choose yourself as debtor';

  @override
  String get noteTooLongSnack => 'Note is too long (max 250 characters)';

  @override
  String get txnDetailTitle => 'Transaction details';

  @override
  String get labelCreditor => 'Creditor';

  @override
  String get labelDebtor => 'Debtor';

  @override
  String get labelNote => 'Note';

  @override
  String get labelCreatedAt => 'Created at';

  @override
  String get labelApprovedAt => 'Approved at';

  @override
  String get labelRejectedAt => 'Rejected at';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get debtorOnlyActions => 'Only the debtor can approve or reject';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMember => 'Member';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get typeLoan => 'Loan';

  @override
  String get typeRepayment => 'Repayment';

  @override
  String get typeCorrection => 'Correction';

  @override
  String get gdTabBalances => 'Balances';

  @override
  String get gdTabTransactions => 'Transactions';

  @override
  String get gdTabAnalysis => 'Analysis';

  @override
  String get gdTabMembers => 'Members';

  @override
  String gdMembersCount(int count) {
    return '$count members';
  }

  @override
  String get gdSnackTxAdded => 'Transaction added';

  @override
  String get gdMyBalance => 'My balance';

  @override
  String get gdAllBalances => 'Everyone\'s balances';

  @override
  String get gdYourBalanceTitle => 'Your current balance';

  @override
  String get gdYourBalanceSubtitle =>
      'A clear summary of your position in this group';

  @override
  String get gdOwedToYou => 'Owed to you';

  @override
  String get gdYouOweOthers => 'You owe others';

  @override
  String get gdNet => 'Net';

  @override
  String get gdBalancesSection => 'Balances';

  @override
  String get gdNoBalances => 'No balances to show yet.';

  @override
  String get gdReceivableGroup => 'Receivable from group';

  @override
  String get gdPayableGroup => 'Payable to group';

  @override
  String get gdBalanced => 'Balanced';

  @override
  String gdSettlementMember(String name) {
    return 'Member settlement • $name';
  }

  @override
  String gdOwesTo(String name) {
    return 'Owes to $name';
  }

  @override
  String gdOwedBy(String name) {
    return 'Owed by $name';
  }

  @override
  String get gdNoOpenSettlements => 'No open settlements for this member.';

  @override
  String get gdSummary => 'Summary';

  @override
  String gdTotalReceivable(String amount, String currency) {
    return 'Total receivable: $amount $currency';
  }

  @override
  String gdTotalPayable(String amount, String currency) {
    return 'Total payable: $amount $currency';
  }

  @override
  String gdNetLine(String sign, String amount, String currency) {
    return 'Net: $sign$amount $currency';
  }

  @override
  String get gdProposalExpired =>
      'Proposal expired — you can run discovery again';

  @override
  String gdProposalLeftH(int h, int m) {
    return 'Time left: $h h $m min';
  }

  @override
  String gdProposalLeftM(int m) {
    return 'Time left: $m min';
  }

  @override
  String get voteApproved => 'Approved';

  @override
  String get voteRejected => 'Rejected';

  @override
  String get votePending => 'Pending';

  @override
  String get gdCircularTitle => 'Circular debt settlement';

  @override
  String gdDiscoverySome(int count) {
    return '$count settlement proposal(s) created (12h validity)';
  }

  @override
  String get gdDiscoveryNone => 'No new settlement cycles right now';

  @override
  String get gdDiscover => 'Discover';

  @override
  String get gdSettlementHelp =>
      'Any member can find a debt cycle and create a proposal. Everyone sees it; it expires after 12h if voting is incomplete.';

  @override
  String gdProposalLine(String amount, String currency) {
    return 'Settlement • $amount $currency';
  }

  @override
  String get gdReadOnlyVote =>
      'Read-only — voting is for participants in the cycle';

  @override
  String get gdReject => 'Reject';

  @override
  String get gdApprove => 'Approve';

  @override
  String get gdAnalysisNoTx =>
      'No approved transactions for monthly analysis (or hidden by your permissions)';

  @override
  String gdTxCountMonth(int count) {
    return '$count transactions';
  }

  @override
  String get gdMonthlyTotal => 'Month total';

  @override
  String get gdYouReceived => 'You received';

  @override
  String get gdYouPaid => 'You paid';

  @override
  String get gdNewMember => 'New member';

  @override
  String get gdNoMembers => 'No members';

  @override
  String get gdAddMemberTitle => 'Add member';

  @override
  String get gdMemberNameHint => 'Member name';

  @override
  String get gdPhoneHint => 'Phone number';

  @override
  String get gdCancel => 'Cancel';

  @override
  String get gdAdd => 'Add';

  @override
  String get gdValMemberNameRequired => 'Member name is required';

  @override
  String get gdValMemberNameTooLong => 'Member name is too long';

  @override
  String get gdValPhoneTooLong => 'Phone number is too long';

  @override
  String get gdValPhoneRequired => 'Phone number is required';

  @override
  String get gdMemberAddedOk => 'Member added successfully';

  @override
  String get gdFilterUser => 'Filter by user';

  @override
  String get gdAllUsers => 'All users';

  @override
  String get gdNoTx => 'No transactions yet';

  @override
  String get gdNoTxUser => 'No transactions for this user';

  @override
  String get gdNoTxYou => 'No transactions for you right now';

  @override
  String get gdAutoSettlement => 'Auto settlement';

  @override
  String get gdSettlementTitle => 'Settlement';
}
