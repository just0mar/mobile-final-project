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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const FavoritesScreen(),
    const AboutScreen(),
    const ProfileScreen(),
  ];

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
      body: _screens[_selectedIndex],
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

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, ItemsViewModel>(
      builder: (context, authViewModel, itemsViewModel, child) {
        final userItems = itemsViewModel.getItemsByUserId(authViewModel.userEmail ?? '');
        
        return Column(
          children: [
            const QuoteWidget(),
            Expanded(
              child: ListView.builder(
                key: ValueKey(userItems.length),
                padding: const EdgeInsets.all(16),
                itemCount: userItems.length,
                itemBuilder: (context, index) {
                  final item = userItems[index];
                  // Get the first image URL if the list is not empty
                  final firstImageUrl = item.imageUrls != null && item.imageUrls!.isNotEmpty ? item.imageUrls!.first : null;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
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
                      trailing: IconButton(
                        icon: Icon(
                          item.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: item.isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          itemsViewModel.toggleFavorite(item.id);
                        },
                      ),
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