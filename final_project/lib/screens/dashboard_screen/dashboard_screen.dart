import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/item_model.dart';
import 'package:myapp/viewmodels/auth_viewmodel.dart';
import 'package:myapp/viewmodels/items_viewmodel.dart';
import 'package:myapp/screens/add_item_screen/add_item_screen.dart';
import 'package:myapp/screens/item_details_screen/item_details_screen.dart';
import 'package:myapp/screens/profile_screen/profile_screen.dart';
import 'package:myapp/screens/favorites_screen/favorites_screen.dart';
import 'package:myapp/screens/about_screen/about_screen.dart';
import 'package:myapp/widgets/quote_widget.dart';

// DashboardScreen widget - Main screen of the application
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Index of the currently selected tab
  int _selectedIndex = 0;

  // List of screens to show in the bottom navigation
  final List<Widget> _screens = [
    const _HomeTab(),
    const FavoritesScreen(),
    const AboutScreen(),
    const ProfileScreen(),
  ];

  // Get the title based on selected tab
  String get _title {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Favorites';
      case 2:
        return 'About Us';
      case 3:
        return 'Profile';
      default:
        return 'Dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        // Show add button only in home tab
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddItemScreen(),
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      // Show the selected screen
      body: _screens[_selectedIndex],
      // Bottom navigation bar for switching between screens
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// HomeTab widget - Shows the list of items in the dashboard
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, ItemsViewModel>(
      builder: (context, authViewModel, itemsViewModel, child) {
        // Get items for the current user
        final userItems = itemsViewModel.getItemsByUserId(authViewModel.userEmail ?? '');
        
        return Column(
          children: [
            // Show daily quote at the top
            const QuoteWidget(),
            // List of items
            Expanded(
              child: ListView.builder(
                key: ValueKey(userItems.length),
                padding: const EdgeInsets.all(16),
                itemCount: userItems.length,
                itemBuilder: (context, index) {
                  final item = userItems[index];
                  // Get the first image URL if available
                  final firstImageUrl = item.imageUrls != null && item.imageUrls!.isNotEmpty 
                      ? item.imageUrls!.first 
                      : null;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      // Show item image or placeholder
                      leading: firstImageUrl != null
                          ? CircleAvatar(
                              backgroundImage: firstImageUrl.startsWith('http')
                                  ? NetworkImage(firstImageUrl)
                                  : FileImage(File(firstImageUrl)) as ImageProvider,
                            )
                          : const CircleAvatar(
                              child: Icon(Icons.image),
                            ),
                      title: Text(item.name),
                      subtitle: Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Favorite button
                      trailing: IconButton(
                        icon: Icon(
                          item.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: item.isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          itemsViewModel.toggleFavorite(item.id);
                        },
                      ),
                      // Navigate to item details on tap
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ItemDetailsScreen(item: item),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
} 