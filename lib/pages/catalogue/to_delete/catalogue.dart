
import 'package:demo/catalogue/produit_model.dart';
import 'package:flutter/material.dart';


class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {

  String selectedAge = 'Tous';

  String searchText = '';

  final List<Produit> produits = [
    Produit(
      nom: 'Tours colorés',
      age: '4-6 ans',
      note: 4.8,
      prix: 6000,
      image: 'assets/images/ville1.png',
    ),

    Produit(
      nom: 'Mémoire animaux',
      age: '7-9 ans',
      note: 4.8,
      prix: 10000,
      image: 'assets/images/ville2.png',
    ),

    Produit(
      nom: 'Découvertes',
      age: '10-12 ans',
      note: 4.8,
      prix: 6000,
      image: 'assets/images/ville3.png',
    ),

    Produit(
      nom: 'Children Alphabet Games',
      age: '4-6 ans',
      note: 4.8,
      prix: 10000,
      image: 'assets/images/ville2.png',
    ),

    Produit(
      nom: 'Tours colorés',
      age: '10-12 ans',
      note: 4.8,
      prix: 6000,
      image: 'assets/images/ville1.png',
    ),

    Produit(
      nom: 'Mémoire animaux',
      age: '7-9 ans',
      note: 4.8,
      prix: 10000,
      image: 'assets/images/ville3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Titre
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 18,
              ),
              child: Text(
                'Catalogue de jouets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF171717),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Recherche
            _buildSearchBar(),

            const SizedBox(height: 17),

            // Filtres
            _buildAgeFilters(),

            const SizedBox(height: 24),

            // Produits
            Expanded(
              child: _buildProductGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 36,

        child: TextField(
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },

          decoration: InputDecoration(
            hintText: 'Rechercher un jouet',
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF999999),
            ),

            prefixIcon: const Icon(
              Icons.search,
              size: 21,
              color: Colors.black,
            ),

            filled: true,
            fillColor: Colors.white,

            contentPadding: EdgeInsets.zero,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFD8D8D8),
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFD8D8D8),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF0AA361),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildProductGrid() {
    return GridView.builder(

      padding: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 0,
      ),

      itemCount: filteredProducts.length,

      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount: 2,

        crossAxisSpacing: 40,

        mainAxisSpacing: 28,

        childAspectRatio: 0.70,
      ),

      itemBuilder: (context, index) {

        final produit = filteredProducts[index];

        return _buildProductCard(produit);
      },
    );
  }



  Widget _buildAgeFilters() {
    final ages = [
      'Tous',
      '4-6 ans',
      '7-9 ans',
      '10-12 ans',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      padding: const EdgeInsets.symmetric(horizontal: 35),

      child: Row(
        children: ages.map((age) {

          final bool selected = selectedAge == age;

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedAge = age;
                });
              },

              child: Container(
                height: 33,

                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                ),

                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF0AA361)
                      : const Color(0xFFE0F0E5),

                  borderRadius: BorderRadius.circular(20),
                ),

                alignment: Alignment.center,

                child: Text(
                  age,

                  style: TextStyle(
                    fontSize: 11,

                    fontWeight: selected
                        ? FontWeight.w500
                        : FontWeight.w400,

                    color: selected
                        ? Colors.white
                        : const Color(0xFF222222),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Produit> get filteredProducts {
    return produits.where((produit) {

      final matchesAge =
          selectedAge == 'Tous' ||
              produit.age == selectedAge;

      final matchesSearch =
      produit.nom
          .toLowerCase()
          .contains(searchText.toLowerCase());

      return matchesAge && matchesSearch;

    }).toList();
  }



  Widget _buildProductCard(Produit produit) {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [

          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),

            child: AspectRatio(
              aspectRatio: 1,

              child: Image.asset(
                produit.image,

                fit: BoxFit.cover,

                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return Container(
                    color: const Color(0xFFEAF5ED),

                    child: const Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),

          // NOM
          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),

            child: Text(
              produit.nom,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // AGE
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 3,
            ),

            decoration: BoxDecoration(
              color: const Color(0xFFE5F2E8),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Text(
              produit.age,

              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF4B6A52),
              ),
            ),
          ),

          const SizedBox(height: 5),

          // NOTE + PRIX
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
            ),

            child: Row(
              children: [

                const Icon(
                  Icons.star,
                  color: Color(0xFFFFC400),
                  size: 18,
                ),

                const SizedBox(width: 2),

                Text(
                  produit.note.toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF777777),
                  ),
                ),

                const Spacer(),

                Text(
                  '${produit.prix} FCFA',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(width: 3),

                const Icon(
                  Icons.favorite,
                  color: Color(0xFFF04435),
                  size: 16,
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),
        ],
      ),
    );
  }




}