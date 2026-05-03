// lib/models/message_model.dart
class UserRelation {
  final String id;
  final String userId;
  final String username;
  final String nickname;
  final String avatar;
  final bool isFollowed; // 是否已关注
  final bool isFollower; // 是否是粉丝
  final bool isMutual; // 是否互关
  final DateTime followTime;

  UserRelation({
    required this.id,
    required this.userId,
    required this.username,
    required this.nickname,
    required this.avatar,
    this.isFollowed = false,
    this.isFollower = false,
    this.isMutual = false,
    required this.followTime,
  });
}

class Message {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String fromUserAvatar;
  final String toUserId;
  final String content;
  final DateTime sendTime;
  final bool isRead;
  final MessageType type;

  Message({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    required this.fromUserAvatar,
    required this.toUserId,
    required this.content,
    required this.sendTime,
    this.isRead = false,
    this.type = MessageType.text,
  });
}

enum MessageType {
  text,
  image,
  system,
}