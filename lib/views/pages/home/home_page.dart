import 'package:crustascan_app/services/network_service.dart';
import 'package:crustascan_app/views/pages/home/widgets/categories.dart';
import 'package:crustascan_app/views/pages/home/widgets/custom_bottom_navigation_bar.dart';
import 'package:crustascan_app/views/pages/home/widgets/custom_floating_action_button.dart';
import 'package:crustascan_app/views/pages/home/widgets/home_banner.dart';
import 'package:crustascan_app/views/pages/home/widgets/profile_header.dart';
import 'package:crustascan_app/views/pages/home/widgets/custom_search_bar.dart';
import 'package:crustascan_app/views/pages/home/widgets/species_grid.dart';
import 'package:crustascan_app/views/widgets/global_no_connection_widget.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ConnectionMonitorMixin {
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";
  String selectedCategory = "All"; // default category
  bool isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    initializeConnectionMonitoring();
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void onSearchChanged(String text) {
    setState(() {
      isLoading = true;
    });

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchText = text;
        isLoading = false;
      });
    });
  }

  void clearSearch() {
    _searchController.clear();
    setState(() {
      searchText = "";
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    disposeConnectionMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            ProfileHeader(),
            CustomSearchBar(
              controller: _searchController,
              onChanged: onSearchChanged,
              onClear: clearSearch,
              showClear: searchText.isNotEmpty,
            ),
            HomeBanner(),
            // Show either no connection widget or normal content
            hasConnection
                ? Expanded(
                    child: Column(
                      children: [
                        Categories(
                          selectedCategory: selectedCategory,
                          onCategorySelected: onCategorySelected,
                        ),
                        SpeciesGrid(
                          searchText: searchText,
                          selectedCategory: selectedCategory,
                          isLoading: isLoading,
                        ),
                      ],
                    ),
                  )
                : GlobalNoConnectionWidget(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        floatingActionButton: CustomFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
