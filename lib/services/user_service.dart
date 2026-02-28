// lib/services/user_service.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  // 登录方法（从API响应设置用户）
  Future<void> login(String account, String password) async {
    // 这里在实际应用中应该调用API
    // 现在先用模拟数据
    _currentUser = User(
      id: '12345',
      username: account,
      email: account.contains('@') ? account : '$account@example.com',
      phone: '13800138000',
      nickname: '旅行者',
      avatar: 'https://picsum.photos/200/200?random=101',
      level: 1,
      isVip: false,
      browseHistory: ['黄鹤楼', '东湖', '武汉大学'],
      favorites: ['黄鹤楼', '东湖樱园'],
      searchHistory: ['武汉美食', '武汉三日游'],
      watchLater: ['归元禅寺'],
    );
    _isLoggedIn = true;
    notifyListeners(); // 通知所有监听器更新UI
  }

  // 从API响应设置用户
  void setUser(User user) {
    _currentUser = user;
    _isLoggedIn = true;
    notifyListeners();
  }

  // 退出登录
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // 更新用户信息
  void updateUser({String? nickname, String? avatar}) {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        username: _currentUser!.username,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        nickname: nickname ?? _currentUser!.nickname,
        avatar: avatar ?? _currentUser!.avatar,
        level: _currentUser!.level,
        isVip: _currentUser!.isVip,
        browseHistory: _currentUser!.browseHistory,
        favorites: _currentUser!.favorites,
        searchHistory: _currentUser!.searchHistory,
        watchLater: _currentUser!.watchLater,
      );
      notifyListeners();
    }
  }

  // 添加浏览记录
  void addBrowseHistory(String item) {
    if (_currentUser != null) {
      final history = List<String>.from(_currentUser!.browseHistory);
      if (!history.contains(item)) {
        history.insert(0, item);
        if (history.length > 20) history.removeLast();
        
        _currentUser = User(
          id: _currentUser!.id,
          username: _currentUser!.username,
          email: _currentUser!.email,
          phone: _currentUser!.phone,
          nickname: _currentUser!.nickname,
          avatar: _currentUser!.avatar,
          level: _currentUser!.level,
          isVip: _currentUser!.isVip,
          browseHistory: history,
          favorites: _currentUser!.favorites,
          searchHistory: _currentUser!.searchHistory,
          watchLater: _currentUser!.watchLater,
        );
        notifyListeners();
      }
    }
  }

  // 添加收藏
  void addFavorite(String item) {
    if (_currentUser != null) {
      final favorites = List<String>.from(_currentUser!.favorites);
      if (!favorites.contains(item)) {
        favorites.add(item);
        
        _currentUser = User(
          id: _currentUser!.id,
          username: _currentUser!.username,
          email: _currentUser!.email,
          phone: _currentUser!.phone,
          nickname: _currentUser!.nickname,
          avatar: _currentUser!.avatar,
          level: _currentUser!.level,
          isVip: _currentUser!.isVip,
          browseHistory: _currentUser!.browseHistory,
          favorites: favorites,
          searchHistory: _currentUser!.searchHistory,
          watchLater: _currentUser!.watchLater,
        );
        notifyListeners();
      }
    }
  }

  // 开通VIP
  void upgradeToVip(int days) {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        username: _currentUser!.username,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        nickname: _currentUser!.nickname,
        avatar: _currentUser!.avatar,
        level: _currentUser!.level,
        isVip: true,
        vipExpireTime: DateTime.now().add(Duration(days: days)),
        browseHistory: _currentUser!.browseHistory,
        favorites: _currentUser!.favorites,
        searchHistory: _currentUser!.searchHistory,
        watchLater: _currentUser!.watchLater,
      );
      notifyListeners();
    }
  }
}