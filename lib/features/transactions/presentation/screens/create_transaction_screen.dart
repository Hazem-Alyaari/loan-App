import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  TransactionType _type = TransactionType.loan;
  String? _creditorId;
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

    ref.listen<AsyncValue<void>>(transactionControllerProvider, (_, state) {
      if (state is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
      if (state is AsyncData && state != const AsyncData<void>(null)) {
        context.pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction type selector
                    Text('Type',
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
                                  type.name[0].toUpperCase() +
                                      type.name.substring(1),
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
                    Text('Amount',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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
                        if (v == null || v.isEmpty) return 'Amount is required';
                        final amount = double.tryParse(v);
                        if (amount == null || amount <= 0) {
                          return 'Enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // Creditor
                    Text('Creditor (Lender)',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    _MemberDropdown(
                      members: members,
                      value: _creditorId,
                      hint: 'Select creditor',
                      onChanged: (v) => setState(() => _creditorId = v),
                    ),
                    const SizedBox(height: 28),

                    // Debtor
                    Text('Debtor (Borrower)',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    _MemberDropdown(
                      members: members,
                      value: _debtorId,
                      hint: 'Select debtor',
                      onChanged: (v) => setState(() => _debtorId = v),
                    ),
                    const SizedBox(height: 28),

                    // Note
                    Text('Note (optional)',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'What is this for?',
                        prefixIcon: Icon(Icons.notes_outlined,
                            color: AppColors.textHint),
                      ),
                    ),
                    const SizedBox(height: 40),

                    GradientButton(
                      text: 'Create Transaction',
                      icon: Icons.send_rounded,
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () => _handleCreate(
                                groupAsync.value?.currencyCode ?? 'USD'),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  void _handleCreate(String currency) {
    if (!_formKey.currentState!.validate()) return;
    if (_creditorId == null || _debtorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both creditor and debtor'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_creditorId == _debtorId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Creditor and debtor cannot be the same'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final members = ref.read(groupMembersProvider(widget.groupId)).value ?? [];
    final creditorMember = members.where((m) => m.userId == _creditorId).firstOrNull;
    final debtorMember = members.where((m) => m.userId == _debtorId).firstOrNull;

    final txId = DateTime.now().millisecondsSinceEpoch.toString();
    final transaction = TransactionModel(
      id: txId,
      groupId: widget.groupId,
      createdByUserId: user.uid,
      type: _type,
      status: TransactionStatus.pending,
      creditorUserId: _creditorId!,
      debtorUserId: _debtorId!,
      amount: double.parse(_amountController.text),
      currency: currency,
      note: _noteController.text.trim(),
      createdAt: DateTime.now(),
      creditorName: creditorMember?.userName,
      debtorName: debtorMember?.userName,
      createdByName: user.displayName,
    );

    ref
        .read(transactionControllerProvider.notifier)
        .createTransaction(transaction);
  }
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
