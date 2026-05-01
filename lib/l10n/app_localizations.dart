import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Loan Track'**
  String get appTitle;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {details}'**
  String errorPrefix(String details);

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'You are not signed in'**
  String get userNotLoggedIn;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage shared expenses'**
  String get loginSubtitle;

  /// No description provided for @hintPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get hintPassword;

  /// No description provided for @valPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get valPasswordRequired;

  /// No description provided for @valPasswordMin6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get valPasswordMin6;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @createAccountLink.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountLink;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @snackPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get snackPhoneRequired;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start managing your group expenses today'**
  String get registerSubtitle;

  /// No description provided for @hintFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get hintFullName;

  /// No description provided for @valNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get valNameRequired;

  /// No description provided for @hintConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get hintConfirmPassword;

  /// No description provided for @valPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get valPasswordMismatch;

  /// No description provided for @createAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountBtn;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get haveAccount;

  /// No description provided for @signInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInLink;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get profileTitle;

  /// No description provided for @profileMissing.
  ///
  /// In en, this message translates to:
  /// **'Profile could not be loaded'**
  String get profileMissing;

  /// No description provided for @labelPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get labelPhone;

  /// No description provided for @labelAuthMethod.
  ///
  /// In en, this message translates to:
  /// **'Sign-in method'**
  String get labelAuthMethod;

  /// No description provided for @defaultPasswordBanner.
  ///
  /// In en, this message translates to:
  /// **'Your account uses the default password. Please change it now.'**
  String get defaultPasswordBanner;

  /// No description provided for @privacyRelated.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyRelated;

  /// No description provided for @privacyRelatedSub.
  ///
  /// In en, this message translates to:
  /// **'See how your data is used'**
  String get privacyRelatedSub;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @hintCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get hintCurrentPassword;

  /// No description provided for @hintNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get hintNewPassword;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get savePassword;

  /// No description provided for @passwordChangedSnack.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordChangedSnack;

  /// No description provided for @valCurrentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get valCurrentPasswordRequired;

  /// No description provided for @valNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get valNewPasswordRequired;

  /// No description provided for @valNewPasswordMin8.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 8 characters'**
  String get valNewPasswordMin8;

  /// No description provided for @hintConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get hintConfirmNewPassword;

  /// No description provided for @updatePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePasswordButton;

  /// No description provided for @authProviderEmail.
  ///
  /// In en, this message translates to:
  /// **'Phone and password'**
  String get authProviderEmail;

  /// No description provided for @authProviderGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get authProviderGoogle;

  /// No description provided for @labelLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get labelLanguage;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @groupsTitle.
  ///
  /// In en, this message translates to:
  /// **'My groups'**
  String get groupsTitle;

  /// No description provided for @groupsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage shared expenses'**
  String get groupsSubtitle;

  /// No description provided for @emptyGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get emptyGroupsTitle;

  /// No description provided for @emptyGroupsHint.
  ///
  /// In en, this message translates to:
  /// **'Create your first group to get started'**
  String get emptyGroupsHint;

  /// No description provided for @newGroupFab.
  ///
  /// In en, this message translates to:
  /// **'New group'**
  String get newGroupFab;

  /// No description provided for @membersCountLine.
  ///
  /// In en, this message translates to:
  /// **'{count} members • {currency}'**
  String membersCountLine(int count, String currency);

  /// No description provided for @createGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get createGroupTitle;

  /// No description provided for @groupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get groupNameLabel;

  /// No description provided for @groupNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Weekend trip'**
  String get groupNameHint;

  /// No description provided for @valGroupNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Group name is required'**
  String get valGroupNameRequired;

  /// No description provided for @valGroupNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Group name is too long'**
  String get valGroupNameTooLong;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @createGroupBtn.
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get createGroupBtn;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// No description provided for @notifEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notifEmptyTitle;

  /// No description provided for @notifEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Nothing new right now'**
  String get notifEmptySub;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @timeNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String timeHoursAgo(int count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String timeDaysAgo(int count);

  /// No description provided for @timeDate.
  ///
  /// In en, this message translates to:
  /// **'{day}/{month}/{year}'**
  String timeDate(int day, int month, int year);

  /// No description provided for @privacyScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyScreenTitle;

  /// No description provided for @privacyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {year}'**
  String privacyUpdated(int year);

  /// No description provided for @privacyS1t.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get privacyS1t;

  /// No description provided for @privacyS1b.
  ///
  /// In en, this message translates to:
  /// **'We respect your privacy. This policy explains how we collect, use, and share information when you use the app (groups, transactions, balances, and notifications). By using the app you agree to this policy.'**
  String get privacyS1b;

  /// No description provided for @privacyS2t.
  ///
  /// In en, this message translates to:
  /// **'2. Data we collect'**
  String get privacyS2t;

  /// No description provided for @privacyS2b.
  ///
  /// In en, this message translates to:
  /// **'• Account: name, phone or email, and sign-in via identity providers (e.g. Google) when enabled.\n• Groups & transactions: amounts, parties, statuses, and notes you enter.\n• Device & usage: technical identifiers needed to run the service.\n• Notifications: content related to transactions, approvals, and settlements.'**
  String get privacyS2b;

  /// No description provided for @privacyS3t.
  ///
  /// In en, this message translates to:
  /// **'3. How we use data'**
  String get privacyS3t;

  /// No description provided for @privacyS3b.
  ///
  /// In en, this message translates to:
  /// **'We use data to run the app, show balances and transactions, send notifications to affected users, improve security and stability, and comply with legal obligations when required.'**
  String get privacyS3b;

  /// No description provided for @privacyS4t.
  ///
  /// In en, this message translates to:
  /// **'4. Third parties'**
  String get privacyS4t;

  /// No description provided for @privacyS4b.
  ///
  /// In en, this message translates to:
  /// **'We may rely on providers (hosting, authentication, notifications) to process data under their terms. We do not sell your personal data for marketing.'**
  String get privacyS4b;

  /// No description provided for @privacyS5t.
  ///
  /// In en, this message translates to:
  /// **'5. Storage & security'**
  String get privacyS5t;

  /// No description provided for @privacyS5b.
  ///
  /// In en, this message translates to:
  /// **'We apply reasonable technical and organizational measures. No system is 100% secure—use a strong password and do not share your account.'**
  String get privacyS5b;

  /// No description provided for @privacyS6t.
  ///
  /// In en, this message translates to:
  /// **'6. Retention'**
  String get privacyS6t;

  /// No description provided for @privacyS6b.
  ///
  /// In en, this message translates to:
  /// **'We keep data while your account is active or as needed to provide the service and meet legal duties. You may request deletion subject to product and legal limits.'**
  String get privacyS6b;

  /// No description provided for @privacyS7t.
  ///
  /// In en, this message translates to:
  /// **'7. Your rights'**
  String get privacyS7t;

  /// No description provided for @privacyS7b.
  ///
  /// In en, this message translates to:
  /// **'Depending on your jurisdiction, you may access, correct, delete, or restrict processing. Contact official support channels.'**
  String get privacyS7b;

  /// No description provided for @privacyS8t.
  ///
  /// In en, this message translates to:
  /// **'8. Updates'**
  String get privacyS8t;

  /// No description provided for @privacyS8b.
  ///
  /// In en, this message translates to:
  /// **'We may update this policy from time to time. Material changes will be communicated as required by law or the product.'**
  String get privacyS8b;

  /// No description provided for @privacyS9t.
  ///
  /// In en, this message translates to:
  /// **'9. Contact'**
  String get privacyS9t;

  /// No description provided for @privacyS9b.
  ///
  /// In en, this message translates to:
  /// **'For privacy questions, contact the official support channel listed in the app or developer page.'**
  String get privacyS9b;

  /// No description provided for @routerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found: {error}'**
  String routerNotFound(String error);

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @searchCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get searchCountryHint;

  /// No description provided for @mobileHint.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileHint;

  /// No description provided for @txnNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get txnNewTitle;

  /// No description provided for @txnType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get txnType;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get amountHint;

  /// No description provided for @valAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get valAmountRequired;

  /// No description provided for @valAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get valAmountInvalid;

  /// No description provided for @amountNegativeHint.
  ///
  /// In en, this message translates to:
  /// **'If the amount is negative, creditor and debtor will swap automatically'**
  String get amountNegativeHint;

  /// No description provided for @creditorLabel.
  ///
  /// In en, this message translates to:
  /// **'Creditor (lender)'**
  String get creditorLabel;

  /// No description provided for @creditorHint.
  ///
  /// In en, this message translates to:
  /// **'Current creditor'**
  String get creditorHint;

  /// No description provided for @debtorLabel.
  ///
  /// In en, this message translates to:
  /// **'Debtor (borrower)'**
  String get debtorLabel;

  /// No description provided for @debtorHint.
  ///
  /// In en, this message translates to:
  /// **'Choose debtor'**
  String get debtorHint;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteLabel;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Note about this transaction'**
  String get noteHint;

  /// No description provided for @createTxnBtn.
  ///
  /// In en, this message translates to:
  /// **'Create transaction'**
  String get createTxnBtn;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @txnError.
  ///
  /// In en, this message translates to:
  /// **'Error: {e}'**
  String txnError(String e);

  /// No description provided for @pickDebtorSnack.
  ///
  /// In en, this message translates to:
  /// **'Please choose a debtor'**
  String get pickDebtorSnack;

  /// No description provided for @selfDebtorSnack.
  ///
  /// In en, this message translates to:
  /// **'You cannot choose yourself as debtor'**
  String get selfDebtorSnack;

  /// No description provided for @noteTooLongSnack.
  ///
  /// In en, this message translates to:
  /// **'Note is too long (max 250 characters)'**
  String get noteTooLongSnack;

  /// No description provided for @txnDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction details'**
  String get txnDetailTitle;

  /// No description provided for @labelCreditor.
  ///
  /// In en, this message translates to:
  /// **'Creditor'**
  String get labelCreditor;

  /// No description provided for @labelDebtor.
  ///
  /// In en, this message translates to:
  /// **'Debtor'**
  String get labelDebtor;

  /// No description provided for @labelNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get labelNote;

  /// No description provided for @labelCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get labelCreatedAt;

  /// No description provided for @labelApprovedAt.
  ///
  /// In en, this message translates to:
  /// **'Approved at'**
  String get labelApprovedAt;

  /// No description provided for @labelRejectedAt.
  ///
  /// In en, this message translates to:
  /// **'Rejected at'**
  String get labelRejectedAt;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @debtorOnlyActions.
  ///
  /// In en, this message translates to:
  /// **'Only the debtor can approve or reject'**
  String get debtorOnlyActions;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get roleMember;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @typeLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get typeLoan;

  /// No description provided for @typeRepayment.
  ///
  /// In en, this message translates to:
  /// **'Repayment'**
  String get typeRepayment;

  /// No description provided for @typeCorrection.
  ///
  /// In en, this message translates to:
  /// **'Correction'**
  String get typeCorrection;

  /// No description provided for @gdTabBalances.
  ///
  /// In en, this message translates to:
  /// **'Balances'**
  String get gdTabBalances;

  /// No description provided for @gdTabTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get gdTabTransactions;

  /// No description provided for @gdTabAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get gdTabAnalysis;

  /// No description provided for @gdTabMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get gdTabMembers;

  /// No description provided for @gdMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String gdMembersCount(int count);

  /// No description provided for @gdSnackTxAdded.
  ///
  /// In en, this message translates to:
  /// **'Transaction added'**
  String get gdSnackTxAdded;

  /// No description provided for @gdMyBalance.
  ///
  /// In en, this message translates to:
  /// **'My balance'**
  String get gdMyBalance;

  /// No description provided for @gdAllBalances.
  ///
  /// In en, this message translates to:
  /// **'Everyone\'s balances'**
  String get gdAllBalances;

  /// No description provided for @gdYourBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Your current balance'**
  String get gdYourBalanceTitle;

  /// No description provided for @gdYourBalanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A clear summary of your position in this group'**
  String get gdYourBalanceSubtitle;

  /// No description provided for @gdOwedToYou.
  ///
  /// In en, this message translates to:
  /// **'Owed to you'**
  String get gdOwedToYou;

  /// No description provided for @gdYouOweOthers.
  ///
  /// In en, this message translates to:
  /// **'You owe others'**
  String get gdYouOweOthers;

  /// No description provided for @gdNet.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get gdNet;

  /// No description provided for @gdBalancesSection.
  ///
  /// In en, this message translates to:
  /// **'Balances'**
  String get gdBalancesSection;

  /// No description provided for @gdNoBalances.
  ///
  /// In en, this message translates to:
  /// **'No balances to show yet.'**
  String get gdNoBalances;

  /// No description provided for @gdReceivableGroup.
  ///
  /// In en, this message translates to:
  /// **'Receivable from group'**
  String get gdReceivableGroup;

  /// No description provided for @gdPayableGroup.
  ///
  /// In en, this message translates to:
  /// **'Payable to group'**
  String get gdPayableGroup;

  /// No description provided for @gdBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get gdBalanced;

  /// No description provided for @gdSettlementMember.
  ///
  /// In en, this message translates to:
  /// **'Member settlement • {name}'**
  String gdSettlementMember(String name);

  /// No description provided for @gdOwesTo.
  ///
  /// In en, this message translates to:
  /// **'Owes to {name}'**
  String gdOwesTo(String name);

  /// No description provided for @gdOwedBy.
  ///
  /// In en, this message translates to:
  /// **'Owed by {name}'**
  String gdOwedBy(String name);

  /// No description provided for @gdNoOpenSettlements.
  ///
  /// In en, this message translates to:
  /// **'No open settlements for this member.'**
  String get gdNoOpenSettlements;

  /// No description provided for @gdSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get gdSummary;

  /// No description provided for @gdTotalReceivable.
  ///
  /// In en, this message translates to:
  /// **'Total receivable: {amount} {currency}'**
  String gdTotalReceivable(String amount, String currency);

  /// No description provided for @gdTotalPayable.
  ///
  /// In en, this message translates to:
  /// **'Total payable: {amount} {currency}'**
  String gdTotalPayable(String amount, String currency);

  /// No description provided for @gdNetLine.
  ///
  /// In en, this message translates to:
  /// **'Net: {sign}{amount} {currency}'**
  String gdNetLine(String sign, String amount, String currency);

  /// No description provided for @gdProposalExpired.
  ///
  /// In en, this message translates to:
  /// **'Proposal expired — you can run discovery again'**
  String get gdProposalExpired;

  /// No description provided for @gdProposalLeftH.
  ///
  /// In en, this message translates to:
  /// **'Time left: {h} h {m} min'**
  String gdProposalLeftH(int h, int m);

  /// No description provided for @gdProposalLeftM.
  ///
  /// In en, this message translates to:
  /// **'Time left: {m} min'**
  String gdProposalLeftM(int m);

  /// No description provided for @voteApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get voteApproved;

  /// No description provided for @voteRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get voteRejected;

  /// No description provided for @votePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get votePending;

  /// No description provided for @gdCircularTitle.
  ///
  /// In en, this message translates to:
  /// **'Circular debt settlement'**
  String get gdCircularTitle;

  /// No description provided for @gdDiscoverySome.
  ///
  /// In en, this message translates to:
  /// **'{count} settlement proposal(s) created (12h validity)'**
  String gdDiscoverySome(int count);

  /// No description provided for @gdDiscoveryNone.
  ///
  /// In en, this message translates to:
  /// **'No new settlement cycles right now'**
  String get gdDiscoveryNone;

  /// No description provided for @gdDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get gdDiscover;

  /// No description provided for @gdSettlementHelp.
  ///
  /// In en, this message translates to:
  /// **'Any member can find a debt cycle and create a proposal. Everyone sees it; it expires after 12h if voting is incomplete.'**
  String get gdSettlementHelp;

  /// No description provided for @gdProposalLine.
  ///
  /// In en, this message translates to:
  /// **'Settlement • {amount} {currency}'**
  String gdProposalLine(String amount, String currency);

  /// No description provided for @gdReadOnlyVote.
  ///
  /// In en, this message translates to:
  /// **'Read-only — voting is for participants in the cycle'**
  String get gdReadOnlyVote;

  /// No description provided for @gdReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get gdReject;

  /// No description provided for @gdApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get gdApprove;

  /// No description provided for @gdAnalysisNoTx.
  ///
  /// In en, this message translates to:
  /// **'No approved transactions for monthly analysis (or hidden by your permissions)'**
  String get gdAnalysisNoTx;

  /// No description provided for @gdTxCountMonth.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String gdTxCountMonth(int count);

  /// No description provided for @gdMonthlyTotal.
  ///
  /// In en, this message translates to:
  /// **'Month total'**
  String get gdMonthlyTotal;

  /// No description provided for @gdYouReceived.
  ///
  /// In en, this message translates to:
  /// **'You received'**
  String get gdYouReceived;

  /// No description provided for @gdYouPaid.
  ///
  /// In en, this message translates to:
  /// **'You paid'**
  String get gdYouPaid;

  /// No description provided for @gdNewMember.
  ///
  /// In en, this message translates to:
  /// **'New member'**
  String get gdNewMember;

  /// No description provided for @gdNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No members'**
  String get gdNoMembers;

  /// No description provided for @gdAddMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get gdAddMemberTitle;

  /// No description provided for @gdMemberNameHint.
  ///
  /// In en, this message translates to:
  /// **'Member name'**
  String get gdMemberNameHint;

  /// No description provided for @gdPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get gdPhoneHint;

  /// No description provided for @gdCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get gdCancel;

  /// No description provided for @gdAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get gdAdd;

  /// No description provided for @gdValMemberNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Member name is required'**
  String get gdValMemberNameRequired;

  /// No description provided for @gdValMemberNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Member name is too long'**
  String get gdValMemberNameTooLong;

  /// No description provided for @gdValPhoneTooLong.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too long'**
  String get gdValPhoneTooLong;

  /// No description provided for @gdValPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get gdValPhoneRequired;

  /// No description provided for @gdMemberAddedOk.
  ///
  /// In en, this message translates to:
  /// **'Member added successfully'**
  String get gdMemberAddedOk;

  /// No description provided for @gdFilterUser.
  ///
  /// In en, this message translates to:
  /// **'Filter by user'**
  String get gdFilterUser;

  /// No description provided for @gdAllUsers.
  ///
  /// In en, this message translates to:
  /// **'All users'**
  String get gdAllUsers;

  /// No description provided for @gdNoTx.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get gdNoTx;

  /// No description provided for @gdNoTxUser.
  ///
  /// In en, this message translates to:
  /// **'No transactions for this user'**
  String get gdNoTxUser;

  /// No description provided for @gdNoTxYou.
  ///
  /// In en, this message translates to:
  /// **'No transactions for you right now'**
  String get gdNoTxYou;

  /// No description provided for @gdAutoSettlement.
  ///
  /// In en, this message translates to:
  /// **'Auto settlement'**
  String get gdAutoSettlement;

  /// No description provided for @gdSettlementTitle.
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get gdSettlementTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
