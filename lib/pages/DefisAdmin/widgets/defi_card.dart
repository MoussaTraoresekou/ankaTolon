import 'package:flutter/material.dart';

import 'package:tolon/models/defis/defi_model.dart';

class DefiCard extends StatelessWidget {

  final Defi defi;

  final VoidCallback onModifier;

  final VoidCallback onSupprimer;

  const DefiCard({
    super.key,
    required this.defi,
    required this.onModifier,
    required this.onSupprimer,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.only(
        bottom: 15,
      ),

      elevation: 2,

      color: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(10),
      ),

      child: Padding(

        padding: const EdgeInsets.all(18),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // =================================================
            // NOM DU DEFI
            // =================================================

            Text(

              defi.titre,

              style: const TextStyle(

                fontSize: 21,

                fontWeight:
                FontWeight.bold,

                color:
                Color(0xFF263746),
              ),
            ),

            const SizedBox(
              height: 9,
            ),

            // =================================================
            // DESCRIPTION
            // =================================================

            Text(

              defi.description,

              maxLines: 3,

              overflow:
              TextOverflow.ellipsis,

              style: TextStyle(

                fontSize: 15,

                color:
                Colors.grey.shade700,

                height: 1.5,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            // =================================================
            // INFORMATIONS
            // =================================================

            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),

              decoration: BoxDecoration(

                color:
                const Color(0xFFFAFFFB),

                borderRadius:
                BorderRadius.circular(8),

                border: Border.all(
                  color:
                  const Color(0xFFA8D5B5),
                ),
              ),

              child: Row(

                children: [

                  // =========================================
                  // AGE
                  // =========================================

                  Expanded(

                    child: _Information(

                      label: "Âge",

                      value:
                      "${defi.ageMin} - ${defi.ageMax} ans",
                    ),
                  ),

                  // =========================================
                  // ACTIVITES
                  // =========================================

                  Expanded(

                    child: _Information(

                      label:
                      "Activités",

                      value:
                      "${defi.activites.length}",
                    ),
                  ),

                  // =========================================
                  // QUIZ
                  // =========================================

                  Expanded(

                    child: _Information(

                      label:
                      "Quiz",

                      value:
                      "${defi.quiz.length}",
                    ),
                  ),

                  // =========================================
                  // DUREE
                  // =========================================

                  Expanded(

                    child: _Information(

                      label:
                      "Durée",

                      value:
                      "${defi.dureeValidite} h",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            // =================================================
            // SEPARATION
            // =================================================

            Divider(
              color:
              Colors.grey.shade300,
            ),

            const SizedBox(
              height: 5,
            ),

            // =================================================
            // BOUTONS
            // =================================================

            Row(

              mainAxisAlignment:
              MainAxisAlignment.end,

              children: [

                // =============================================
                // MODIFIER
                // =============================================

                TextButton(

                  onPressed:
                  onModifier,

                  child: const Text(

                    "Modifier",

                    style: TextStyle(

                      fontSize: 14,

                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 5,
                ),

                // =============================================
                // SUPPRIMER
                // =============================================

                TextButton(

                  onPressed:
                  onSupprimer,

                  child: const Text(

                    "Supprimer",

                    style: TextStyle(

                      color:
                      Colors.red,

                      fontSize: 14,

                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// =====================================================
// WIDGET POUR UNE INFORMATION
// =====================================================

class _Information
    extends StatelessWidget {

  final String label;

  final String value;

  const _Information({

    required this.label,

    required this.value,
  });

  @override
  Widget build(
      BuildContext context) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        // =================================================
        // LABEL
        // =================================================

        Text(

          label,

          style: TextStyle(

            fontSize: 13,

            color:
            Colors.grey.shade700,

            fontWeight:
            FontWeight.w600,
          ),
        ),

        const SizedBox(
          height: 5,
        ),

        // =================================================
        // VALEUR
        // =================================================

        Text(

          value,

          style: const TextStyle(

            fontSize: 16,

            fontWeight:
            FontWeight.bold,

            color:
            Color(0xFF263746),
          ),
        ),
      ],
    );
  }
}