import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/couturierModel.dart';

class CouturierRegisterController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Vérifie que le mot de passe contient au moins :
  /// - 8 caractères
  /// - une majuscule
  /// - un chiffre
  static bool isPasswordValid(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  /// Crée un compte couturier :
  /// - crée un compte dans Firebase Auth
  /// - upload image et certificat dans Storage
  /// - enregistre les infos dans Firestore (sans le mot de passe)
  /// - déconnecte immédiatement l’utilisateur
  static Future<void> registerCouturier(
    CouturierModel model,
    File imageFile,
    File certificateFile,
  ) async {
    try {
      // Vérification du mot de passe
      if (!isPasswordValid(model.password)) {
        throw Exception('Le mot de passe doit contenir 8 caractères, une majuscule et un chiffre');
      }

      // Création de l'utilisateur dans Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: model.email.trim(),
        password: model.password.trim(),
      );

      final userId = userCredential.user?.uid;
      if (userId == null) throw Exception('Erreur lors de la création de l\'utilisateur');

      // Upload de l’image
      final imageUrl = await _uploadFile(
        file: imageFile,
        path: 'couturiers/images/$userId-${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // Upload du certificat
      final certUrl = await _uploadFile(
        file: certificateFile,
        path: 'couturiers/certificates/$userId-${DateTime.now().millisecondsSinceEpoch}.${certificateFile.path.split('.').last}',
      );

      // Préparer la map sans le mot de passe
      final dataToSave = {
        ...model.toMap(),
        'imageUrl': imageUrl,
        'certificateUrl': certUrl,
        'status': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Retirer le champ password avant sauvegarde
      dataToSave.remove('password');

      // Enregistrement dans Firestore
      await _firestore.collection('couturiers').doc(userId).set(dataToSave);

      // Déconnexion immédiate (pour ne pas rester connecté)
      await _auth.signOut();

    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception('Erreur d\'inscription : ${e.toString()}');
    }
  }

  /// Upload de fichier vers Firebase Storage
  static Future<String> _uploadFile({
    required File file,
    required String path,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Erreur d\'upload : ${e.toString()}');
    }
  }

  /// Gestion des erreurs Firebase Auth
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'weak-password':
        return 'Mot de passe trop faible';
      case 'invalid-email':
        return 'Email invalide';
      default:
        return 'Erreur Firebase : ${e.message}';
    }
  }

  /// Vérifie si un couturier est activé (`status == true`)
  static Future<bool> isCouturierActive(String userId) async {
    final doc = await _firestore.collection('couturiers').doc(userId).get();
    return doc.exists ? (doc.data()?['status'] ?? false) : false;
  }
}
