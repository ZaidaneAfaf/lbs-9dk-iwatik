import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client_model.dart';

class ClientRegisterController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<void> registerClient({
    required ClientModel model,
    required String password,
    required File imageFile,
  }) async {
    try {
      // 1. Créer compte Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: model.email.trim(),
        password: password.trim(),
      );

      final userId = userCredential.user?.uid;
      if (userId == null) throw Exception('Erreur lors de la création du compte.');

      // 2. Upload de l’image dans Firebase Storage
      final imageRef = _storage.ref().child(
        'clients/images/${DateTime.now().millisecondsSinceEpoch}_${model.firstName}.jpg',
      );
      final uploadTask = await imageRef.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      // 3. Créer l'objet avec l'URL de l'image
      final clientToSave = ClientModel(
        firstName: model.firstName,
        lastName: model.lastName,
        email: model.email,
        address: model.address,
        phone: model.phone,
        nationality: model.nationality,
        sex: model.sex,
        dateOfBirth: model.dateOfBirth,
        imageUrl: imageUrl,
        status: true, // valeur par défaut
      );

      // 4. Enregistrer dans Firestore
      await _firestore.collection('clients').doc(userId).set(clientToSave.toMap());

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Un compte existe déjà avec cet email');
      } else if (e.code == 'weak-password') {
        throw Exception('Mot de passe trop faible');
      } else {
        throw Exception('Erreur : ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la création du compte : $e');
    }
  }
}
