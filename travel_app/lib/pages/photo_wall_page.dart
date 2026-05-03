import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../models/post_model.dart';

class PhotoWallPage extends StatefulWidget {
  const PhotoWallPage({super.key});

  @override
  State<PhotoWallPage> createState() => _PhotoWallPageState();
}

class _PhotoWallPageState extends State<PhotoWallPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // ============ 青绿色系定义（与主页保持一致）============
  static const Color _primaryColor = Color(0xFF2E8B57); // 海松绿
  static const Color _secondaryColor = Color(0xFF66CDAA); // 中碧绿
  static const Color _accentColor = Color(0xFF40E0D0); // 青绿
  static const Color _darkGreen = Color(0xFF1B4D3E); // 深墨绿
  static const Color _lightGreen = Color(0xFF98FB98); // 淡绿
  static const Color _cloudWhite = Color(0xFFF0F8FF); // 云白
  static const Color _inkBlack = Color(0xFF2F4F4F); // 墨色
  static const Color _goldColor = Color(0xFFFFD700); // 金色
  
  // 模拟数据 - 小红书风格游记（全部改为英文）
  final List<Post> _posts = [
    Post(
      id: '1',
      userId: 'u1',
      userName: 'Travel Photographer Xiaoyu',
      userAvatar: 'https://picsum.photos/100/100?random=101',
      imageUrls: [
        'https://picsum.photos/400/500?random=1',
        'https://picsum.photos/400/500?random=2',
        'https://picsum.photos/400/500?random=3',
      ],
      title: '3 Days in Wuhan, the sunset at Yellow Crane Tower is amazing🌇',
      description: 'Finally arrived at the long-awaited Yellow Crane Tower! The light at 5 PM is perfect, golden sunlight shining on the tower feels like traveling back to the Tang Dynasty. Highly recommend coming in the evening, fewer people and better photos! 📸',
      location: 'Wuhan · Yellow Crane Tower',
      createTime: DateTime.now(),
      likeCount: 1234,
      commentCount: 89,
      favoriteCount: 56,
      isLiked: false,
      isFavorited: false,
      tags: ['Wuhan', 'Yellow Crane Tower', 'Sunset', 'Photography'],
    ),
    Post(
      id: '2',
      userId: 'u2',
      userName: 'Foodie Squad',
      userAvatar: 'https://picsum.photos/100/100?random=102',
      imageUrls: [
        'https://picsum.photos/400/500?random=4',
        'https://picsum.photos/400/500?random=5',
      ],
      title: 'Breakfast on Liangdao Street! Wuhan breakfast is the best! 🥟',
      description: 'The capital of carbs lives up to its name! Hot dry noodles, three delicacies tofu skin, egg wine, fish noodle soup... Every shop has long lines, but worth it! Highly recommend Chef Zhao\'s oil cake stuffed with shumai, amazing!',
      location: 'Wuhan · Liangdao Street',
      createTime: DateTime.now(),
      likeCount: 2341,
      commentCount: 156,
      favoriteCount: 89,
      isLiked: true,
      isFavorited: false,
      tags: ['Wuhan Food', 'Breakfast', 'Carbs'],
    ),
    Post(
      id: '3',
      userId: 'u3',
      userName: 'Hanfu Experience',
      userAvatar: 'https://picsum.photos/100/100?random=103',
      imageUrls: [
        'https://picsum.photos/400/500?random=6',
        'https://picsum.photos/400/500?random=7',
        'https://picsum.photos/400/500?random=8',
        'https://picsum.photos/400/500?random=9',
      ],
      title: 'East Lake Cherry Garden｜Wearing Hanfu to See Flowers🌸',
      description: 'March at East Lake Cherry Garden, spring colors beyond the garden wall. Free entry with Hanfu! Recommended white and pink Hanfu, super photogenic!',
      location: 'Wuhan · East Lake Cherry Garden',
      createTime: DateTime.now(),
      likeCount: 3456,
      commentCount: 234,
      favoriteCount: 123,
      isLiked: false,
      isFavorited: true,
      tags: ['Hanfu', 'East Lake', 'Cherry Blossoms', 'Photography'],
    ),
    Post(
      id: '4',
      userId: 'u4',
      userName: 'Museum Lover',
      userAvatar: 'https://picsum.photos/100/100?random=104',
      imageUrls: [
        'https://picsum.photos/400/500?random=10',
        'https://picsum.photos/400/500?random=11',
      ],
      title: 'Hubei Provincial Museum｜Real Shot of Goujian Sword🗡️',
      description: 'Finally saw the legendary Goujian Sword! Still sharp after 2000 years, cold gleam shining. Recommend going in the morning, fewer people. Remember to book in advance!',
      location: 'Wuhan · Hubei Provincial Museum',
      createTime: DateTime.now(),
      likeCount: 4567,
      commentCount: 178,
      favoriteCount: 234,
      isLiked: false,
      isFavorited: false,
      tags: ['Museum', 'Goujian Sword', 'History'],
    ),
    Post(
      id: '5',
      userId: 'u5',
      userName: 'B&B Tester',
      userAvatar: 'https://picsum.photos/100/100?random=105',
      imageUrls: [
        'https://picsum.photos/400/500?random=12',
        'https://picsum.photos/400/500?random=13',
        'https://picsum.photos/400/500?random=14',
      ],
      title: 'Wuhan B&B｜A Café in a Heritage Building☕',
      description: 'This B&B on Li Huangpi Road is amazing! Renovated from a century-old building, café on first floor, guest rooms on second. Staying here lets you feel Wuhan\'s artistic vibe.',
      location: 'Wuhan · Li Huangpi Road',
      createTime: DateTime.now(),
      likeCount: 1678,
      commentCount: 98,
      favoriteCount: 67,
      isLiked: true,
      isFavorited: true,
      tags: ['B&B', 'Cafe', 'Li Huangpi Road'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeService>(context).isDarkMode;
    final texts = Provider.of<LanguageService>(context).currentLanguage;

    return Scaffold(
      backgroundColor: _cloudWhite,
      appBar: AppBar(
        title: Text(
          texts['photoWallTitle'] ?? 'Travel Diary',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: [
            Tab(text: texts['recommended'] ?? 'Recommended'),
            Tab(text: texts['latest'] ?? 'Latest'),
            Tab(text: texts['following'] ?? 'Following'),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 背景装饰
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/tree_pattern.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      _primaryColor.withOpacity(0.2),
                      BlendMode.overlay,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 主内容
          TabBarView(
            controller: _tabController,
            children: [
              _buildPostList(isDark, texts),
              _buildPostList(isDark, texts),
              _buildEmptyFollow(isDark, texts),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostList(bool isDark, Map<String, String> texts) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return _buildPostCard(post, isDark, texts);
      },
    );
  }

  Widget _buildPostCard(Post post, bool isDark, Map<String, String> texts) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryColor.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _primaryColor,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(post.userAvatar),
                    radius: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: _darkGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: _primaryColor.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            post.location,
                            style: TextStyle(
                              fontSize: 11,
                              color: _primaryColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: _primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '+ Follow',
                    style: TextStyle(
                      fontSize: 10,
                      color: _primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 图片瀑布流
          _buildImageGrid(post.imageUrls),
          
          // 标题和内容
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: _darkGreen.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          
          // 标签
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: post.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      fontSize: 12,
                      color: _primaryColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // 互动按钮
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildActionButton(
                  icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked ? Colors.red : _primaryColor,
                  count: post.likeCount,
                  onTap: () {
                    setState(() {
                      post.isLiked = !post.isLiked;
                      if (post.isLiked) {
                        post.likeCount++;
                      } else {
                        post.likeCount--;
                      }
                    });
                  },
                ),
                const SizedBox(width: 20),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  color: _primaryColor,
                  count: post.commentCount,
                  onTap: () => _showCommentDialog(context, post, isDark, texts),
                ),
                const SizedBox(width: 20),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  color: _primaryColor,
                  count: null,
                  onTap: () => _showShareDialog(context, isDark, texts),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<String> imageUrls) {
    if (imageUrls.length == 1) {
      return Container(
        height: 300,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrls[0],
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (imageUrls.length == 2) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrls[0], fit: BoxFit.cover, height: 200),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrls[1], fit: BoxFit.cover, height: 200),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Container(
              width: 200,
              margin: EdgeInsets.only(right: index == imageUrls.length - 1 ? 0 : 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    int? count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          if (count != null) ...[
            const SizedBox(width: 4),
            Text(
              _formatCount(count),
              style: TextStyle(fontSize: 12, color: _darkGreen),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyFollow(bool isDark, Map<String, String> texts) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: _primaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            texts['noData'] ?? 'No followed users yet',
            style: TextStyle(
              fontSize: 16,
              color: _darkGreen,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(texts['recommended'] ?? 'Discover Interesting People'),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}w';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  void _showCommentDialog(BuildContext context, Post post, bool isDark, Map<String, String> texts) {
    final TextEditingController commentController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                _cloudWhite,
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    texts['writeComment'] ?? 'Write Comment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _darkGreen),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(post.userAvatar),
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(post.userName, style: TextStyle(color: _darkGreen)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: texts['writeComment'] ?? 'Write your comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _primaryColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSnackBar(texts['comment'] ?? 'Comment sent');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    texts['send'] ?? 'Send',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context, bool isDark, Map<String, String> texts) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              _cloudWhite,
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              texts['share'] ?? 'Share to',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _darkGreen),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareItem(Icons.wechat, 'WeChat', texts),
                _buildShareItem(Icons.people, 'Moments', texts),
                _buildShareItem(Icons.photo_camera, 'Weibo', texts),
                _buildShareItem(Icons.link, 'Copy Link', texts),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                texts['cancel'] ?? 'Cancel',
                style: TextStyle(color: _primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareItem(IconData icon, String label, Map<String, String> texts) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showSnackBar('${texts['share'] ?? 'Shared to'} $label');
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _primaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: _darkGreen),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _primaryColor,
      ),
    );
  }
}