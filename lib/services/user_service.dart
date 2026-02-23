// lib/services/user_service.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends ChangeNotifier {
 
    User? _currentUser;
    bool _isLoggedIn = false;
    bool _isLoading = false;
    String _errorMessage = '';

    User? get currentUser => _currentUser;
    bool get isLoggedIn => _isLoggedIn;
    bool get isLoading => _isLoading;
    String get errorMessage => _errorMessage;

    // 初始化：检查本地是否有 token
    Future<void> init() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final username = prefs.getString('username');
      if (token != null && username != null) {
        _isLoggedIn = true;
        // 这里可以根据 token 去拉取用户信息，现在先简单恢复状态
        _currentUser = User(
          id: '', // 可以后续通过接口获取
          username: username,
          email: '',
          phone: '',
        );
        notifyListeners();
      }
    }

  // 登录：对接真实后端
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await ApiService.login(
        username: username,
        password: password,
      );

      if (result['success'] == true) {
        // 登录成功，解析 data 里的用户信息
        final data = result['data'];
        _currentUser = User(
          id:  data['user_id'] ?? '',
          username: data['username'] ?? username,
          email: data['email'] ??'',
          // 其他字段根据你的 User 模型补充
        );
        _isLoggedIn = true;
        return true;
      } else {
        _errorMessage = result['message'] ?? '登录失败';
        return false;
      }
    } catch (e) {
      _errorMessage = '登录异常: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 注册：对接真实后端
  Future<bool> register(String username, String password, String email) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await ApiService.register(
        username: username,
        password: password,
        email: email,
      );

      if (result['success'] == true) {
        // 注册成功，可选择自动登录
        final data = result['data'];
        _currentUser = User(
          id: data['id'] ?? '',
          username: data['username'] ?? username,
          email: data['email'] ?? email,
        );
        _isLoggedIn = true;
        return true;
      } else {
        _errorMessage = result['message'] ?? '注册失败';
        return false;
      }
    } catch (e) {
      _errorMessage = '注册异常: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 退出登录
  Future<void> logout() async {
    await ApiService.clearAuth();
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
  // // 注册
  // Future<bool> register({
  //   required String email,
  //   required String phone,
  //   required String password,
  // }) async {
  //   // TODO: 调用后端注册API
  //   // 模拟注册成功
  //   if (email.isNotEmpty && phone.isNotEmpty && password.isNotEmpty) {
  //     _currentUser = User(
  //       id: DateTime.now().toString(),
  //       username: email.split('@')[0],
  //       email: email,
  //       phone: phone,
  //       nickname: '新用户',
  //       level: 1,
  //       isVip: false,
  //     );
  //     _isLoggedIn = true;
  //     notifyListeners();
  //     return true;
  //   }
  //   return false;
  // }

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