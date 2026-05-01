import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:loan/core/theme/app_theme.dart';

/// حقل هاتف مع اختيار الدولة والتحقق من الطول حسب الدولة (intl_phone_field).
class InternationalPhoneFormField extends StatelessWidget {
  const InternationalPhoneFormField({
    super.key,
    required this.controller,
    this.onSaved,
    this.autovalidateMode,
    this.initialCountryCode = 'YE',
    this.languageCode = 'ar',
  });

  final TextEditingController controller;
  final FormFieldSetter<PhoneNumber>? onSaved;
  final AutovalidateMode? autovalidateMode;

  /// رمز ISO الافتراضي عند فتح الشاشة (الافتراضي: YE = +967، يمكن تغيير الدولة من القائمة).
  final String initialCountryCode;

  /// لأسماء الدول في مربع البحث (مثلاً ar / en).
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: IntlPhoneField(
        controller: controller,
        initialCountryCode: initialCountryCode,
        languageCode: languageCode,
        autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
        invalidNumberMessage: 'رقم الهاتف غير صالح',
        showDropdownIcon: true,
        dropdownIconPosition: IconPosition.trailing,
        style: const TextStyle(color: AppColors.textPrimary),
        dropdownTextStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 8),
        pickerDialogStyle: PickerDialogStyle(
          backgroundColor: AppColors.surface,
          countryNameStyle: const TextStyle(color: AppColors.textPrimary),
          countryCodeStyle: const TextStyle(color: AppColors.textSecondary),
          searchFieldInputDecoration: const InputDecoration(
            hintText: 'البحث عن دولة',
            hintStyle: TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surfaceLight,
          ),
          searchFieldCursorColor: AppColors.primary,
        ),
        decoration: const InputDecoration(
          hintText: 'رقم الجوال',
        ),
        onSaved: onSaved,
      ),
    );
  }
}
