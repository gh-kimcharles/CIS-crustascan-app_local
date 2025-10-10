import 'package:crustascan_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crustascan_app/providers/user_provider.dart';

class SpeciesContainer extends StatelessWidget {
  final String speciesId;
  final String imagePath;
  final String speciesName;
  final String speciesType;
  final String speciesDesc;
  final Widget speciesDescPage;

  const SpeciesContainer({
    super.key,
    required this.speciesId,
    required this.imagePath,
    required this.speciesName,
    required this.speciesType,
    required this.speciesDesc,
    required this.speciesDescPage,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => speciesDescPage),
        );
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Hero(
                    tag: speciesName,
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                if (authProvider.isUser)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        final isFav = userProvider.isFavorite(speciesId);
                        return Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 24,
                            color: isFav ? Colors.red : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: speciesType == 'Crab'
                          ? const Color.fromARGB(255, 253, 220, 220)
                          : speciesType == 'Shrimp'
                          ? const Color.fromARGB(255, 253, 243, 220)
                          : speciesType == 'Prawn'
                          ? const Color.fromARGB(255, 253, 243, 220)
                          : speciesType == 'Lobster'
                          ? const Color.fromARGB(255, 220, 230, 253)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      speciesType,
                      style: TextStyle(
                        color: speciesType == 'Crab'
                            ? const Color.fromARGB(255, 204, 77, 77)
                            : speciesType == 'Shrimp'
                            ? const Color.fromARGB(255, 230, 210, 0)
                            : speciesType == 'Prawn'
                            ? const Color.fromARGB(255, 228, 128, 29)
                            : speciesType == 'Lobster'
                            ? const Color.fromARGB(255, 29, 92, 228)
                            : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    speciesName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    speciesDesc,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
