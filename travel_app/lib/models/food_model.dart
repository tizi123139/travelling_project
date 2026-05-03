class Food {
  final String id;
  final String name;
  final String city;
  final String address;
  final double price;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final String category; // 特色小吃/火锅/烧烤等
  final List<String> tags;
  final String description;
  final String businessHours;
  final String phone;
  final double latitude;
  final double longitude;
  final List<FoodReview> reviews;

  Food({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.category,
    required this.tags,
    required this.description,
    required this.businessHours,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.reviews,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '特色小吃',
      tags: List<String>.from(json['tags'] ?? []),
      description: json['description'] ?? '',
      businessHours: json['business_hours'] ?? '09:00-22:00',
      phone: json['phone'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      reviews: (json['reviews'] as List? ?? [])
          .map((review) => FoodReview.fromJson(review))
          .toList(),
    );
  }
}

class FoodReview {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String content;
  final List<String> images;
  final int likes;
  final DateTime createdAt;
  final List<FoodReview> replies;

  FoodReview({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.content,
    required this.images,
    required this.likes,
    required this.createdAt,
    required this.replies,
  });

  factory FoodReview.fromJson(Map<String, dynamic> json) {
    return FoodReview(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userAvatar: json['user_avatar'],
      rating: (json['rating'] ?? 0).toDouble(),
      content: json['content'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      likes: json['likes'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      replies: (json['replies'] as List? ?? [])
          .map((reply) => FoodReview.fromJson(reply))
          .toList(),
    );
  }
}