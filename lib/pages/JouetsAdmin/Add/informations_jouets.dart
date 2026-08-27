import 'package:flutter/material.dart';

class InformationsJouet extends StatelessWidget {
  final TextEditingController nomController;
  final TextEditingController ageMinimumController;
  final TextEditingController ageMaximumController;
  final TextEditingController prixController;
  final TextEditingController stockController;
  final TextEditingController descriptionController;

  final String? categorieSelectionnee;
  final List<String> categories;
  final Function(String?) onCategorieChanged;

  const InformationsJouet({
    super.key,
    required this.nomController,
    required this.ageMinimumController,
    required this.ageMaximumController,
    required this.prixController,
    required this.stockController,
    required this.descriptionController,
    required this.categorieSelectionnee,
    required this.categories,
    required this.onCategorieChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: champTexte(
                  label: 'Nom du jouet',
                  controller: nomController,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Veuillez entrer le nom';
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Catégorie',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: categorieSelectionnee,
                      isExpanded: true,

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),

                      hint: const Text(
                        'Choisir',
                      ),

                      items: categories.map(
                            (categorie) {
                          return DropdownMenuItem<String>(
                            value: categorie,
                            child: Text(
                              categorie,
                              overflow:
                              TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ).toList(),

                      onChanged: onCategorieChanged,

                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Choisissez une catégorie';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: champTexte(
                  label: 'Age minimum',
                  controller: ageMinimumController,
                  type: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Entrez l’âge';
                    }

                    final int? age =
                    int.tryParse(value.trim());

                    if (age == null) {
                      return 'Nombre entier';
                    }

                    if (age < 4 || age > 12) {
                      return 'Entre 4 et 12 ans';
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: champTexte(
                  label: 'Age maximum',
                  controller: ageMaximumController,
                  type: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Entrez l’âge';
                    }

                    final int? age =
                    int.tryParse(value.trim());

                    if (age == null) {
                      return 'Nombre entier';
                    }

                    if (age < 4 || age > 12) {
                      return 'Entre 4 et 12 ans';
                    }

                    final int? ageMinimum =
                    int.tryParse(
                      ageMinimumController.text.trim(),
                    );

                    if (ageMinimum != null &&
                        ageMinimum > age) {
                      return 'Doit être ≥ âge min.';
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: champTexte(
                  label: 'Prix',
                  controller: prixController,
                  type: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Entrez le prix';
                    }

                    final double? prix =
                    double.tryParse(value.trim());

                    if (prix == null) {
                      return 'Nombre invalide';
                    }

                    if (prix < 0) {
                      return 'Prix invalide';
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: champTexte(
                  label: 'Stock',
                  controller: stockController,
                  type: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Entrez le stock';
                    }

                    final int? stock =
                    int.tryParse(value.trim());

                    if (stock == null) {
                      return 'Nombre entier';
                    }

                    if (stock < 0) {
                      return 'Stock invalide';
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          champTexte(
            label: 'Description',
            controller: descriptionController,
            maxLines: 3,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Veuillez entrer une description';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget champTexte({
    required String label,
    required TextEditingController controller,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          keyboardType: type,
          maxLines: maxLines,

          decoration: const InputDecoration(
            border: OutlineInputBorder(),

            enabledBorder: OutlineInputBorder(),

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green,
                width: 2,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),

          validator: validator,
        ),
      ],
    );
  }
}