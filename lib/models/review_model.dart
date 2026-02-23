class Review {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String shopName;
  final String shopType;
  final String location;
  final double rating;
  final String content;
  final List<String> images;
  final DateTime visitTime;
  final DateTime createTime;
  
  // 这些字段改为非 final
  int likeCount;
  int commentCount;
  int reviewCount;  // 新增
  bool isLiked;
  final List<String> tags;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.shopName,
    required this.shopType,
    required this.location,
    required this.rating,
    required this.content,
    required this.images,
    required this.visitTime,
    required this.createTime,
    this.likeCount = 0,
    this.commentCount = 0,
    this.reviewCount = 0,  // 默认值
    this.isLiked = false,
    this.tags = const [],
  });
}