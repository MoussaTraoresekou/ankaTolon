import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/jouets/jouet_models.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tolon/models/avis/avis_model.dart';
import 'package:tolon/repository/avis/avis_repository.dart';

class RedigerAvisPage extends StatefulWidget {
  final JouetModel jouet;

  const RedigerAvisPage({
    super.key,
    required this.jouet,
  });

  @override
  State<RedigerAvisPage> createState() =>
      _RedigerAvisPageState();
}

class _RedigerAvisPageState
    extends State<RedigerAvisPage> {

  final TextEditingController
      _commentaireController =
      TextEditingController();

  final AvisRepository _avisRepository =
      AvisRepository();

  int _note = 0;

  bool _isLoading = false;

  @override
  void dispose() {
    _commentaireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,

       
      // APP BAR

      appBar: AppBar(
        backgroundColor: AppStyles.bgColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppStyles.textDark,
          ),
        ),

        title: const Text(
          'Rédiger un avis',
          style: AppStyles.titleTextStyle,
        ),
      ),

      
      // CONTENU
      

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           
            // JOUET
            

            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.05,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Row(
                children: [

                  // Image du jouet
                  Container(
                    width: 70,
                    height: 70,

                    decoration: BoxDecoration(
                      color: AppStyles.primarySoft,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),

                    clipBehavior: Clip.antiAlias,

                    child: widget.jouet.image.isNotEmpty
                        ? Image.network(
                            widget.jouet.image.first,
                            fit: BoxFit.cover,

                            errorBuilder:
                                (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              );
                            },
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                  ),

                  const SizedBox(width: 15),

                  // Nom du jouet
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          widget.jouet.nomJouet,

                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppStyles.textDark,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          '${widget.jouet.prix.toStringAsFixed(0)} FCFA',

                          style: const TextStyle(
                            color: AppStyles.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            
            // TITRE
            

            const Text(
              'Partagez votre expérience',
              style: AppStyles.headingTextStyle,
            ),

            const SizedBox(height: 8),

            const Text(
              'Votre avis aide les autres parents à faire '
              'leur choix et nous permet d’améliorer nos produits.',
              style: TextStyle(
                color: AppStyles.textMuted,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            
            // NOTE
          

            const Text(
              'Quelle note donnez-vous à ce jouet ?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppStyles.textDark,
              ),
            ),

            const SizedBox(height: 15),

            Center(
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: List.generate(
                  5,
                  (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          _note = index + 1;
                        });
                      },

                      icon: Icon(
                        index < _note
                            ? Icons.star
                            : Icons.star_border,

                        size: 42,

                        color: const Color(
                          0xFFFFC400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Center(
              child: Text(
                _note == 0 ? 'Choisissez une note' : '$_note / 5',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _note == 0
                      ? AppStyles.textMuted
                      : AppStyles.textDark,
                ),
              ),
            ),

            const SizedBox(height: 30),

            
            // COMMENTAIRE
            

            const Text(
              'Votre commentaire',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppStyles.textDark,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _commentaireController,

              maxLines: 7,

              maxLength: 500,

              textInputAction:
                  TextInputAction.newline,

              decoration: InputDecoration(
                hintText:
                    'Écrivez votre avis ici...',

                hintStyle: const TextStyle(
                  color: AppStyles.textMuted,
                ),

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),

                  borderSide: BorderSide.none,
                ),

                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),

                  borderSide: BorderSide.none,
                ),

                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),

                  borderSide: const BorderSide(
                    color: AppStyles.primary,
                    width: 1.5,
                  ),
                ),

                contentPadding:
                    const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 20),


            // BOUTON PUBLIER
            

            SizedBox(
  width: double.infinity,
  height: 52,

  child: ElevatedButton.icon(
    onPressed: _isLoading
        ? null
        : _publierAvis,

    icon: _isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : const Icon(
            Icons.send_outlined,
          ),

    label: Text(
      _isLoading
          ? 'Publication...'
          : 'Publier mon avis',

      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),

    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(230, 126, 34, 1),
      foregroundColor: Colors.white,
      disabledBackgroundColor:
          const Color.fromRGBO(230, 126, 34, 1).withValues(alpha: 0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  ),
),
          ],
        ),
      ),
    );
  }

  
  // PUBLIER
  

  Future<void> _publierAvis() async {
  final commentaire =
      _commentaireController.text.trim();

  
  // VÉRIFICATION DU COMMENTAIRE
  

  if (_note == 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Veuillez sélectionner une note (étoiles).',
        ),
      ),
    );
    return;
  }

  if (commentaire.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Veuillez écrire un commentaire.',
        ),
      ),
    );

    return;
  }

  
  // UTILISATEUR CONNECTÉ
  

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Vous devez être connecté pour publier un avis.',
        ),
      ),
    );

    return;
  }

  
  // ACTIVATION DU CHARGEMENT
  

  setState(() {
    _isLoading = true;
  });

  try {
    
    // CRÉATION DE L'AVIS
    

    final avis = AvisModel(
      id: '',
      userId: user.uid,
      note: _note,
      commentaire: commentaire,
      date: DateTime.now(),
    );

    
    // ENREGISTREMENT FIREBASE
    

    await _avisRepository.ajouterAvis(
      jouetId: widget.jouet.id,
      avis: avis,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Votre avis a été publié avec succès !',
        ),
      ),
    );

    // Retour vers la page du jouet
    context.pop();

  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Erreur lors de la publication : $e',
        ),
      ),
    );

  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
}