// lib/services/message_service.dart
import 'package:flutter/material.dart';
import '../models/message_model.dart';

class MessageService extends ChangeNotifier {
  List<UserRelation> _followings = []; // 我关注的人
  List<UserRelation> _followers = []; // 我的粉丝
  List<Message> _messages = []; // 私聊消息
  Map<String, List<Message>> _chatHistories = {}; // 按用户ID分组的聊天记录

  List<UserRelation> get followings => _followings;
  List<UserRelation> get followers => _followers;
  List<Message> get messages => _messages;

  // 获取与特定用户的聊天记录
  List<Message> getChatHistory(String userId) {
    return _chatHistories[userId] ?? [];
  }

  // 关注用户
  void followUser(UserRelation user) {
    if (!_followings.any((u) => u.userId == user.userId)) {
      final newRelation = UserRelation(
        id: user.id,
        userId: user.userId,
        username: user.username,
        nickname: user.nickname,
        avatar: user.avatar,
        isFollowed: true,
        isFollower: user.isFollower,
        isMutual: user.isFollower, // 如果对方已经是粉丝，则变成互关
        followTime: DateTime.now(),
      );
      _followings.add(newRelation);
      
      // 更新粉丝列表中的互关状态
      final followerIndex = _followers.indexWhere((f) => f.userId == user.userId);
      if (followerIndex != -1) {
        _followers[followerIndex] = UserRelation(
          id: _followers[followerIndex].id,
          userId: _followers[followerIndex].userId,
          username: _followers[followerIndex].username,
          nickname: _followers[followerIndex].nickname,
          avatar: _followers[followerIndex].avatar,
          isFollowed: true,
          isFollower: true,
          isMutual: true,
          followTime: _followers[followerIndex].followTime,
        );
      }
      
      notifyListeners();
    }
  }

  // 取消关注
  void unfollowUser(String userId) {
    _followings.removeWhere((u) => u.userId == userId);
    
    // 更新粉丝列表中的互关状态
    final followerIndex = _followers.indexWhere((f) => f.userId == userId);
    if (followerIndex != -1) {
      _followers[followerIndex] = UserRelation(
        id: _followers[followerIndex].id,
        userId: _followers[followerIndex].userId,
        username: _followers[followerIndex].username,
        nickname: _followers[followerIndex].nickname,
        avatar: _followers[followerIndex].avatar,
        isFollowed: false,
        isFollower: true,
        isMutual: false,
        followTime: _followers[followerIndex].followTime,
      );
    }
    
    notifyListeners();
  }

  // 添加粉丝（被别人关注）
  void addFollower(UserRelation user) {
    if (!_followers.any((f) => f.userId == user.userId)) {
      final isFollowing = _followings.any((u) => u.userId == user.userId);
      final newFollower = UserRelation(
        id: user.id,
        userId: user.userId,
        username: user.username,
        nickname: user.nickname,
        avatar: user.avatar,
        isFollowed: isFollowing,
        isFollower: true,
        isMutual: isFollowing,
        followTime: DateTime.now(),
      );
      _followers.add(newFollower);
      notifyListeners();
    }
  }

  // 发送私聊消息
  void sendMessage({
    required String fromUserId,
    required String fromUserName,
    required String fromUserAvatar,
    required String toUserId,
    required String content,
  }) {
    final message = Message(
      id: DateTime.now().toString(),
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      fromUserAvatar: fromUserAvatar,
      toUserId: toUserId,
      content: content,
      sendTime: DateTime.now(),
      isRead: false,
    );
    
    _messages.add(message);
    
    // 保存到聊天历史
    if (!_chatHistories.containsKey(toUserId)) {
      _chatHistories[toUserId] = [];
    }
    _chatHistories[toUserId]!.add(message);
    
    notifyListeners();
  }

  // 标记消息为已读
  void markAsRead(String messageId) {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      _messages[index] = Message(
        id: _messages[index].id,
        fromUserId: _messages[index].fromUserId,
        fromUserName: _messages[index].fromUserName,
        fromUserAvatar: _messages[index].fromUserAvatar,
        toUserId: _messages[index].toUserId,
        content: _messages[index].content,
        sendTime: _messages[index].sendTime,
        isRead: true,
        type: _messages[index].type,
      );
      notifyListeners();
    }
  }

  // 获取未读消息数
  int getUnreadCount(String userId) {
    return _messages.where((m) => m.toUserId == userId && !m.isRead).length;
  }

  // 模拟数据（用于测试）
  void loadMockData() {
    // 添加一些模拟粉丝
    _followers = [
      UserRelation(
        id: 'f1',
        userId: 'u1001',
        username: 'travel_fan',
        nickname: '旅行爱好者',
        avatar: 'https://picsum.photos/200/200?random=201',
        isFollowed: true,
        isFollower: true,
        isMutual: true,
        followTime: DateTime.now().subtract(const Duration(days: 5)),
      ),
      UserRelation(
        id: 'f2',
        userId: 'u1002',
        username: 'photo_lover',
        nickname: '摄影达人',
        avatar: 'https://picsum.photos/200/200?random=202',
        isFollowed: false,
        isFollower: true,
        isMutual: false,
        followTime: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    // 添加一些模拟关注
    _followings = [
      UserRelation(
        id: 'g1',
        userId: 'u1003',
        username: 'food_explorer',
        nickname: '美食探险家',
        avatar: 'https://picsum.photos/200/200?random=203',
        isFollowed: true,
        isFollower: true,
        isMutual: true,
        followTime: DateTime.now().subtract(const Duration(days: 10)),
      ),
      UserRelation(
        id: 'g2',
        userId: 'u1004',
        username: 'history_buff',
        nickname: '历史迷',
        avatar: 'https://picsum.photos/200/200?random=204',
        isFollowed: true,
        isFollower: false,
        isMutual: false,
        followTime: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    // 添加一些模拟消息
    _chatHistories['u1001'] = [
      Message(
        id: 'm1',
        fromUserId: 'u1001',
        fromUserName: '旅行爱好者',
        fromUserAvatar: 'https://picsum.photos/200/200?random=201',
        toUserId: 'current_user',
        content: '你好，看了你的武汉攻略，写得真好！',
        sendTime: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      Message(
        id: 'm2',
        fromUserId: 'current_user',
        fromUserName: '我',
        fromUserAvatar: 'https://picsum.photos/200/200?random=101',
        toUserId: 'u1001',
        content: '谢谢！有什么需要帮忙的吗？',
        sendTime: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
    ];

    notifyListeners();
  }
}