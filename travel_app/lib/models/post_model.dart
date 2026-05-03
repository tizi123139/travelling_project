class Post {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final List<String> imageUrls;
  final String title;
  final String description;
  final String location;
  final DateTime createTime;
  
  // 这些字段改为非 final，以便修改
  int likeCount;
  int commentCount;
  int favoriteCount;
  bool isLiked;
  bool isFavorited;
  final List<String> tags;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.imageUrls,
    required this.title,
    required this.description,
    required this.location,
    required this.createTime,
    this.likeCount = 0,
    this.commentCount = 0,
    this.favoriteCount = 0,
    this.isLiked = false,
    this.isFavorited = false,
    this.tags = const [],
  });
}