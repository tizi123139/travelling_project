// lib/services/user_service.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  // 登录
  Future<bool> login(String account, String password) async {
    // TODO: 调用后端登录API
    // 模拟登录成功
    if (account.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(
        id: '1',
        username: account,
        email: account.contains('@') ? account : '$account@example.com',
        phone: '13800138000',
        nickname: '旅行达人',
        level: 5,
        isVip: true,
        vipExpireTime: DateTime.now().add(const Duration(days: 30)),
        browseHistory: ['黄鹤楼', '东湖', '武汉大学', '湖北省博物馆'],
        favorites: ['黄鹤楼', '东湖樱园', '粮道街美食'],
        searchHistory: ['武汉美食', '武汉三日游', '武汉住宿'],
        watchLater: ['归元禅寺', '晴川阁', '汉口江滩'],
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  // 注册
  Future<bool> register({
    required String email,
    required String phone,
    required String password,
  }) async {
    // TODO: 调用后端注册API
    // 模拟注册成功
    if (email.isNotEmpty && phone.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(
        id: DateTime.now().toString(),
        username: email.split('@')[0],
        email: email,
        phone: phone,
        nickname: '新用户',
        level: 1,
        isVip: false,
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  // 第三方登录
  Future<bool> socialLogin(String platform) async {
    // TODO: 调用第三方登录API
    _currentUser = User(
      id: 'social_${DateTime.now().toString()}',
      username: '微信用户',
      email: 'wechat_user@example.com',
      avatar: 'https://picsum.photos/200/200?random=101',
      nickname: '微信用户',
      level: 1,
      isVip: false,
    );
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  // 退出登录
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // 更新用户信息
  void updateUser({
    String? nickname,
    String? avatar,
    String? phone,
  }) {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        username: _currentUser!.username,
        email: _currentUser!.email,
        phone: phone ?? _currentUser!.phone,
        avatar: avatar ?? _currentUser!.avatar,
        nickname: nickname ?? _currentUser!.nickname,
        level: _currentUser!.level,
        isVip: _currentUser!.isVip,
        vipExpireTime: _currentUser!.vipExpireTime,
        browseHistory: _currentUser!.browseHistory,
        favorites: _currentUser!.favorites,
        searchHistory: _currentUser!.searchHistory,
        watchLater: _currentUser!.watchLater,
      );
      notifyListeners();
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
        avatar: _currentUser!.avatar,
        nickname: _currentUser!.nickname,
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
          avatar: _currentUser!.avatar,
          nickname: _currentUser!.nickname,
          level: _currentUser!.level,
          isVip: _currentUser!.isVip,
          vipExpireTime: _currentUser!.vipExpireTime,
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
          avatar: _currentUser!.avatar,
          nickname: _currentUser!.nickname,
          level: _currentUser!.level,
          isVip: _currentUser!.isVip,
          vipExpireTime: _currentUser!.vipExpireTime,
          browseHistory: _currentUser!.browseHistory,
          favorites: favorites,
          searchHistory: _currentUser!.searchHistory,
          watchLater: _currentUser!.watchLater,
        );
        notifyListeners();
      }
    }
  }

  // 移除收藏
  void removeFavorite(String item) {
    if (_currentUser != null) {
      final favorites = List<String>.from(_currentUser!.favorites);
      favorites.remove(item);
      
      _currentUser = User(
        id: _currentUser!.id,
        username: _currentUser!.username,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        avatar: _currentUser!.avatar,
        nickname: _currentUser!.nickname,
        level: _currentUser!.level,
        isVip: _currentUser!.isVip,
        vipExpireTime: _currentUser!.vipExpireTime,
        browseHistory: _currentUser!.browseHistory,
        favorites: favorites,
        searchHistory: _currentUser!.searchHistory,
        watchLater: _currentUser!.watchLater,
      );
      notifyListeners();
    }
  }
}