import 'package:flutter/material.dart';

class BeneficesJouet extends StatelessWidget {
  final List<TextEditingController> controllers;
  final VoidCallback ajouterBenefice;
  final Function(int) supprimerBenefice;

  const BeneficesJouet({
    super.key,
    required this.controllers,
    required this.ajouterBenefice,
    required this.supprimerBenefice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bénéfices / Avantages',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            IconButton(
              onPressed: ajouterBenefice,
              icon: Icon(Icons.add_circle),
            ),
          ],
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),

          itemCount: controllers.length,

          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controllers[index],

                      decoration: InputDecoration(
                        labelText: 'Bénéfice ${index + 1}',

                        border: const OutlineInputBorder(),
                      ),

                      validator: (value) {
                        if (index == 0 &&
                            (value == null || value.trim().isEmpty)) {
                          return 'Entrez un bénéfice';
                        }

                        return null;
                      },
                    ),
                  ),

                  if (controllers.length > 1)
                    IconButton(
                      onPressed: () {
                        supprimerBenefice(index);
                      },

                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
