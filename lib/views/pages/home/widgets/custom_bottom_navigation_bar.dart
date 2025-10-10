import 'package:crustascan_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:crustascan_app/views/pages/home/home_page.dart';
import 'package:crustascan_app/views/pages/favorites/favorites_page.dart';
import 'package:crustascan_app/views/pages/history/history_page.dart';
import 'package:crustascan_app/views/pages/profile/profile_page.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 15,
      notchMargin: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            iconSize: 28,
          ),

          if (authProvider.isUser)
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              },
              iconSize: 28,
            ),

          const SizedBox(width: 40),

          if (authProvider.isUser)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
              iconSize: 28,
            ),

          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            iconSize: 28,
          ),
        ],
      ),
    );
  }
}
