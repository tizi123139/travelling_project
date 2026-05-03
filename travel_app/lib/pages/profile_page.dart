// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/user_service.dart';
import '../services/message_service.dart';
import '../services/language_service.dart';  // 添加语言服务
import '../models/user_model.dart';
import '../models/message_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = User(
      id: '1',
      username: 'traveler123',
      email: 'traveler@example.com',
      phone: '13800138000',
      nickname: '旅行达人',
      avatar: 'https://picsum.photos/200/200?random=101',
      level: 5,
      isVip: true,
      vipExpireTime: DateTime.now().add(const Duration(days: 30)),
      browseHistory: ['黄鹤楼', '东湖', '武汉大学', '湖北省博物馆'],
      favorites: ['黄鹤楼', '东湖樱园', '粮道街美食'],
      searchHistory: ['武汉美食', '武汉三日游', '武汉住宿'],
      watchLater: ['归元禅寺', '晴川阁', '汉口江滩'],
    );

    final messageService = Provider.of<MessageService>(context, listen: false);
    messageService.loadMockData();
  }

  // ============ 显示设置弹窗 ============
  void _showSettingsDialog(BuildContext context, bool isDark) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final texts = languageService.currentLanguage;
    
    final TextEditingController _nicknameController = TextEditingController(
      text: _currentUser.nickname ?? _currentUser.username,
    );
    String _selectedAvatar = _currentUser.avatar;
    
    final List<String> avatarOptions = [
      'https://picsum.photos/200/200?random=101',
      'https://picsum.photos/200/200?random=102',
      'https://picsum.photos/200/200?random=103',
      'https://picsum.photos/200/200?random=104',
      'https://picsum.photos/200/200?random=105',
      'https://picsum.photos/200/200?random=106',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      texts['editProfile'] ?? '编辑资料',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                
                const Divider(),
                
                // 头像设置
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    texts['changeAvatar'] ?? '更换头像',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: avatarOptions.length,
                    itemBuilder: (context, index) {
                      final avatarUrl = avatarOptions[index];
                      final isSelected = _selectedAvatar == avatarUrl;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAvatar = avatarUrl;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: Stack(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected 
                                        ? const Color(0xFF2E8B57)
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(avatarUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2E8B57),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 昵称修改
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    texts['changeNickname'] ?? '修改昵称',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    ),
                  ),
                  child: TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      hintText: texts['changeNickname'] ?? '请输入昵称',
                      prefixIcon: const Icon(Icons.person_outline, size: 18),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 保存按钮
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {
                      final userService = Provider.of<UserService>(context, listen: false);
                      userService.updateUser(
                        nickname: _nicknameController.text,
                        avatar: _selectedAvatar,
                      );
                      setState(() {
                        _currentUser = userService.currentUser!;
                      });
                      Navigator.pop(context);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(texts['saveChanges'] ?? '个人信息已更新'),
                          backgroundColor: const Color(0xFF2E8B57),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      side: const BorderSide(color: Colors.grey, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      texts['saveChanges'] ?? '保存修改',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ 显示关注/粉丝列表 ============
  void _showFollowList(BuildContext context, bool isDark, String type) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final texts = languageService.currentLanguage;
    final messageService = Provider.of<MessageService>(context, listen: false);
    final List<UserRelation> list = type == 'followings' 
        ? messageService.followings 
        : messageService.followers;
    final String title = type == 'followings' 
        ? (texts['follow'] ?? '我的关注') 
        : (texts['followers'] ?? '我的粉丝');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            type == 'followings' 
                                ? (texts['noFollow'] ?? '还没有关注的人')
                                : (texts['noFollowers'] ?? '还没有粉丝'),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final user = list[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar),
                          ),
                          title: Text(user.nickname),
                          subtitle: Text('@${user.username}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (type == 'followers' && !user.isFollowed)
                                OutlinedButton(
                                  onPressed: () {
                                    messageService.followUser(user);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${texts['follow'] ?? '已关注'} ${user.nickname}'),
                                        backgroundColor: const Color(0xFF2E8B57),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF2E8B57),
                                  ),
                                  child: Text(texts['follow'] ?? '回关'),
                                ),
                              IconButton(
                                icon: const Icon(Icons.message_outlined),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showChatDialog(context, isDark, user);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ 显示私聊对话框 ============
  void _showChatDialog(BuildContext context, bool isDark, UserRelation user) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final texts = languageService.currentLanguage;
    final TextEditingController _messageController = TextEditingController();
    final messageService = Provider.of<MessageService>(context, listen: false);
    final chatHistory = messageService.getChatHistory(user.userId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 标题
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.nickname,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${user.username}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              
              // 聊天记录
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    final msg = chatHistory.reversed.toList()[index];
                    final bool isMe = msg.fromUserId == 'current_user';
                    
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe 
                              ? const Color(0xFF2E8B57)
                              : (isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg.content,
                          style: TextStyle(
                            color: isMe ? Colors.white : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // 输入框
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: texts['messageHint'] ?? '输入消息...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E8B57),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          messageService.sendMessage(
                            fromUserId: 'current_user',
                            fromUserName: _currentUser.nickname ?? '我',
                            fromUserAvatar: _currentUser.avatar,
                            toUserId: user.userId,
                            content: _messageController.text,
                          );
                          _messageController.clear();
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ 显示历史记录弹窗 ============
  void _showHistoryDialog(BuildContext context, bool isDark, List<String> items, String titleKey) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final texts = languageService.currentLanguage;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(texts[titleKey] ?? titleKey),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
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
            child: Text(texts['cancel'] ?? '关闭'),
          ),
        ],
      ),
    );
  }

  // ============ 构建关注统计项 ============
  Widget _buildFollowStat({
    required String label,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final messageService = Provider.of<MessageService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;
    final unreadCount = messageService.getUnreadCount('current_user');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(texts['profile'] ?? '个人中心'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2E8B57),
        elevation: 0,
        actions: [
          // 消息图标（带未读红点）
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.message_outlined),
                onPressed: () {
                  _showFollowList(context, isDark, 'messages');
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 用户信息卡片
          _buildUserInfoCard(isDark, texts),
          
          // VIP状态卡片
          _buildVipStatusCard(isDark, texts),
          
          // 统计数据网格
          _buildStatsGrid(isDark, texts),
          
          // 功能列表
          Expanded(
            child: _buildFunctionList(isDark, texts),
          ),
        ],
      ),
    );
  }

  // ============ 用户信息卡片 ============
  Widget _buildUserInfoCard(bool isDark, Map<String, String> texts) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 头像
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF2E8B57),
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(_currentUser.avatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // 齿轮设置按钮
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showSettingsDialog(context, isDark),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E8B57),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              
              // 用户信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _currentUser.nickname ?? _currentUser.username,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.white, size: 10),
                              const SizedBox(width: 2),
                              Text(
                                'Lv.${_currentUser.level}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _currentUser.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _currentUser.phone ?? (texts['noPhone'] ?? '未绑定手机'),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 关注/粉丝/私聊统计
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFollowStat(
                label: texts['follow'] ?? '关注',
                count: 128,
                onTap: () => _showFollowList(context, isDark, 'followings'),
              ),
              _buildFollowStat(
                label: texts['followers'] ?? '粉丝',
                count: 256,
                onTap: () => _showFollowList(context, isDark, 'followers'),
              ),
              _buildFollowStat(
                label: texts['messages'] ?? '私信',
                count: 12,
                onTap: () => _showFollowList(context, isDark, 'messages'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============ VIP状态卡片 ============
  Widget _buildVipStatusCard(bool isDark, Map<String, String> texts) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/vip_recharge');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFA500).withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    texts['vipMember'] ?? 'VIP会员',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _currentUser.isVip
                        ? '${texts['validUntil'] ?? '有效期至'}：${_currentUser.vipExpireTime?.year}年${_currentUser.vipExpireTime?.month}月${_currentUser.vipExpireTime?.day}日'
                        : (texts['vipBenefits'] ?? '开通VIP享更多权益'),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _currentUser.isVip 
                    ? (texts['alreadyVip'] ?? '已开通')
                    : (texts['openVip'] ?? '立即开通'),
                style: const TextStyle(
                  color: Color(0xFFFFA500),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ 统计数据网格 ============
  Widget _buildStatsGrid(bool isDark, Map<String, String> texts) {
    final stats = [
      {'icon': Icons.history, 'label': 'browseHistory', 'count': _currentUser.browseHistory.length},
      {'icon': Icons.favorite, 'label': 'myFavorites', 'count': _currentUser.favorites.length},
      {'icon': Icons.search, 'label': 'searchHistory', 'count': _currentUser.searchHistory.length},
      {'icon': Icons.watch_later, 'label': 'watchLater', 'count': _currentUser.watchLater.length},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((stat) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                _showHistoryDialog(context, isDark, 
                  stat['label'] == 'browseHistory' ? _currentUser.browseHistory :
                  stat['label'] == 'myFavorites' ? _currentUser.favorites :
                  stat['label'] == 'searchHistory' ? _currentUser.searchHistory :
                  _currentUser.watchLater,
                  stat['label'] as String,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E8B57).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      stat['icon'] as IconData,
                      color: const Color(0xFF2E8B57),
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat['count'].toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    texts[stat['label']] ?? stat['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============ 功能列表 ============
  Widget _buildFunctionList(bool isDark, Map<String, String> texts) {
    final functions = [
      {'icon': Icons.history, 'title': 'browseHistory', 'color': Colors.blue},
      {'icon': Icons.favorite, 'title': 'myFavorites', 'color': Colors.red},
      {'icon': Icons.search, 'title': 'searchHistory', 'color': Colors.green},
      {'icon': Icons.watch_later, 'title': 'watchLater', 'color': Colors.orange},
      {'icon': Icons.explore, 'title': 'interested', 'color': Colors.purple},
      {'icon': Icons.workspace_premium, 'title': 'vipRecharge', 'color': Colors.amber},
      {'icon': Icons.settings, 'title': 'settings', 'color': Colors.grey},
      {'icon': Icons.help, 'title': 'help', 'color': Colors.teal},
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: functions.length,
        itemBuilder: (context, index) {
          final func = functions[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: (func['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                func['icon'] as IconData,
                color: func['color'] as Color,
                size: 16,
              ),
            ),
            title: Text(
              texts[func['title']] ?? func['title'] as String,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            onTap: () {
              if (func['title'] == 'vipRecharge') {
                Navigator.pushNamed(context, '/vip_recharge');
              } else if (func['title'] == 'browseHistory') {
                _showHistoryDialog(context, isDark, _currentUser.browseHistory, 'browseHistory');
              } else if (func['title'] == 'myFavorites') {
                _showHistoryDialog(context, isDark, _currentUser.favorites, 'myFavorites');
              } else if (func['title'] == 'searchHistory') {
                _showHistoryDialog(context, isDark, _currentUser.searchHistory, 'searchHistory');
              } else if (func['title'] == 'watchLater') {
                _showHistoryDialog(context, isDark, _currentUser.watchLater, 'watchLater');
              } else if (func['title'] == 'settings') {
                _showSettingsDialog(context, isDark);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${texts['comingSoon'] ?? '功能开发中'}'),
                    backgroundColor: const Color(0xFF2E8B57),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}