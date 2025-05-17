import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/screens/profile_screen/profile_screen.dart';
import 'package:myapp/screens/about_screen/about_screen.dart';
import 'package:myapp/viewmodels/auth_viewmodel.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return UserAccountsDrawerHeader(
                accountName: Text(authViewModel.userName ?? 'No Name'),
                accountEmail: Text(authViewModel.userEmail ?? 'No Email'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: authViewModel.profilePicPath != null
                      ? FileImage(File(authViewModel.profilePicPath!))
                      : null,
                  child: authViewModel.profilePicPath == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.pop(context);
              final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
              await authViewModel.logout();
            },
          ),
        ],
      ),
    );
  }
} 