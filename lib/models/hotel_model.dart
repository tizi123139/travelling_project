class Hotel {
  final String id;
  final String name;
  final String city;
  final String address;
  final double price;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final List<String> amenities;
  final String type; // 经济型/舒适型/豪华型/民宿
  final double latitude;
  final double longitude;
  final String description;
  final Map<String, double> roomTypes; // 房型: 价格

  Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.amenities,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.roomTypes,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      type: json['type'] ?? '舒适型',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      roomTypes: Map<String, double>.from(json['room_types'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'price': price,
      'rating': rating,
      'review_count': reviewCount,
      'images': images,
      'amenities': amenities,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'room_types': roomTypes,
    };
  }

  Hotel copyWith({
    String? id,
    String? name,
    String? city,
    String? address,
    double? price,
    double? rating,
    int? reviewCount,
    List<String>? images,
    List<String>? amenities,
    String? type,
    double? latitude,
    double? longitude,
    String? description,
    Map<String, double>? roomTypes,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      roomTypes: roomTypes ?? this.roomTypes,
    );
  }
}

// 预订信息模型
class HotelBooking {
  final String id;
  final String hotelId;
  final String hotelName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;
  final Map<String, int> selectedRooms; // 房型: 数量
  final double totalPrice;
  final String status; // pending/confirmed/cancelled
  final DateTime createdAt;

  HotelBooking({
    required this.id,
    required this.hotelId,
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
    required this.selectedRooms,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory HotelBooking.fromJson(Map<String, dynamic> json) {
    return HotelBooking(
      id: json['id'] ?? '',
      hotelId: json['hotel_id'] ?? '',
      hotelName: json['hotel_name'] ?? '',
      checkIn: DateTime.parse(json['check_in']),
      checkOut: DateTime.parse(json['check_out']),
      guests: json['guests'] ?? 1,
      rooms: json['rooms'] ?? 1,
      selectedRooms: Map<String, int>.from(json['selected_rooms'] ?? {}),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}