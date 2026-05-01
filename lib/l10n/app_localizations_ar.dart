// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'لون تراك';

  @override
  String errorPrefix(String details) {
    return 'خطأ: $details';
  }

  @override
  String get userNotLoggedIn => 'المستخدم غير مسجل الدخول';

  @override
  String get loginWelcomeBack => 'أهلا بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول لإدارة المصروفات الجماعية';

  @override
  String get hintPassword => 'كلمة المرور';

  @override
  String get valPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get valPasswordMin6 => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get noAccount => 'ليس لديك حساب؟ ';

  @override
  String get createAccountLink => 'إنشاء حساب';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get snackPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'ابدأ إدارة مصروفات مجموعتك اليوم';

  @override
  String get hintFullName => 'الاسم الكامل';

  @override
  String get valNameRequired => 'الاسم مطلوب';

  @override
  String get hintConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get valPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get createAccountBtn => 'إنشاء الحساب';

  @override
  String get haveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get signInLink => 'تسجيل الدخول';

  @override
  String get profileTitle => 'ملفي الشخصي';

  @override
  String get profileMissing => 'تعذر العثور على الملف الشخصي';

  @override
  String get labelPhone => 'الهاتف';

  @override
  String get labelAuthMethod => 'طريقة تسجيل الدخول';

  @override
  String get defaultPasswordBanner =>
      'حسابك يستخدم كلمة المرور الافتراضية. يرجى تغييرها الآن.';

  @override
  String get privacyRelated => 'سياسة الخصوصية';

  @override
  String get privacyRelatedSub => 'اطّلع على كيفية استخدام بياناتك';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get hintCurrentPassword => 'كلمة المرور الحالية';

  @override
  String get hintNewPassword => 'كلمة المرور الجديدة';

  @override
  String get savePassword => 'حفظ كلمة المرور';

  @override
  String get passwordChangedSnack => 'تم تحديث كلمة المرور';

  @override
  String get valCurrentPasswordRequired => 'كلمة المرور الحالية مطلوبة';

  @override
  String get valNewPasswordRequired => 'كلمة المرور الجديدة مطلوبة';

  @override
  String get valNewPasswordMin8 => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get hintConfirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get updatePasswordButton => 'تحديث كلمة المرور';

  @override
  String get authProviderEmail => 'الهاتف وكلمة المرور';

  @override
  String get authProviderGoogle => 'Google';

  @override
  String get labelLanguage => 'اللغة';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get groupsTitle => 'مجموعاتي';

  @override
  String get groupsSubtitle => 'إدارة المصروفات الجماعية';

  @override
  String get emptyGroupsTitle => 'لا توجد مجموعات بعد';

  @override
  String get emptyGroupsHint => 'أنشئ أول مجموعة للبدء';

  @override
  String get newGroupFab => 'مجموعة جديدة';

  @override
  String membersCountLine(int count, String currency) {
    return '$count عضو • $currency';
  }

  @override
  String get createGroupTitle => 'إنشاء مجموعة';

  @override
  String get groupNameLabel => 'اسم المجموعة';

  @override
  String get groupNameHint => 'مثال: رحلة نهاية الأسبوع';

  @override
  String get valGroupNameRequired => 'اسم المجموعة مطلوب';

  @override
  String get valGroupNameTooLong => 'اسم المجموعة طويل جدا';

  @override
  String get currencyLabel => 'العملة';

  @override
  String get createGroupBtn => 'إنشاء المجموعة';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';

  @override
  String get notifEmptyTitle => 'لا توجد إشعارات';

  @override
  String get notifEmptySub => 'لا يوجد جديد حاليا';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get timeNow => 'الآن';

  @override
  String timeMinutesAgo(int count) {
    return 'قبل $count دقيقة';
  }

  @override
  String timeHoursAgo(int count) {
    return 'قبل $count ساعة';
  }

  @override
  String timeDaysAgo(int count) {
    return 'قبل $count يوم';
  }

  @override
  String timeDate(int day, int month, int year) {
    return '$day/$month/$year';
  }

  @override
  String get privacyScreenTitle => 'سياسة الخصوصية';

  @override
  String privacyUpdated(int year) {
    return 'آخر تحديث: $year';
  }

  @override
  String get privacyS1t => '1. مقدمة';

  @override
  String get privacyS1b =>
      'نلتزم بحماية خصوصيتك. توضح هذه السياسة كيفية جمع واستخدام ومشاركة المعلومات عند استخدام التطبيق (إدارة المجموعات والمعاملات والأرصدة والإشعارات). باستخدامك للتطبيق فإنك توافق على هذه السياسة.';

  @override
  String get privacyS2t => '2. البيانات التي نجمعها';

  @override
  String get privacyS2b =>
      '• معلومات الحساب: الاسم، رقم الهاتف أو البريد، وبيانات تسجيل الدخول عبر مزودي الهوية (مثل Google) عند تفعيلهم.\n• بيانات المجموعات والمعاملات: المبالغ، الأطراف، الحالات، والملاحظات التي تُدخلها داخل المجموعات.\n• بيانات الجهاز والاستخدام: معرفات تقنية ضرورية لتشغيل الخدمة (مثل معرف المستخدم في النظام الخلفي).\n• الإشعارات: محتوى الإشعارات المتعلقة بالمعاملات والموافقات والتسويات.';

  @override
  String get privacyS3t => '3. أساس الاستخدام';

  @override
  String get privacyS3b =>
      'نستخدم البيانات لتشغيل التطبيق، وعرض الأرصدة والمعاملات، وإرسال الإشعارات للمستخدمين المعنيين، وتحسين الأمان والاستقرار، والامتثال للالتزامات القانونية عند الاقتضاء.';

  @override
  String get privacyS4t => '4. المشاركة مع أطراف ثالثة';

  @override
  String get privacyS4b =>
      'قد نعتمد على مزودي خدمات (مثل استضافة البيانات والمصادقة والإشعارات) لمعالجة البيانات نيابةً عنا وفق عقودهم وسياساتهم. لا نبيع بياناتك الشخصية لأطراف ثالثة لأغراض تسويقية.';

  @override
  String get privacyS5t => '5. التخزين والأمان';

  @override
  String get privacyS5b =>
      'نتخذ تدابير تقنية وتنظيمية معقولة لحماية البيانات. لا يوجد نظام آمن بنسبة 100٪؛ يرجى استخدام كلمة مرور قوية وعدم مشاركة حسابك.';

  @override
  String get privacyS6t => '6. الاحتفاظ بالبيانات';

  @override
  String get privacyS6b =>
      'نحتفظ بالبيانات طالما كان حسابك نشطًا أو حسب الحاجة لتقديم الخدمة والالتزامات القانونية. يمكنك طلب حذف الحساب وفق إمكانيات التطبيق والقانون المعمول به.';

  @override
  String get privacyS7t => '7. حقوقك';

  @override
  String get privacyS7b =>
      'حسب القانون المعمول ببلدك، قد يحق لك الوصول إلى بياناتك أو تصحيحها أو حذفها أو تقييد المعالجة. تواصل معنا عبر قنوات الدعم الرسمية للتطبيق.';

  @override
  String get privacyS8t => '8. التحديثات';

  @override
  String get privacyS8b =>
      'قد نعدّل هذه السياسة من وقت لآخر. سيتم إشعارك بشكل معقول عند التغييرات الجوهرية عندما يقتضي القانون أو التطبيق ذلك.';

  @override
  String get privacyS9t => '9. التواصل';

  @override
  String get privacyS9b =>
      'للاستفسارات المتعلقة بالخصوصية، يرجى التواصل عبر وسيلة الدعم الرسمية المعلنة في التطبيق أو على صفحة المطوّر.';

  @override
  String routerNotFound(String error) {
    return 'الصفحة غير موجودة: $error';
  }

  @override
  String get invalidPhone => 'رقم الهاتف غير صالح';

  @override
  String get searchCountryHint => 'البحث عن دولة';

  @override
  String get mobileHint => 'رقم الجوال';

  @override
  String get txnNewTitle => 'معاملة جديدة';

  @override
  String get txnType => 'النوع';

  @override
  String get amountLabel => 'المبلغ';

  @override
  String get amountHint => '0.00';

  @override
  String get valAmountRequired => 'المبلغ مطلوب';

  @override
  String get valAmountInvalid => 'أدخل مبلغا صحيحا';

  @override
  String get amountNegativeHint =>
      'إذا كان المبلغ سالبا سيتم عكس الدائن والمدين تلقائيا';

  @override
  String get creditorLabel => 'الدائن (المقرض)';

  @override
  String get creditorHint => 'الدائن الحالي';

  @override
  String get debtorLabel => 'المدين (المقترض)';

  @override
  String get debtorHint => 'اختر المدين';

  @override
  String get noteLabel => 'ملاحظة (اختياري)';

  @override
  String get noteHint => 'ملاحظة عن سبب المعاملة';

  @override
  String get createTxnBtn => 'إنشاء المعاملة';

  @override
  String get me => 'أنا';

  @override
  String txnError(String e) {
    return 'خطأ: $e';
  }

  @override
  String get pickDebtorSnack => 'يرجى اختيار المدين';

  @override
  String get selfDebtorSnack => 'لا يمكن اختيار نفسك كمدين';

  @override
  String get noteTooLongSnack => 'النص طويل جدا، الحد الأقصى للملاحظة 250 حرف';

  @override
  String get txnDetailTitle => 'تفاصيل المعاملة';

  @override
  String get labelCreditor => 'الدائن';

  @override
  String get labelDebtor => 'المدين';

  @override
  String get labelNote => 'الملاحظة';

  @override
  String get labelCreatedAt => 'تاريخ الإنشاء';

  @override
  String get labelApprovedAt => 'تاريخ الموافقة';

  @override
  String get labelRejectedAt => 'تاريخ الرفض';

  @override
  String get approve => 'موافقة';

  @override
  String get reject => 'رفض';

  @override
  String get debtorOnlyActions => 'الموافقة أو الرفض متاح للمدين فقط';

  @override
  String get roleOwner => 'المالك';

  @override
  String get roleAdmin => 'مشرف';

  @override
  String get roleMember => 'عضو';

  @override
  String get statusApproved => 'موافق';

  @override
  String get statusRejected => 'مرفوض';

  @override
  String get statusPending => 'معلّق';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get typeLoan => 'قرض';

  @override
  String get typeRepayment => 'سداد';

  @override
  String get typeCorrection => 'تصحيح';

  @override
  String get gdTabBalances => 'الأرصدة';

  @override
  String get gdTabTransactions => 'المعاملات';

  @override
  String get gdTabAnalysis => 'التحليل';

  @override
  String get gdTabMembers => 'الأعضاء';

  @override
  String gdMembersCount(int count) {
    return '$count عضو';
  }

  @override
  String get gdSnackTxAdded => 'تمت إضافة المعاملة بنجاح';

  @override
  String get gdMyBalance => 'رصيدي';

  @override
  String get gdAllBalances => 'رصيد كل الأعضاء';

  @override
  String get gdYourBalanceTitle => 'رصيدك الحالي';

  @override
  String get gdYourBalanceSubtitle =>
      'ملخص واضح لرصيدك الحالي داخل هذه المجموعة';

  @override
  String get gdOwedToYou => 'لك على الناس';

  @override
  String get gdYouOweOthers => 'عليك للناس';

  @override
  String get gdNet => 'الصافي';

  @override
  String get gdBalancesSection => 'الأرصدة';

  @override
  String get gdNoBalances => 'لا توجد أرصدة متاحة حاليا.';

  @override
  String get gdReceivableGroup => 'له على المجموعة';

  @override
  String get gdPayableGroup => 'عليه للمجموعة';

  @override
  String get gdBalanced => 'رصيد متوازن';

  @override
  String gdSettlementMember(String name) {
    return 'تسوية العضو • $name';
  }

  @override
  String gdOwesTo(String name) {
    return 'عليه لـ $name';
  }

  @override
  String gdOwedBy(String name) {
    return 'له على $name';
  }

  @override
  String get gdNoOpenSettlements => 'لا توجد تسويات مفتوحة لهذا العضو.';

  @override
  String get gdSummary => 'الملخص';

  @override
  String gdTotalReceivable(String amount, String currency) {
    return 'إجمالي له: $amount $currency';
  }

  @override
  String gdTotalPayable(String amount, String currency) {
    return 'إجمالي عليه: $amount $currency';
  }

  @override
  String gdNetLine(String sign, String amount, String currency) {
    return 'الصافي: $sign$amount $currency';
  }

  @override
  String get gdProposalExpired => 'انتهت صلاحية الاقتراح — يمكن إعادة الاكتشاف';

  @override
  String gdProposalLeftH(int h, int m) {
    return 'متبقي: $h ساعة و $m دقيقة';
  }

  @override
  String gdProposalLeftM(int m) {
    return 'متبقي: $m دقيقة';
  }

  @override
  String get voteApproved => 'موافق';

  @override
  String get voteRejected => 'رافض';

  @override
  String get votePending => 'معلّق';

  @override
  String get gdCircularTitle => 'اقتراح تصفية الديون الدائرية';

  @override
  String gdDiscoverySome(int count) {
    return 'تم إنشاء $count اقتراح/اقتراحات تسوية (صلاحية 12 ساعة)';
  }

  @override
  String get gdDiscoveryNone => 'لا توجد حلقات جديدة للتسوية حاليا';

  @override
  String get gdDiscover => 'اكتشاف';

  @override
  String get gdSettlementHelp =>
      'أي عضو يمكنه البحث عن حلقة ديون وإنشاء اقتراح. الاقتراح يظهر لجميع الأعضاء وينتهي تلقائياً بعد 12 ساعة إن لم يكتمل التصويت.';

  @override
  String gdProposalLine(String amount, String currency) {
    return 'اقتراح تسوية • $amount $currency';
  }

  @override
  String get gdReadOnlyVote => 'للاطلاع فقط — التصويت للأطراف المعنية بالحلقة';

  @override
  String get gdReject => 'رفض';

  @override
  String get gdApprove => 'موافقة';

  @override
  String get gdAnalysisNoTx =>
      'لا توجد معاملات معتمدة للتحليل الشهري (أو لا تظهر لصلاحياتك الحالية)';

  @override
  String gdTxCountMonth(int count) {
    return '$count معاملات';
  }

  @override
  String get gdMonthlyTotal => 'إجمالي الشهر';

  @override
  String get gdYouReceived => 'لك';

  @override
  String get gdYouPaid => 'عليك';

  @override
  String get gdNewMember => 'عضو جديد';

  @override
  String get gdNoMembers => 'لا يوجد أعضاء';

  @override
  String get gdAddMemberTitle => 'إضافة عضو جديد';

  @override
  String get gdMemberNameHint => 'اسم العضو';

  @override
  String get gdPhoneHint => 'رقم الهاتف';

  @override
  String get gdCancel => 'إلغاء';

  @override
  String get gdAdd => 'إضافة';

  @override
  String get gdValMemberNameRequired => 'اسم العضو مطلوب';

  @override
  String get gdValMemberNameTooLong => 'اسم العضو طويل جدا';

  @override
  String get gdValPhoneTooLong => 'رقم الهاتف طويل جدا';

  @override
  String get gdValPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get gdMemberAddedOk => 'تمت إضافة العضو بنجاح';

  @override
  String get gdFilterUser => 'تصفية حسب المستخدم';

  @override
  String get gdAllUsers => 'كل المستخدمين';

  @override
  String get gdNoTx => 'لا توجد معاملات بعد';

  @override
  String get gdNoTxUser => 'لا توجد معاملات لهذا المستخدم';

  @override
  String get gdNoTxYou => 'لا توجد معاملات تخصك حاليا';

  @override
  String get gdAutoSettlement => 'تسوية تلقائية';

  @override
  String get gdSettlementTitle => 'تسوية';
}
