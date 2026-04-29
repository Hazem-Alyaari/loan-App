import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/core/theme/app_theme.dart';
import 'package:loan/core/widgets/gradient_button.dart';
import 'package:loan/features/groups/application/providers/group_providers.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _currency = 'YER';
  final _currencies = ['YER', 'USD', 'SAR'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(groupControllerProvider);
    final isLoading = controllerState is AsyncLoading;

    ref.listen<AsyncValue<void>>(groupControllerProvider, (_, state) {
      if (state is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء مجموعة'),
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group avatar
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: AppColors.cardGradient,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.group_add_rounded,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Name
                Text(
                  'اسم المجموعة',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'مثال: رحلة نهاية الأسبوع',
                    prefixIcon: Icon(Icons.edit_outlined,
                        color: AppColors.textHint),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'اسم المجموعة مطلوب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Currency
                Text(
                  'العملة',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF333355)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _currency,
                      isExpanded: true,
                      dropdownColor: AppColors.surfaceLight,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textHint),
                      items: _currencies
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _currency = v);
                      },
                    ),
                  ),
                ),

                const Spacer(),

                GradientButton(
                  text: 'إنشاء المجموعة',
                  icon: Icons.add_rounded,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _handleCreate,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    final group = await ref.read(groupControllerProvider.notifier).createGroup(
          name: _nameController.text.trim(),
          currencyCode: _currency,
        );

    if (group != null && mounted) {
      context.go('/groups/${group.id}');
    }
  }
}
