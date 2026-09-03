import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tolon/models/admin_model/tutoriel_model.dart';

part 'tutoriel_repository.g.dart';

class TutorielRepository {
  final FirebaseFirestore _firestore;
  final SupabaseClient _supabase = Supabase.instance.client;

  TutorielRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _tutoCollection =>
      _firestore.collection('tutoriel');

  // Flux en direct pour alimenter la liste
  Stream<List<TutorielModel>> watchTutoriels() {
    return _tutoCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TutorielModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  // Supprimer un tutoriel et son document de la base
  Future<void> supprimerTutoriel(String id) async {
    await _tutoCollection.doc(id).delete();
  }

  // MODIFIER un tuto :
  Future<void> modifierTutoriel({required TutorielModel tuto}) async {
    await _tutoCollection.doc(tuto.id).update(tuto.toJson());
  }

  // SUPABASE STORAGE + FIRESTORE : Logique de téléversement prête pour ton formulaire d'ajout
  Future<void> ajouterTutoriel({
    required TutorielModel tuto,
    required File videoFile,
    required File imageVideoFile,
  }) async {
    try {
      // Upload du fichier binaire dans ton bucket Supabase nommé 'videos_tutos'
      final String fileVideoName =
          '${DateTime.now().millisecondsSinceEpoch}_tuto.mp4';
      await _supabase.storage.from('Videos').upload(fileVideoName, videoFile);

      final String fileImageName =
          '${DateTime.now().millisecondsSinceEpoch}_ImageTuto.jpg';
      await _supabase.storage
          .from('Videos')
          .upload(fileImageName, imageVideoFile);

      // Récupération du lien d'accès public CDN
      final String publicUrlVideo = _supabase.storage
          .from('Videos')
          .getPublicUrl(fileVideoName);
      final String publicUrlImage = _supabase.storage
          .from('Videos')
          .getPublicUrl(fileImageName);

      // Enregistrement des métadonnées sur ton Firestore
      final newTuto = TutorielModel(
        id: '',
        titre: tuto.titre,
        description: tuto.description,
        ageMin: tuto.ageMin,
        ageMax: tuto.ageMax,
        dateCreation: DateTime.now(),
        videoUrl: publicUrlVideo, // Lien Supabase injecté !
        imageVideoUrl: publicUrlImage,
        categorieId: tuto.categorieId,
      );

      await _tutoCollection.add(newTuto.toJson());
    } catch (e) {
      debugPrint("Erreur d'ajout tutoriel : $e");
      rethrow;
    }
  }
}

@riverpod
TutorielRepository tutorielRepository(Ref ref) {
  return TutorielRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<TutorielModel>> watchTutoriels(Ref ref) {
  final repository = ref.watch(tutorielRepositoryProvider);
  return repository.watchTutoriels();
}
