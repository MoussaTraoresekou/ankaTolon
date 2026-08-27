import 'package:cloud_firestore/cloud_firestore.dart';

class ActiviteModel {
    final  int  id;
    final  String titre;
    final  String   description;
    final  int  duree;
    final  DateTime? date_creation;
    final  DocumentReference? categorieId;
    final String image_Url; 
    final  int age_min;
    final  int age_max;
    final  String videoUrl;
    
    const ActiviteModel({required this.id,required this.titre,required this.description,required this.duree,required this.date_creation, required this.categorieId,required this.image_Url,required this.age_max,required this.age_min,required this.videoUrl,});

}