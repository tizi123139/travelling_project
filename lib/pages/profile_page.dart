// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 模拟用户数据
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    final userService = Provider.of<UserService>(context, listen: false);
    if (userService.isLoggedIn && userService.currentUser != null) {
      _currentUser = userService.currentUser!;
    } else {
      // 默认游客数据
      _currentUser = User(
        id: 'guest',
        username: '游客',
        email: '请先登录',
        avatar: 'https://picsum.photos/200/200?random=101',
        nickname: '游客',
        level: 0,
        isVip: false,
        browseHistory: [],
        favorites: [],
        searchHistory: [],
        watchLater: [],
      );
    }
  }

  // ============ 登录弹窗 ============
  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('登录/注册'),
        content: const Text('请先登录后访问此功能'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 关闭弹窗
              Navigator.pushNamed(context, '/login').then((value) {
                if (value == true) {
                  // 登录成功，刷新页面
                  setState(() {
                    final userService = Provider.of<UserService>(context, listen: false);
                    if (userService.isLoggedIn && userService.currentUser != null) {
                      _currentUser = userService.currentUser!;
                    }
                  });
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text('去登录'),
          ),
        ],
      ),
    );
  }

  // ============ 退出登录弹窗 ============
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final userService = Provider.of<UserService>(context, listen: false);
              userService.logout();
              Navigator.pop(context);
              Navigator.pop(context); // 返回上一页
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }

  // ============ 显示历史记录弹窗 ============
  void _showHistoryDialog(BuildContext context, bool isDark, List<String> items, String title) {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('暂无$title'),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  items[index],
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                  onPressed: () {
                    setState(() {
                      items.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeService>(context).isDarkMode;
    final userService = Provider.of<UserService>(context);

    // 如果用户登录状态改变，更新数据
    if (userService.isLoggedIn && userService.currentUser != null) {
      _currentUser = userService.currentUser!;
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('个人中心'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2196F3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (userService.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _showLogoutDialog(context),
              tooltip: '退出登录',
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 用户信息卡片
            _buildUserInfoCard(isDark, userService),
            
            // VIP状态卡片
            _buildVipStatusCard(isDark, userService),
            
            // 统计数据
            _buildStatsGrid(isDark, userService),
            
            // 功能列表
            _buildFunctionList(isDark, userService),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(bool isDark, UserService userService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 头像
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: userService.isLoggedIn 
                        ? const Color(0xFF2196F3)
                        : Colors.grey,
                    width: 3,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(_currentUser.avatar),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (userService.isLoggedIn)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: 修改头像
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2196F3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      userService.isLoggedIn 
                          ? (_currentUser.nickname ?? _currentUser.username)
                          : '游客',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (userService.isLoggedIn && _currentUser.level > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              'Lv.${_currentUser.level}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  userService.isLoggedIn ? _currentUser.email : '点击头像登录',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                if (userService.isLoggedIn && _currentUser.phone != null)
                  Text(
                    _currentUser.phone!,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                if (!userService.isLoggedIn)
                  GestureDetector(
                    onTap: () => _showLoginDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '立即登录',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipStatusCard(bool isDark, UserService userService) {
    if (!userService.isLoggedIn) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade400, Colors.grey.shade600],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VIP会员',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '登录后查看VIP权益',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showLoginDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '登录',
                  style: TextStyle(
                    color: Color(0xFFFFA500),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA500).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VIP会员',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentUser.isVip
                      ? '有效期至：${_currentUser.vipExpireTime?.year}年${_currentUser.vipExpireTime?.month}月${_currentUser.vipExpireTime?.day}日'
                      : '开通VIP享更多权益',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // 跳转到VIP充值页面
              Navigator.pushNamed(context, '/vip_recharge');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _currentUser.isVip ? '续费' : '立即开通',
                style: const TextStyle(
                  color: Color(0xFFFFA500),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isDark, UserService userService) {
    final stats = [
      {'icon': Icons.history, 'label': '浏览记录', 'count': _currentUser.browseHistory.length},
      {'icon': Icons.favorite, 'label': '我的收藏', 'count': _currentUser.favorites.length},
      {'icon': Icons.search, 'label': '历史询问', 'count': _currentUser.searchHistory.length},
      {'icon': Icons.watch_later, 'label': '稍后再看', 'count': _currentUser.watchLater.length},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.8,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (!userService.isLoggedIn) {
                _showLoginDialog(context);
                return;
              }
              
              String title = stats[index]['label'] as String;
              List<String> items = [];
              switch (title) {
                case '浏览记录':
                  items = _currentUser.browseHistory;
                  break;
                case '我的收藏':
                  items = _currentUser.favorites;
                  break;
                case '历史询问':
                  items = _currentUser.searchHistory;
                  break;
                case '稍后再看':
                  items = _currentUser.watchLater;
                  break;
              }
              _showHistoryDialog(context, isDark, items, title);
            },
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    stats[index]['icon'] as IconData,
                    color: const Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stats[index]['count'].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  stats[index]['label'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFunctionList(bool isDark, UserService userService) {
    final functions = [
      {'icon': Icons.history, 'title': '浏览记录', 'color': Colors.blue},
      {'icon': Icons.favorite, 'title': '我的收藏', 'color': Colors.red},
      {'icon': Icons.search, 'title': '历史询问', 'color': Colors.green},
      {'icon': Icons.watch_later, 'title': '稍后再看', 'color': Colors.orange},
      {'icon': Icons.explore, 'title': '可能感兴趣的地方', 'color': Colors.purple},
      {'icon': Icons.workspace_premium, 'title': 'VIP充值', 'color': Colors.amber},
      {'icon': Icons.settings, 'title': '设置', 'color': Colors.grey},
      {'icon': Icons.help, 'title': '帮助与反馈', 'color': Colors.teal},
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: functions.length,
        itemBuilder: (context, index) {
          final func = functions[index];
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (func['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                func['icon'] as IconData,
                color: func['color'] as Color,
                size: 20,
              ),
            ),
            title: Text(
              func['title'] as String,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            onTap: () {
              // 处理点击事件
              if (!userService.isLoggedIn && func['title'] != '帮助与反馈') {
                _showLoginDialog(context);
                return;
              }

              switch (func['title']) {
                case '浏览记录':
                  _showHistoryDialog(context, isDark, _currentUser.browseHistory, '浏览记录');
                  break;
                case '我的收藏':
                  _showHistoryDialog(context, isDark, _currentUser.favorites, '我的收藏');
                  break;
                case '历史询问':
                  _showHistoryDialog(context, isDark, _currentUser.searchHistory, '历史询问');
                  break;
                case '稍后再看':
                  _showHistoryDialog(context, isDark, _currentUser.watchLater, '稍后再看');
                  break;
                case 'VIP充值':
                  Navigator.pushNamed(context, '/vip_recharge');
                  break;
                case '可能感兴趣的地方':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('功能开发中...')),
                  );
                  break;
                case '设置':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('功能开发中...')),
                  );
                  break;
                case '帮助与反馈':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('功能开发中...')),
                  );
                  break;
              }
            },
          );
        },
      ),
    );
  }
}