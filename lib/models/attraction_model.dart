class Attraction {
  final String id;
  final String name;
  final String city;
  final String address;
  final String description;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final String category; // 历史文化/自然风光/主题公园等
  final double price;
  final String businessHours;
  final double latitude;
  final double longitude;
  final List<String> tags;
  final int recommendedDuration; // 分钟

  Attraction({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.category,
    required this.price,
    required this.businessHours,
    required this.latitude,
    required this.longitude,
    required this.tags,
    required this.recommendedDuration,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      businessHours: json['business_hours'] ?? '09:00-17:00',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
      recommendedDuration: json['recommended_duration'] ?? 120,
    );
  }
}