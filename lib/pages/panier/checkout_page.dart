import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controller/panier/panier_controller.dart';
import '../../controller/auth/auth_provider.dart';
import '../../repository/commande_repository/commande_repository.dart';
import '../../commun_widget/primary_button.dart';
import '../../cor/theme/app_theme.dart';
import '../../cor/utils/size_config.dart';

import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});
  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _nomController = TextEditingController();
  final _telController = TextEditingController();
  final _adresseController = TextEditingController();

  bool _isSubmitting = false;
  bool _isDataLoaded = false;

  final fraisLivraison = 1500.0;

  @override
  void dispose() {
    _nomController.dispose();
    _telController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (_nomController.text.isEmpty || _adresseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir les informations obligatoires"),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final panier = ref.read(panierProvider);
    final repo = ref.read(commandeRepositoryProvider);

    final double montantTotal = panier.total + fraisLivraison;
    final String adresseLivraison = _adresseController.text;

    try {
      await repo.createCommande(
        adresse: _adresseController.text,
        items: panier.items,
        montant: panier.total,
      );

      // On vérifie si le widget est toujours là après le chargement
      if (!mounted) return;

      ref.read(panierProvider.notifier).clear();
      context.pushReplacement(
        '/success',
        extra: {'montant': montantTotal, 'adresse': adresseLivraison},
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la commande")),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final panier = ref.watch(panierProvider);

    // Récupération des infos utilisateur depuis Firestore
    final userDocAsync = ref.watch(userDocProvider);

    userDocAsync.whenData((snapshot) {
      if (!_isDataLoaded && snapshot != null && snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          final nomFirestore = '${data['prenom'] ?? ''} ${data['nom'] ?? ''}'
              .trim();
          final telFirestore = data['phoneNumber'] ?? '';

          if (_nomController.text.isEmpty) _nomController.text = nomFirestore;
          if (_telController.text.isEmpty) _telController.text = telFirestore;

          setState(() {
            _isDataLoaded = true;
          });
        }
      }
    });

    void ouvrirSelecteurDeCarte() async {
      double initLat = 12.6392; // Bamako
      double initLong = -8.0029;

      try {
        final position = await LocationService.getCurrentPosition();
        initLat = position.latitude;
        initLong = position.longitude;
      } catch (e) {
        // Si la géolocalisation est refusée ou indisponible, on garde les coordonnées de secours
        debugPrint("Impossible de récupérer la position GPS actuelle : $e");
      }

      // Ensuite, on ouvre la page de la carte avec ces coordonnées initiales
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text("Choisir l'adresse de livraison"),
              backgroundColor: context.textInverse,
              foregroundColor: context.textDark,
              elevation: 0,
            ),
            body: FlutterLocationPicker.withConfiguration(
              userAgent: 'AnkaTolon/1.0.0 (seybayacoub@gmail.com)',

              initPosition: LatLong(initLat, initLong),

              onPicked: (pickedData) {
                setState(() {
                  _adresseController.text = pickedData.address;
                });
                Navigator.pop(context);
              },

              mapConfiguration: const MapConfiguration(
                initZoom: 15.0,
                stepZoom: 2.0,
                mapLanguage: 'fr',
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),

              searchConfiguration: const SearchConfiguration(
                maxSearchResults: 8,
                searchBarHintText: 'Rechercher un lieu...',
                searchbarDebounceDuration: Duration(milliseconds: 300),
              ),

              controlsConfiguration: ControlsConfiguration(
                zoomInIcon: Icons.add_circle_outline,
                zoomOutIcon: Icons.remove_circle_outline,
                locationIcon: Icons.my_location_rounded,
                locationButtonsColor: context.textInverse,
                locationButtonBackgroundColor: context.primary,
                zoomButtonsColor: context.textInverse,
                zoomButtonsBackgroundColor: context.primary,
                buttonElevation: 8.0,
                buttonShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              markerConfiguration: MarkerConfiguration(
                markerIcon: Icon(
                  Icons.location_pin,
                  color: context.badgeRed,
                  size: 50,
                ),
                animateMarker: true,
              ),

              selectButtonConfiguration: SelectButtonConfiguration(
                selectLocationButtonText: 'Confirmer cette position',
                selectLocationButtonStyle: ElevatedButton.styleFrom(
                  backgroundColor: context.primary,
                  foregroundColor: context.textInverse,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: const Text("Aperçu de commande"),
        backgroundColor: context.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: context.textDark),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // SECTION INFORMATIONS
              // ==========================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.textInverse,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.person_outline, "Nom", _nomController),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1, color: Color(0xFFF0F0F0)),
                    ),
                    _buildInfoRow(
                      Icons.phone_outlined,
                      "Téléphone",
                      _telController,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1, color: Color(0xFFF0F0F0)),
                    ),
                    // _buildInfoRow(
                    //   Icons.location_on_outlined,
                    //   "Lieu de livraison",
                    //   _adresseController,
                    //   hintText: "Entrez votre adresse de livraison",
                    //   showChevron: true, // Google Maps plus tard
                    // ),
                    GestureDetector(
                      onTap: ouvrirSelecteurDeCarte,
                      child: AbsorbPointer(
                        child: _buildInfoRow(
                          Icons.location_on_outlined,
                          "Lieu de livraison",
                          _adresseController,
                          hintText: "Appuyez pour choisir sur la carte",
                          showChevron: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // ==========================================
              // SECTION ARTICLES
              // ==========================================
              Text("Articles", style: context.headingTextStyle),
              SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: panier.items.length,
                itemBuilder: (context, index) {
                  final item = panier.items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.textInverse,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(item.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nomJouet,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.titleTextStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Quantité : ${item.quantite}",
                                style: context.normalTextStyle.copyWith(
                                  fontSize: 12,
                                  color: context.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${(item.prixUnitaire * item.quantite).toStringAsFixed(0)} FCFA",
                          style: context.titleTextStyle.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: SizeConfig.getProportionateHeight(16)),

              // ==========================================
              // SECTION TOTAUX
              // ==========================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.textInverse,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTotalRow("Sous-total", panier.total),
                    const SizedBox(height: 8),
                    _buildTotalRow("Frais de livraison", fraisLivraison),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Color(0xFFF0F0F0)),
                    ),
                    _buildTotalRow(
                      "Total",
                      panier.total + fraisLivraison,
                      isBold: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        margin: EdgeInsetsGeometry.only(bottom: 20),
        decoration: const BoxDecoration(
          // color: context.textInverse,
          // border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
        ),
        child: PrimaryButton(
          label: "Valider la commande",
          isLoading: _isSubmitting,
          onPressed: _submitOrder,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    TextEditingController controller, {
    String hintText = "Non renseigné",
    bool showChevron = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: context.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.normalTextStyle.copyWith(
                  fontSize: 11,
                  color: context.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: hintText,
                  hintStyle: TextStyle(color: context.textMuted, fontSize: 13),
                ),
                style: context.titleTextStyle.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
        if (showChevron) Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  Widget _buildTotalRow(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? context.headingTextStyle.copyWith(fontSize: 16)
              : context.normalTextStyle.copyWith(color: context.textMuted),
        ),
        Text(
          "${value.toStringAsFixed(0)} FCFA",
          style: isBold
              ? context.headingTextStyle.copyWith(
                  color: context.primary,
                  fontSize: 16,
                )
              : context.titleTextStyle.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
