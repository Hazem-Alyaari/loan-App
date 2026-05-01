import 'package:intl_phone_field/phone_number.dart';

/// National significant digits only (no country calling code), digits only.
///
/// Matches existing production data / Firebase synthetic emails like
/// `776137120@loantrack.local` instead of `967776137120@loantrack.local`.
/// See [AuthRepository._normalizePhone].
String phoneToStoredDigits(PhoneNumber phone) {
  final national = phone.number.replaceAll(RegExp(r'\D'), '');
  if (national.isNotEmpty) {
    return national;
  }
  return phone.completeNumber.replaceAll(RegExp(r'\D'), '');
}
