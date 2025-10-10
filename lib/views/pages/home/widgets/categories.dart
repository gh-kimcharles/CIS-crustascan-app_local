import 'package:crustascan_app/views/pages/home/widgets/category_button.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const Categories({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              [
                {"text": "All", "icon": "assets/icons/all_icon.png"},
                {"text": "Crab", "icon": "assets/icons/crab_icon.png"},
                {"text": "Shrimp", "icon": "assets/icons/shrimp_icon.png"},
                {"text": "Prawn", "icon": "assets/icons/prawn_icon.png"},
              ].map((categoryItem) {
                return CategoryButton(
                  text: categoryItem['text']!,
                  iconPath: categoryItem['icon']!,
                  focused: selectedCategory == categoryItem['text'],
                  onPressed: () => onCategorySelected(categoryItem['text']!),
                );
              }).toList(),
        ),
      ),
    );
  }
}
