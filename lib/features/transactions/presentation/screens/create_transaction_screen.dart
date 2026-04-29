import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/core/theme/app_theme.dart';
import 'package:loan/core/widgets/gradient_button.dart';
import 'package:loan/features/auth/application/providers/auth_providers.dart';
import 'package:loan/features/groups/application/providers/group_providers.dart';
import 'package:loan/features/transactions/application/providers/transaction_providers.dart';
import 'package:loan/features/transactions/domain/models/transaction_model.dart';

class CreateTransactionScreen extends ConsumerStatefulWidget {
  final String groupId;
  const CreateTransactionScreen({super.key, required this.groupId});

  @override
  ConsumerState<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState
    extends ConsumerState<CreateTransactionScreen> {
  static const int _maxAmountLength = 16;
  static const int _maxNoteLength = 250;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  TransactionType _type = TransactionType.loan;
  String? _debtorId;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(groupMembersProvider(widget.groupId));
    final groupAsync = ref.watch(groupDetailProvider(widget.groupId));
    final controllerState = ref.watch(transactionControllerProvider);
    final isLoading = controllerState is AsyncLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('معاملة جديدة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
          ),
        ),
        child: membersAsync.when(
          data: (members) {
            final currentUser = ref.watch(authStateProvider).value;
            if (currentUser == null) {
              return const Center(
                child: Text(
                  'المستخدم غير مسجل الدخول',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }
            final currentMember =
                members.where((m) => m.userId == currentUser.uid).firstOrNull;
            final currentUserName =
                currentMember?.userName ?? currentUser.displayName ?? 'أنا';
            final selectableDebtors =
                members.where((m) => m.userId != currentUser.uid).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction type selector
                    Text('النوع',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    Row(
                      children: TransactionType.values.map((type) {
                        final isSelected = _type == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _type = type),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                        .withValues(alpha: 0.2)
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFF333355),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _transactionTypeLabel(type),
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),

                    // Amount
                    Text('المبلغ',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      maxLength: _maxAmountLength,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^-?\d*\.?\d*$'),
                        ),
                      ],
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: TextStyle(
                          color: AppColors.textHint.withValues(alpha: 0.5),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 16, right: 8),
                          child: Text(
                            '\$',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'المبلغ مطلوب';
                        final amount = double.tryParse(v);
                        if (amount == null || amount == 0) {
                          return 'أدخل مبلغا صحيحا';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'إذا كان المبلغ سالبا سيتم عكس الدائن والمدين تلقائيا',
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Creditor
                    Text('الدائن (المقرض)',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    TextFormField(
                      enabled: false,
                      initialValue: currentUserName,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'الدائن الحالي',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Debtor
                    Text('المدين (المقترض)',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    _MemberDropdown(
                      members: selectableDebtors,
                      value: _debtorId,
                      hint: 'اختر المدين',
                      onChanged: (v) => setState(() => _debtorId = v),
                    ),
                    const SizedBox(height: 28),

                    // Note
                    Text('ملاحظة (اختياري)',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      maxLength: _maxNoteLength,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_maxNoteLength),
                      ],
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'ملاحظة عن سبب المعاملة',
                        prefixIcon: Icon(Icons.notes_outlined,
                            color: AppColors.textHint),
                      ),
                    ),
                    const SizedBox(height: 40),

                    GradientButton(
                      text: 'إنشاء المعاملة',
                      icon: Icons.send_rounded,
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () async => _handleCreate(
                                groupAsync.value?.currencyCode ?? 'USD',
                                currentUser.uid,
                                currentUserName,
                                members,
                              ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(child: Text('خطأ: $e')),
        ),
      ),
    );
  }

  Future<void> _handleCreate(
    String currency,
    String currentUserId,
    String currentUserName,
    List members,
  ) async {
    if (!_formKey.currentState!.validate()) return;
    if (_debtorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار المدين'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_debtorId == currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن اختيار نفسك كمدين'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final selectedMember = members.where((m) => m.userId == _debtorId).firstOrNull;
    final selectedName = selectedMember?.userName ?? selectedMember?.userId ?? '';
    final rawAmount = double.parse(_amountController.text.trim());
    if (_noteController.text.trim().length > _maxNoteLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('النص طويل جدا، الحد الأقصى للملاحظة 250 حرف'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    final amount = rawAmount.abs();
    final isPositive = rawAmount > 0;
    final creditorId = isPositive ? currentUserId : _debtorId!;
    final debtorId = isPositive ? _debtorId! : currentUserId;
    final creditorName = isPositive ? currentUserName : selectedName;
    final debtorName = isPositive ? selectedName : currentUserName;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final txId = DateTime.now().millisecondsSinceEpoch.toString();
    final transaction = TransactionModel(
      id: txId,
      groupId: widget.groupId,
      createdByUserId: user.uid,
      type: _type,
      status: TransactionStatus.pending,
      creditorUserId: creditorId,
      debtorUserId: debtorId,
      amount: amount,
      currency: currency,
      note: _noteController.text.trim(),
      createdAt: DateTime.now(),
      creditorName: creditorName,
      debtorName: debtorName,
      createdByName: user.displayName,
    );

    await ref
        .read(transactionControllerProvider.notifier)
        .createTransaction(transaction);

    if (!mounted) return;
    final state = ref.read(transactionControllerProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error.toString()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.pop(true);
  }
}

String _transactionTypeLabel(TransactionType type) {
  return switch (type) {
    TransactionType.loan => 'قرض',
    TransactionType.repayment => 'سداد',
    TransactionType.correction => 'تصحيح',
  };
}

class _MemberDropdown extends StatelessWidget {
  final List members;
  final String? value;
  final String hint;
  final ValueChanged<String?> onChanged;

  const _MemberDropdown({
    required this.members,
    required this.value,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF333355)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.surfaceLight,
          hint: Text(hint,
              style: const TextStyle(color: AppColors.textHint)),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textHint),
          items: members.map<DropdownMenuItem<String>>((m) {
            return DropdownMenuItem(
              value: m.userId,
              child: Text(m.userName ?? m.userEmail ?? m.userId),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
