import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tolon/models/activites/activite_model.dart';
import 'package:tolon/models/categorie/categorie_model.dart';

part 'activite_repository.g.dart';

class ActiviteRepository {
  final FirebaseFirestore _firestore;
  final SupabaseClient _supabase;

  ActiviteRepository(this._firestore, this._supabase);

  CollectionReference<Map<String, dynamic>> get _activitesCollection =>
      _firestore.collection('activites');

  static const String _bucket = 'images';

  Future<List<ActiviteModel>> getActivites() async {
    final snapshot = await _activitesCollection.get();

    return snapshot.docs.map((doc) {
      return ActiviteModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

  Future<ActiviteModel?> getActiviteById(String id) async {
    final doc = await _activitesCollection.doc(id).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return ActiviteModel.fromJson(doc.data()!, doc.id);
  }

  Future<List<ActiviteModel>> getActivitesParCategorie(
    DocumentReference categorieRef,
  ) async {
    final snapshot = await _activitesCollection
        .where('categorie_id', isEqualTo: categorieRef)
        .get();

    return snapshot.docs.map((doc) {
      return ActiviteModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

  Future<String> _uploadImage(
    File image,
    String activiteId,
  ) async {
    final extension = image.path.split('.').last.toLowerCase();

    final filePath =
        'activites/$activiteId/image.$extension';

    String contentType;

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        contentType = 'image/jpeg';
        break;
      case 'png':
        contentType = 'image/png';
        break;
      case 'webp':
        contentType = 'image/webp';
        break;
      default:
        contentType = 'image/jpeg';
    }

    await _supabase.storage.from(_bucket).upload(
      filePath,
      image,
      fileOptions: FileOptions(
        upsert: true,
        contentType: contentType,
      ),
    );

    return _supabase.storage
        .from(_bucket)
        .getPublicUrl(filePath);
  }

  Future<String> _uploadVideo(
    File video,
    String activiteId,
  ) async {
    final extension = video.path.split('.').last.toLowerCase();

    final filePath =
        'videos/$activiteId/video.$extension';

    String contentType;

    switch (extension) {
      case 'mp4':
        contentType = 'video/mp4';
        break;
      case 'mov':
        contentType = 'video/quicktime';
        break;
      case 'webm':
        contentType = 'video/webm';
        break;
      default:
        contentType = 'video/mp4';
    }

    await _supabase.storage.from(_bucket).upload(
      filePath,
      video,
      fileOptions: FileOptions(
        upsert: true,
        contentType: contentType,
      ),
    );

    return _supabase.storage
        .from(_bucket)
        .getPublicUrl(filePath);
  }

  Future<ActiviteModel> ajouterActivite(
    ActiviteModel activite, {
    File? image,
    File? video,
  }) async {
    final doc = _activitesCollection.doc();

    String? imageUrl;
    String? videoUrl;

    if (image != null) {
      imageUrl = await _uploadImage(
        image,
        doc.id,
      );
    }

    if (video != null) {
      videoUrl = await _uploadVideo(
        video,
        doc.id,
      );
    }

    final nouvelleActivite = ActiviteModel(
      id: doc.id,
      titre: activite.titre,
      description: activite.description,
      categorieId: activite.categorieId,
      image: imageUrl,
      videoUrl: videoUrl,
      dureeMinutes: activite.dureeMinutes,
      ageMin: activite.ageMin,
      ageMax: activite.ageMax,
      dateCreation: activite.dateCreation,
    );

    await doc.set(
      nouvelleActivite.toJson(),
    );

    return nouvelleActivite;
  }

  Future<void> modifierActivite(
    ActiviteModel activite, {
    File? image,
    File? video,
  }) async {
    String? imageUrl = activite.image;
    String? videoUrl = activite.videoUrl;

    if (image != null) {
      imageUrl = await _uploadImage(
        image,
        activite.id,
      );
    }

    if (video != null) {
      videoUrl = await _uploadVideo(
        video,
        activite.id,
      );
    }

    final activiteModifiee = ActiviteModel(
      id: activite.id,
      titre: activite.titre,
      description: activite.description,
      categorieId: activite.categorieId,
      image: imageUrl,
      videoUrl: videoUrl,
      dureeMinutes: activite.dureeMinutes,
      ageMin: activite.ageMin,
      ageMax: activite.ageMax,
      dateCreation: activite.dateCreation,
    );

    await _activitesCollection
        .doc(activite.id)
        .update(
          activiteModifiee.toJson(),
        );
  }

  Future<void> supprimerActivite(
    String id,
  ) async {
    try {
      final files = await _supabase.storage
          .from(_bucket)
          .list(
            path: 'activites/$id',
          );

      if (files.isNotEmpty) {
        final paths = files
            .map(
              (file) =>
                  'activites/$id/${file.name}',
            )
            .toList();

        await _supabase.storage
            .from(_bucket)
            .remove(paths);
      }

      await _supabase.storage
          .from(_bucket)
          .remove([
        'activites/$id',
      ]);
    } catch (_) {}

    await _activitesCollection
        .doc(id)
        .delete();
  }

  Stream<List<ActiviteModel>> watchActivites() {
    return _activitesCollection
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ActiviteModel.fromJson(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }
  Stream<List<CategorieModel>> watchCategories() {
  return _firestore
      .collection('categories')
      .where('type', isEqualTo: 'activite')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return CategorieModel.fromJson(
        doc.data(),
        doc.id,
      );
    }).toList();
  });
}
}

@riverpod
ActiviteRepository activiteRepository(
  Ref ref,
) {
  return ActiviteRepository(
    FirebaseFirestore.instance,
    Supabase.instance.client,
  );
}

@riverpod
Future<List<ActiviteModel>> activites(
  Ref ref,
) async {
  final repository =
      ref.watch(activiteRepositoryProvider);

  return repository.getActivites();
}

@riverpod
Future<ActiviteModel?> activiteById(
  Ref ref,
  String id,
) async {
  final repository =
      ref.watch(activiteRepositoryProvider);

  return repository.getActiviteById(id);
}

@riverpod
Stream<List<ActiviteModel>> watchActivites(
  Ref ref,
) {
  final repository =
      ref.watch(activiteRepositoryProvider);

  return repository.watchActivites();
}
@riverpod
Stream<List<CategorieModel>> watchCategories(Ref ref) {
  final repository = ref.watch(activiteRepositoryProvider);

  return repository.watchCategories();
}