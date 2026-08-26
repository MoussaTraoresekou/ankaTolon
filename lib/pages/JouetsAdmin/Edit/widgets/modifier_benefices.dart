import 'package:flutter/material.dart';

class ModifierBenefices extends StatelessWidget {

  final List<TextEditingController> controllers;

  final VoidCallback ajouterBenefice;

  final Function(int) supprimerBenefice;

  const ModifierBenefices({
    super.key,
    required this.controllers,
    required this.ajouterBenefice,
    required this.supprimerBenefice,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Row(

          children: [

            const Text(
              'Bénéfices',

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            // PETIT PLUS À DROITE

            IconButton(

              onPressed:
              ajouterBenefice,

              padding:
              EdgeInsets.zero,

              constraints:
              const BoxConstraints(),

              icon: const Icon(
                Icons.add,
                size: 20,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 8,
        ),


        for (
        int i = 0;
        i < controllers.length;
        i++
        )

          Padding(

            padding:
            const EdgeInsets.only(
              bottom: 8,
            ),

            child: Row(

              children: [



                Expanded(

                  child: TextFormField(

                    controller:
                    controllers[i],

                    decoration:
                    InputDecoration(

                      labelText:
                      'Bénéfice ${i + 1}',

                      border:
                      const OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                // supprimer un bénefice


                IconButton(

                  onPressed: () {

                    supprimerBenefice(i);

                  },

                  icon: const Icon(

                    Icons.delete_outline,

                    color:
                    Colors.red,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}