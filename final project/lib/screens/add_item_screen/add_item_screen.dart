import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/item_model.dart';
import 'package:myapp/viewmodels/items_viewmodel.dart';
import 'package:myapp/viewmodels/auth_viewmodel.dart';
import 'package:myapp/screens/dashboard_screen/dashboard_screen.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final ImagePicker picker = ImagePicker();

  // No need for selectedImage here, it's in the ViewModel

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    // Clear selected images when leaving the screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary), // Adjust icon color
      ),
      body: Consumer<ItemsViewModel>(
        builder: (context, itemsViewModel, child) => ListView(
          children: [
            const SizedBox(height: 80), // Adjusted spacing

            itemsViewModel.selectedImages!.isEmpty
                ? GestureDetector(
                    onTap: () {
                      itemsViewModel.pickImages();
                    },
                    child: Container(
                      color: Colors.white38,
                      height: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0), // Added margin
                      child: const Center(child: Icon(Icons.camera_alt, size: 50,)), // Centered and sized icon
                    ),
                  )
                : Column( // Changed to Column for better layout control
                    crossAxisAlignment: CrossAxisAlignment.start, // Align images to the start
                    children: [
                       Container(
                         color: Colors.white38,
                         height: 100,
                         width: 100,
                         margin: const EdgeInsets.only(left: 16.0), // Added left margin
                         child: IconButton(
                             onPressed: () {
                               itemsViewModel.pickImages();
                             },
                             icon: const Icon(Icons.camera_alt))
                       ),
                      const SizedBox(height: 8), // Spacing between camera icon and image list
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: itemsViewModel.selectedImages!.length,
                          itemBuilder: (context, index) {
                            final imageFile = itemsViewModel.selectedImages![index];
                            return Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Image.file(
                                    imageFile,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      itemsViewModel.removeImage(index);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),

            Padding(
              padding: const EdgeInsets.all(16.0), // Consistent padding
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0), // Consistent padding
              child: TextField(
                controller: bodyController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Body",
                  border: OutlineInputBorder(),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final itemsViewModel = Provider.of<ItemsViewModel>(context, listen: false);
          final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
          // Create Item object with the list of image paths
          final newItem = Item(
            id: DateTime.now().toString(), // Simple unique ID for now
            name: titleController.text,
            description: bodyController.text,
            userId: authViewModel.userEmail ?? '',
            isFavorite: false,
            imageUrls: itemsViewModel.selectedImages!.map((file) => file.path).toList(), // Save image paths
            createdAt: DateTime.now(), // Added required parameter
          );

          itemsViewModel.addItem(newItem);
          itemsViewModel.clearSelectedImages(); // Clear selected images after adding item

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
} 