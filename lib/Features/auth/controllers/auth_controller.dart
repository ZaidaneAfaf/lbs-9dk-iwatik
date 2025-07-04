import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Étape 1 : Authentification Firebase
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user == null) {
        throw 'Erreur : utilisateur introuvable après authentification';
      }

      // Étape 2 : Vérification spécifique pour les couturiers
      await _verifyCouturierStatus(user.uid);

    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> _verifyCouturierStatus(String userId) async {
    final couturierDoc = await FirebaseFirestore.instance
        .collection('couturiers')
        .doc(userId)
        .get();

    if (couturierDoc.exists) {
      final data = couturierDoc.data() as Map<String, dynamic>;
      final bool isActivated = data['status'] ?? false;

      if (!isActivated) {
        await _auth.signOut();
        throw 'Votre compte couturier est en attente de validation par l\'administrateur.';
      }
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<bool> isCouturier(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('couturiers')
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<bool> isCouturierActivated(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('couturiers')
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.get('status') ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
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