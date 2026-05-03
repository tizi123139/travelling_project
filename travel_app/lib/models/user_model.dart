// lib/models/user_model.dart
class User {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final String avatar;
  final String? nickname;
  final int level;
  final bool isVip;
  final DateTime? vipExpireTime;
  final List<String> browseHistory;
  final List<String> favorites;
  final List<String> searchHistory;
  final List<String> watchLater;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.avatar = 'https://picsum.photos/200/200?random=101',
    this.nickname,
    this.level = 1,
    this.isVip = false,
    this.vipExpireTime,
    this.browseHistory = const [],
    this.favorites = const [],
    this.searchHistory = const [],
    this.watchLater = const [],
  });
}

// VIP套餐模型
class VipPackage {
  final String id;
  final String name;
  final int days;
  final double price;
  final double originalPrice;
  final List<String> benefits;
  final bool isPopular;
  final String color;

  VipPackage({
    required this.id,
    required this.name,
    required this.days,
    required this.price,
    required this.originalPrice,
    required this.benefits,
    this.isPopular = false,
    required this.color,
  });
}