import 'package:crustascan_app/data/crustacean_data.dart';
import 'package:crustascan_app/models/crustacean_model.dart';
import 'package:crustascan_app/views/pages/home/species_description_page.dart';
import 'package:crustascan_app/views/pages/home/widgets/species_container.dart';
import 'package:flutter/material.dart';

class SpeciesGrid extends StatelessWidget {
  final String searchText;
  final String selectedCategory;
  final bool isLoading;

  const SpeciesGrid({
    super.key,
    required this.searchText,
    required this.selectedCategory,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final List<Crustacean> species = crustaceanList;

    // Filter function grid
    List<Crustacean> filteredSpecies = species.where((crustaceanItem) {
      final matchCategory =
          selectedCategory == "All" || crustaceanItem.type == selectedCategory;
      final matchSearch = crustaceanItem.name.toLowerCase().contains(
        searchText.toLowerCase(),
      );
      return matchCategory && matchSearch;
    }).toList();

    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : filteredSpecies.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No species available.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Try searching another species!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            : GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
                children: filteredSpecies.map((crustaceanItem) {
                  return SpeciesContainer(
                    speciesId: crustaceanItem.id,
                    imagePath: crustaceanItem.imagePath,
                    speciesName: crustaceanItem.name.length > 15
                        ? '${crustaceanItem.name.substring(0, 15)}...'
                        : crustaceanItem.name,
                    speciesType: crustaceanItem.type,
                    speciesDesc: crustaceanItem.description.length > 22
                        ? '${crustaceanItem.description.substring(0, 22)}...'
                        : crustaceanItem.description,
                    speciesDescPage: SpeciesDescriptionPage(
                      speciesId: crustaceanItem.id,
                      speciesImage: crustaceanItem.imagePath,
                      tag: crustaceanItem.name,
                      type: crustaceanItem.type,
                      speciesName: crustaceanItem.name,
                      scientificName: crustaceanItem.scientificName,
                      familyName: crustaceanItem.familyName,
                      population: crustaceanItem.population,
                      speciesDescription: crustaceanItem.description,
                      sampleImage: crustaceanItem.sampleImagePath,
                      imageDescription: crustaceanItem.imageDescription,
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
