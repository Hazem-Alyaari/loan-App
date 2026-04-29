import 'package:cloud_firestore/cloud_firestore.dart';

/// Utility to generate unique Firestore document IDs without writing to the database.
class IdGenerator {
  static String generate() {
    return FirebaseFirestore.instance.collection('_').doc().id;
  }
}
