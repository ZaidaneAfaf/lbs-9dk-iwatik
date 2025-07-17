import 'package:flutter/material.dart'; // Ajout nécessaire
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../models/model_model.dart';

class ModelController extends ChangeNotifier { // <= ici
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference get _modelsCollection {
    if (_currentUser == null) {
      throw Exception('Utilisateur non connecté');
    }
    return _firestore
        .collection('couturiers')
        .doc(_currentUser!.uid)
        .collection('models');
  }

  // Ajouter un nouveau modèle
  Future<void> addModel(CouturierModel model, File imageFile) async {
    try {
      // Upload de l'image
      final imageUrl = await _uploadImage(imageFile);

      // Ajouter le modèle avec l'URL de l'image
      await _modelsCollection.add(model.toMap()..['imageUrl'] = imageUrl);
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du modèle: ${e.toString()}');
    }
  }

  // Mettre à jour un modèle
  Future<void> updateModel(CouturierModel model, {File? newImageFile}) async {
    try {
      String imageUrl = model.imageUrl;
      
      // Si une nouvelle image est fournie, la télécharger
      if (newImageFile != null) {
        imageUrl = await _uploadImage(newImageFile);
      }

      await _modelsCollection.doc(model.id).update({
        'name': model.name,
        'description': model.description,
        'price': model.price,
        'category': model.category,
        'imageUrl': imageUrl,
        'isAvailable': model.isAvailable,
      });
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour: ${e.toString()}');
    }
  }

  // Supprimer un modèle
  Future<void> deleteModel(String modelId, String imageUrl) async {
    try {
      // Supprimer l'image du storage
      await _deleteImage(imageUrl);
      
      // Supprimer le document
      await _modelsCollection.doc(modelId).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression: ${e.toString()}');
    }
  }

  // Récupérer tous les modèles du couturier
  Stream<List<CouturierModel>> getModels() {
    return _modelsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CouturierModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Récupérer un modèle spécifique
  Future<CouturierModel> getModel(String modelId) async {
    final doc = await _modelsCollection.doc(modelId).get();
    if (!doc.exists) {
      throw Exception('Modèle non trouvé');
    }
    return CouturierModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  // Uploader une image
  Future<String> _uploadImage(File imageFile) async {
    try {
      final ref = _storage.ref().child(
          'couturiers/${_currentUser!.uid}/models/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Erreur lors de l\'upload de l\'image: ${e.toString()}');
    }
  }

  // Supprimer une image
  Future<void> _deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'image: ${e.toString()}');
    }
  }
}