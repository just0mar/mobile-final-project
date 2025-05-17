// Item model class representing a single item in the application
class Item {
  // Unique identifier for the item
  final String id;
  // Name/title of the item
  final String name;
  // Detailed description of the item
  final String description;
  // Optional list of image URLs associated with the item
  final List<String>? imageUrls;
  // Flag indicating if the item is marked as favorite
  final bool isFavorite;
  // Timestamp when the item was created
  final DateTime createdAt;
  // ID of the user who owns this item
  final String userId;

  // Constructor with required and optional parameters
  Item({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrls,
    this.isFavorite = false,
    required this.createdAt,
    required this.userId,
  });

  // Creates a new Item instance with selectively updated fields
  // Used for immutable updates
  Item copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? imageUrls,
    bool? isFavorite,
    DateTime? createdAt,
    String? userId,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }

  // Converts the Item object to a JSON map
  // Used for data persistence and API communication
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrls': imageUrls,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }

  // Creates an Item instance from a JSON map
  // Used for deserializing stored or API data
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
    );
  }
} 