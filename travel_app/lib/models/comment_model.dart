class Comment {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createTime;
  final int likeCount;
  final bool isLiked;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createTime,
    this.likeCount = 0,
    this.isLiked = false,
    this.replies = const [],
  });
}