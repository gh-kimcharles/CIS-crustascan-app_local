import 'package:crustascan_app/views/pages/home/species_description_page.dart';
import 'package:crustascan_app/models/crustacean_model.dart';
import 'package:flutter/material.dart';

class HistoryDescriptionContainer extends StatelessWidget {
  final Crustacean crustacean;
  final String name;
  final String type;
  final String scientificName;
  final String familyName;
  final String population;
  final String shortDescription;

  const HistoryDescriptionContainer({
    required this.crustacean,
    required this.name,
    required this.type,
    required this.scientificName,
    required this.familyName,
    required this.population,
    required this.shortDescription,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    // vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(top: 12, bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: type == 'Crab'
                                  ? const Color.fromARGB(255, 253, 220, 220)
                                  : type == 'Shrimp'
                                  ? const Color.fromARGB(255, 253, 243, 220)
                                  : type == 'Prawn'
                                  ? const Color.fromARGB(255, 253, 243, 220)
                                  : type == 'Lobster'
                                  ? const Color.fromARGB(255, 220, 230, 253)
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                color: type == 'Crab'
                                    ? const Color.fromARGB(255, 204, 77, 77)
                                    : type == 'Shrimp'
                                    ? const Color.fromARGB(255, 230, 210, 0)
                                    : type == 'Prawn'
                                    ? const Color.fromARGB(255, 228, 128, 29)
                                    : type == 'Lobster'
                                    ? const Color.fromARGB(255, 29, 92, 228)
                                    : Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Info cards (Scientific name, Family, Population)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildInfoCard("Scientific Name", scientificName),
                            const SizedBox(width: 12),
                            _buildInfoCard("Family", familyName),
                            const SizedBox(width: 12),
                            _buildInfoCard("Population", population),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Description section
                      Text(
                        'About ${name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        shortDescription,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpeciesDescriptionPage(
                      speciesId: crustacean.id,
                      speciesImage: crustacean.imagePath,
                      tag: crustacean.name,
                      type: crustacean.type,
                      speciesName: crustacean.name,
                      scientificName: crustacean.scientificName,
                      familyName: crustacean.familyName,
                      population: crustacean.population,
                      speciesDescription: crustacean.description,
                      sampleImage: crustacean.sampleImagePath,
                      imageDescription: crustacean.imageDescription,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text(
                "READ MORE",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

Widget _buildInfoCard(String title, String value) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF718096),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    ),
  );
}
