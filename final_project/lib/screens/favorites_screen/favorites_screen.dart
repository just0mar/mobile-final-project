import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/item_model.dart';
import 'package:myapp/viewmodels/items_viewmodel.dart';
import 'package:myapp/screens/item_details_screen/item_details_screen.dart';
import 'package:myapp/viewmodels/auth_viewmodel.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, ItemsViewModel>(
      builder: (context, authViewModel, itemsViewModel, child) {
        final favoriteItems = itemsViewModel.getFavoriteItems(authViewModel.userEmail ?? '');
        
        if (favoriteItems.isEmpty) {
          return const Center(
            child: Text('No favorite items yet'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteItems.length,
          itemBuilder: (context, index) {
            final item = favoriteItems[index];
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
                  icon: const Icon(Icons.favorite, color: Colors.red),
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
        );
      },
    );
  }
} 