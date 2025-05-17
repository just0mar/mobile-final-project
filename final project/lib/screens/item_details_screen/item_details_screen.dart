import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/item_model.dart';
import 'package:myapp/viewmodels/items_viewmodel.dart';
import 'package:intl/intl.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late Item _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Item'),
                  content: const Text('Are you sure you want to delete this item?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<ItemsViewModel>(context, listen: false)
                            .deleteItem(_item.id);
                        Navigator.of(context)
                          ..pop() // Close dialog
                          ..pop(); // Close details screen
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display multiple images in a horizontal list if available
            if (_item.imageUrls != null && _item.imageUrls!.isNotEmpty)
              SizedBox(
                height: 200, // Set a fixed height for the image list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _item.imageUrls!.length,
                  itemBuilder: (context, index) {
                    final imageUrl = _item.imageUrls![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add spacing between images
                      child: imageUrl.startsWith('http')
                          ? Image.network(
                              imageUrl,
                              width: 200, // Set a fixed width for each image
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(imageUrl),
                              width: 200, // Set a fixed width for each image
                              fit: BoxFit.cover,
                            ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              _item.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Created on ${DateFormat('MMM dd, yyyy').format(_item.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(_item.description),
            const SizedBox(height: 24),
            Consumer<ItemsViewModel>(
              builder: (context, itemsViewModel, child) {
                return ElevatedButton.icon(
                  onPressed: () {
                    itemsViewModel.toggleFavorite(_item.id);
                    setState(() {
                      _item = _item.copyWith(isFavorite: !_item.isFavorite);
                    });
                  },
                  icon: Icon(
                    _item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _item.isFavorite ? Colors.red : null,
                  ),
                  label: Text(
                    _item.isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 