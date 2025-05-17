import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Description
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our App',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to our innovative task management application! Our app is designed to help you stay organized and productive in your daily life. With features like task tracking, reminders, and a beautiful user interface, we aim to make task management simple and enjoyable.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Built with Flutter and following MVVM architecture, our app provides a seamless experience across all platforms. We prioritize user privacy and data security while delivering a feature-rich experience.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Team Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Our Team',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Team Members
            _buildTeamMember(
              context,
              name: 'Omar Mohamed',
              role: 'Backend Developer',
              imagePath: 'assets/person1.jpg',
            ),
            _buildTeamMember(
              context,
              name: 'Saif Salah',
              role: 'Backend Developer',
              imagePath: 'assets/person2.jpg',
            ),
            _buildTeamMember(
              context,
              name: 'Adham Emad',
              role: 'Flutter Developer',
              imagePath: 'assets/person4.jpg',
            ),
            _buildTeamMember(
              context,
              name: 'Adham Elsayed',
              role: 'Cyber Security',
              imagePath: 'assets/person5.jpg',
            ),
            _buildTeamMember(
              context,
              name: 'Abdelrahman Emad',
              role: 'Data Analyst',
              imagePath: 'assets/person3.jpg',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(
    BuildContext context, {
    required String name,
    required String role,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 