// lib/services/user_service.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  String? _token; 

User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  // 初始化：从本地加载登录状态
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token');
    _isLoggedIn = _token != null;
    
    // 加载用户信息（实际需调用API）
    if (_isLoggedIn) {
      String? username = prefs.getString('username');
      if (username != null) {
        _currentUser = User(
          id: prefs.getString('user_id') ?? '0',
          username: username,
          email: prefs.getString('email') ?? '$username@example.com',
          phone: prefs.getString('phone'),
          nickname: prefs.getString('nickname') ?? '旅行者',
          avatar: prefs.getString('avatar') ?? 'https://picsum.photos/200/200?random=101',
        );
      }
    }
    notifyListeners();
  }

  // 登录方法（保存到本地）
  Future<void> login(String account, String password, {required Map<String, dynamic> tokenData}) async {
    final prefs = await SharedPreferences.getInstance();
    // 保存Token和用户信息
    _token = tokenData['access_token'];
    await prefs.setString('access_token', _token!);
    await prefs.setString('username', tokenData['username']);
    await prefs.setString('user_id', tokenData['user_id'] ?? '12345'); // 需从后端返回user_id
    await prefs.setString('email', account.contains('@') ? account : '$account@example.com');
    
    _currentUser = User(
      id: prefs.getString('user_id') ?? '12345',
      username: tokenData['username'],
      email: prefs.getString('email')!,
      phone: account.isNotEmpty && account.length == 11 ? account : '13800138000',
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
    notifyListeners();
  }

  // 退出登录（清除本地存储）
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('username');
    await prefs.remove('user_id');
    await prefs.remove('email');
    await prefs.remove('phone');
    
    _currentUser = null;
    _isLoggedIn = false;
    _token = null;
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