import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/jouets/jouet_models.dart';
import 'package:tolon/models/avis/avis_model.dart';
import 'package:tolon/repository/avis/avis_repository.dart';

class RedigerAvisPage extends StatefulWidget {
  final JouetModel jouet;
  final AvisModel? avisExistant; // null = nouveau, sinon = modification

  const RedigerAvisPage({
    super.key,
    required this.jouet,
    this.avisExistant,
  });

  @override
  State<RedigerAvisPage> createState() => _RedigerAvisPageState();
}

class _RedigerAvisPageState extends State<RedigerAvisPage> {
  final TextEditingController _commentaireController = TextEditingController();
  final AvisRepository _avisRepository = AvisRepository();

  int _note = 0;
  bool _isLoading = false;

  bool get _isEdition => widget.avisExistant != null;

  @override
  void initState() {
    super.initState();
    if (_isEdition) {
      _note = widget.avisExistant!.note;
      _commentaireController.text = widget.avisExistant!.commentaire;
    }
  }

  @override
  void dispose() {
    _commentaireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        backgroundColor: AppStyles.bgColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppStyles.textDark,
          ),
        ),
        title: Text(
          _isEdition ? 'Modifier mon avis' : 'Rédiger un avis',
          style: AppStyles.titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== JOUET ==========
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppStyles.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: widget.jouet.image.isNotEmpty
                        ? Image.network(
                            widget.jouet.image.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(Icons.toys, color: Colors.grey),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.jouet.nomJouet,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppStyles.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isEdition
                              ? 'Modifiez votre avis'
                              : 'Partagez votre expérience',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppStyles.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ========== NOTE ==========
            Text(
              'Quelle note donnez-vous à ce jouet ?',
              style: AppStyles.headingTextStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Touchez les étoiles pour noter',
              style: TextStyle(
                fontSize: 13,
                color: AppStyles.textMuted,
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _note = index + 1;
                      });
                    },
                    icon: Icon(
                      index < _note ? Icons.star : Icons.star_border,
                      size: 42,
                      color: const Color(0xFFFFC400),
                    ),
                  );
                }),
              ),
            ),
            Center(
              child: Text(
                _note == 0 ? 'Choisissez une note' : '$_note / 5',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _note == 0 ? AppStyles.textMuted : AppStyles.textDark,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ========== COMMENTAIRE ==========
            Text(
              'Votre commentaire',
              style: AppStyles.headingTextStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _commentaireController,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Partagez votre expérience avec ce jouet...',
                hintStyle: TextStyle(color: AppStyles.textMuted),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 24),

            // ========== BOUTON ==========
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _publierAvis,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        _isEdition ? Icons.check : Icons.send_outlined,
                      ),
                label: Text(
                  _isLoading
                      ? (_isEdition ? 'Modification...' : 'Publication...')
                      : (_isEdition ? 'Enregistrer les modifications' : 'Publier mon avis'),
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

  Future<void> _publierAvis() async {
    final commentaire = _commentaireController.text.trim();

    if (_note == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une note (étoiles).'),
        ),
      );
      return;
    }

    if (commentaire.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez écrire un commentaire.'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous devez être connecté pour publier un avis.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isEdition) {
        final avisModifie = AvisModel(
          id: widget.avisExistant!.id,
          userId: user.uid,
          note: _note,
          commentaire: commentaire,
          date: widget.avisExistant!.date, // on garde la date d'origine
        );

        await _avisRepository.modifierAvis(
          jouetId: widget.jouet.id,
          avis: avisModifie,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Votre avis a été modifié avec succès !')),
        );
      } else {
        final avis = AvisModel(
          id: '',
          userId: user.uid,
          note: _note,
          commentaire: commentaire,
          date: DateTime.now(),
        );

        await _avisRepository.ajouterAvis(
          jouetId: widget.jouet.id,
          avis: avis,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Votre avis a été publié avec succès !')),
        );
      }

      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
