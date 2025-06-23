import 'package:cloud_firestore/cloud_firestore.dart';
class AppUser {
  final String? uid;
  final String? email;
  final String? role;

  AppUser({this.uid, this.email, this.role});

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return AppUser(
      uid: doc.id,
      email: data['email'],
      role: data['role'],
    );
  }
}