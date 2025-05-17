class Item {
  final String id;
  final String name;
  final String description;
  final List<String>? imageUrls;
  final bool isFavorite;
  final DateTime createdAt;
  final String userId;

  Item({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrls,
    this.isFavorite = false,
    required this.createdAt,
    required this.userId,
  });

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