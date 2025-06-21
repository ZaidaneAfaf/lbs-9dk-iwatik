import 'package:firebase_auth/firebase_auth.dart';
class AppUser {
  final String? email;
  
  const AppUser(this.email);

  factory AppUser.fromFirebase(User? user) {
    return AppUser(user?.email);
  }
}