/// Short bilingual strings for layers without [BuildContext] (repositories).
class Bilingual {
  Bilingual({required this.isArabic});

  final bool isArabic;

  String pick({required String ar, required String en}) => isArabic ? ar : en;

  // --- Auth repository ---
  String get userProfileNotFound =>
      pick(ar: 'لم يتم العثور على ملف المستخدم', en: 'User profile not found');
  String get phoneAlreadyRegistered =>
      pick(ar: 'رقم الهاتف مسجل بالفعل', en: 'This phone number is already registered');
  String get userNotSignedIn =>
      pick(ar: 'المستخدم غير مسجل الدخول', en: 'You are not signed in');
  String get passwordChangeNotSupported => pick(
        ar: 'الحساب الحالي لا يدعم تغيير كلمة المرور',
        en: 'This account does not support password change',
      );
  String get phoneRequired =>
      pick(ar: 'رقم الهاتف مطلوب', en: 'Phone number is required');
  String get genericUser => pick(ar: 'مستخدم', en: 'User');

  // --- Transaction repository (Firestore copy + errors) ---
  String get memberAddedPlaceholder =>
      pick(ar: 'أحد الأعضاء', en: 'A member');
  String pendingApprovalTitle() =>
      pick(ar: 'معاملة جديدة بانتظار موافقتك', en: 'New transaction awaiting your approval');
  String pendingApprovalMessage(String actor, String amount, String currency) =>
      pick(
        ar: 'قام $actor بإضافة معاملة بمبلغ $amount $currency.',
        en: '$actor added a transaction of $amount $currency.',
      );
  String get settlementProposalTitle =>
      pick(ar: 'اقتراح تصفية ديون', en: 'Debt settlement proposal');
  String settlementParticipantBody(String amount) => pick(
        ar: 'تم اكتشاف تسوية ممكنة بقيمة $amount. صلاحية الاقتراح 12 ساعة. راجع تبويب التحليل ووافق للتنفيذ.',
        en: 'A possible settlement of $amount was found. The proposal expires in 12 hours. Open the Analysis tab to review and approve.',
      );
  String settlementObserverBody() => pick(
        ar: 'تم إنشاء اقتراح تصفية ديون في المجموعة. يمكنك متابعته من تبويب التحليل (صلاحية 12 ساعة).',
        en: 'A debt settlement proposal was created. You can follow it in the Analysis tab (12-hour expiry).',
      );
  String get proposalNotFound =>
      pick(ar: 'الاقتراح غير موجود', en: 'Proposal not found');
  String get notAuthorizedToVote => pick(
        ar: 'غير مصرح لك بالتصويت على هذا الاقتراح',
        en: 'You are not allowed to vote on this proposal',
      );
  String get autoSettlementNote =>
      pick(ar: 'تسوية ديون تلقائية', en: 'Automatic debt settlement');
  String get systemName => pick(ar: 'النظام', en: 'System');
  String get settlementExecutedTitle =>
      pick(ar: 'تم تنفيذ التسوية بنجاح', en: 'Settlement completed');
  String settlementExecutedBody(String amount) => pick(
        ar: 'اكتملت الموافقات وتم تنفيذ تسوية بقيمة $amount.',
        en: 'All approvals are in; settlement of $amount was executed.',
      );
  String get transactionNotFound =>
      pick(ar: 'المعاملة غير موجودة', en: 'Transaction not found');
  String get approvedTitle =>
      pick(ar: 'تمت الموافقة على المعاملة', en: 'Transaction approved');
  String get rejectedTitle =>
      pick(ar: 'تم رفض المعاملة', en: 'Transaction rejected');
  String approvedBody(String debtor, String amount, String currency) => pick(
        ar: 'وافق $debtor على معاملتك بمبلغ $amount $currency.',
        en: '$debtor approved your transaction of $amount $currency.',
      );
  String rejectedBody(String debtor, String amount, String currency) => pick(
        ar: 'رفض $debtor معاملتك بمبلغ $amount $currency.',
        en: '$debtor rejected your transaction of $amount $currency.',
      );
  String get debtorFallback => pick(ar: 'المدين', en: 'Debtor');
  String get balanceUpdatedTitle =>
      pick(ar: 'تم تنفيذ العملية بنجاح', en: 'Operation completed');
  String balanceUpdatedBody(String amount, String currency) => pick(
        ar: 'تم اعتماد المعاملة وتحديث الرصيد تلقائيا بمبلغ $amount $currency.',
        en: 'The transaction was approved and the balance was updated by $amount $currency.',
      );
}
