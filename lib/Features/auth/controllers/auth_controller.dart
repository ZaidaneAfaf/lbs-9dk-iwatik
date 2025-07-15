import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user == null) {
        throw 'Utilisateur introuvable après authentification';
      }

      await _verifyCouturierStatus(user.uid);

      if (await isAdmin(user.uid)) {
        return 'admin';
      } else if (await isCouturier(user.uid)) {
        return 'couturier';
      } else {
        return 'client';
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> _verifyCouturierStatus(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('couturiers').doc(userId).get();
    if (doc.exists) {
      final bool isActivated = doc.data()?['status'] ?? false;
      if (!isActivated) {
        await _auth.signOut();
        throw 'Votre compte couturier est en attente de validation par l’administrateur.';
      }
    }
  }

  Future<bool> isAdmin(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('admins').doc(userId).get();
    return doc.exists;
  }

  Future<bool> isCouturier(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('couturiers').doc(userId).get();
    return doc.exists;
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Le mot de passe doit contenir au moins 6 caractères';
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet email';
      case 'user-not-found':
        return 'Aucun compte trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'invalid-email':
        return 'Email invalide';
      case 'user-disabled':
        return 'Ce compte a été désactivé';
      case 'too-many-requests':
        return 'Trop de tentatives. Veuillez réessayer plus tard';
      case 'operation-not-allowed':
        return 'Méthode d\'authentification non autorisée';
      default:
        return 'Erreur d\'authentification: ${e.message}';
    }
  }
}
