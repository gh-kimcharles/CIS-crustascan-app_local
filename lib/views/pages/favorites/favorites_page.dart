import 'package:crustascan_app/services/network_service.dart';
import 'package:crustascan_app/views/pages/home/home_page.dart';
import 'package:crustascan_app/views/pages/home/widgets/custom_bottom_navigation_bar.dart';
import 'package:crustascan_app/views/pages/home/widgets/custom_floating_action_button.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:crustascan_app/views/widgets/global_no_connection_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crustascan_app/data/crustacean_data.dart';
import 'package:crustascan_app/providers/user_provider.dart';
import 'package:crustascan_app/views/pages/home/widgets/species_container.dart';
import 'package:crustascan_app/views/pages/home/species_description_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with ConnectionMonitorMixin {
  @override
  void initState() {
    super.initState();
    initializeConnectionMonitoring();
  }

  @override
  void dispose() {
    disposeConnectionMonitoring();
    super.dispose();
  }

  Widget _buildFavoriteContent() {
    final userProvider = Provider.of<UserProvider>(context);
    final favoriteIds = userProvider.favorites;

    // Filter crustaceanList to only include favorites
    final favoriteSpecies = crustaceanList.where((species) {
      return favoriteIds.contains(species.id);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: favoriteSpecies.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, size: 64, color: Colors.grey.shade300),
                  SizedBox(height: 16),
                  Text(
                    "You have no favorite yet.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Toggle your favorite species to see here!",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
              children: favoriteSpecies.map((crustaceanItem) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(text: "Favorites", navigatePage: HomePage()),
      body: hasConnection
          ? _buildFavoriteContent()
          : GlobalNoConnectionWidget(isExpanded: false),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
