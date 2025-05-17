# My App

## Project Description
This project is a mobile application built with Flutter that allows users to manage a list of items. Users can add new items with images, mark items as favorites, view item details, and manage their user profile. The application demonstrates the use of modern Flutter development practices, including state management with Provider and architectural patterns like MVVM.

## Features List
*   User Authentication (Login, Registration)
*   User Profile Management (View and Edit Profile)
*   Add New Items with Image Selection
*   View List of Items
*   View Item Details
*   Mark Items as Favorites
*   Dark and Light Mode Theming
*   Integration with a local storage fallback for item data.

## Technical Highlights
*   **State Management:** Utilizes the `provider` package for efficient and maintainable state management.
*   **Architecture Pattern:** Follows the Model-View-ViewModel (MVVM) architectural pattern for better separation of concerns.
*   **Persistent Storage:** Demonstrates the use of `shared_preferences` for local data persistence (items and theme preference).
*   **API Integration:** Includes an API service layer for handling data interactions (currently set up with a local storage fallback).
*   **Form Handling:** Implements form validation using `Form` and `TextFormField` for user input screens.
*   **Clean and Readable Code:** Focuses on writing clean, well-structured, and readable Dart code.
*   **MVVM and Provider Best Practices:** Adheres to best practices when using the MVVM pattern and the Provider package.

## Team Members and Responsibilities

Here's how the project is divided among the team members:

*   **Omar Mohamed (Member 1):** Authentication and User Management (Login Screen, Signup Screen, Profile Screen, AuthViewModel, AuthApiService)
*   **Saif Salah (Member 2):** Item Creation and Core Logic (AddItemScreen, ItemsViewModel - core methods, ItemsApiService, ItemModel)
*   **Abdelraahman Emad (Member 3):** Item Display and Details (DashboardScreen - display logic, ItemDetailsScreen, ItemModel)
*   **Adham Elsayed (Member 4):** Favorites and Supplemental Features (FavoritesScreen, ItemsViewModel - favorites logic, QuoteViewModel, QuoteApiService, QuoteWidget)
*   **Adham Emad (Member 5):** Infrastructure, Theming, and App Setup (main.dart, AppTheme, ThemeViewModel, ApiService, SplashScreen)