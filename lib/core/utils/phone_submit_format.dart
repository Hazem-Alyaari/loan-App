import 'package:intl_phone_field/phone_number.dart';

/// يحوّل رقم [PhoneNumber] إلى أرقام فقط (E.164 بدون +) ليتوافق مع [_normalizePhone] في المستودع.
String phoneToStoredDigits(PhoneNumber phone) {
  return phone.completeNumber.replaceAll(RegExp(r'\D'), '');
}
