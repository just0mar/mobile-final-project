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

Here's how the project is divided among the team members to balance the workload:

*   **Omar Mohamed (Member 1):** Core App Setup and Item Display (main.dart, SplashScreen, DashboardScreen - setup and HomeTab display, ItemModel)
*   **Saif Salah (Member 2):** Item Creation and Core Item ViewModel Logic (AddItemScreen, ItemsViewModel - add/save/load, ItemsApiService)
*   **Abdelraahman Emad (Member 3):** Item Details and Favorites (ItemDetailsScreen, FavoritesScreen, ItemsViewModel - favorites/filtering)
*   **Adham Elsayed (Member 4):** Authentication UI and ViewModel (LoginScreen, SignupScreen, AuthViewModel, AuthApiService)
*   **Adham Emad (Member 5):** User Profile, Theming, and Supplemental Services (ProfileScreen, ThemeViewModel, AppTheme, ApiService, QuoteViewModel, QuoteApiService, QuoteWidget)
