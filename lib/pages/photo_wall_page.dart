import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../models/post_model.dart';
import '../pages/profile_page.dart';

class PhotoWallPage extends StatefulWidget {
  const PhotoWallPage({super.key});

  @override
  State<PhotoWallPage> createState() => _PhotoWallPageState();
}

class _PhotoWallPageState extends State<PhotoWallPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // 模拟数据 - 小红书风格游记
  final List<Post> _posts = [
    Post(
      id: '1',
      userId: 'u1',
      userName: '旅行摄影师小宇',
      userAvatar: 'https://picsum.photos/100/100?random=101',
      imageUrls: [
        'https://picsum.photos/400/500?random=1',
        'https://picsum.photos/400/500?random=2',
        'https://picsum.photos/400/500?random=3',
      ],
      title: '武汉三天两夜，黄鹤楼的日落太美了🌇',
      description: '终于来到心心念念的黄鹤楼！下午5点的光线刚刚好，金色的阳光洒在楼上，仿佛穿越回唐朝。推荐大家傍晚来，人少景美，随手一拍都是大片！📸',
      location: '武汉·黄鹤楼',
      createTime: DateTime.now(),
      likeCount: 1234,
      commentCount: 89,
      favoriteCount: 56,
      isLiked: false,
      isFavorited: false,
      tags: ['武汉', '黄鹤楼', '日落', '摄影'],
    ),
    Post(
      id: '2',
      userId: 'u2',
      userName: '吃货小分队',
      userAvatar: 'https://picsum.photos/100/100?random=102',
      imageUrls: [
        'https://picsum.photos/400/500?random=4',
        'https://picsum.photos/400/500?random=5',
      ],
      title: '粮道街过早！武汉早餐yyds！🥟',
      description: '碳水之都名不虚传！热干面、三鲜豆皮、蛋酒、糊汤粉...每家店都排长队，但值得！推荐赵师傅油饼包烧卖，绝了！',
      location: '武汉·粮道街',
      createTime: DateTime.now(),
      likeCount: 2341,
      commentCount: 156,
      favoriteCount: 89,
      isLiked: true,
      isFavorited: false,
      tags: ['武汉美食', '过早', '碳水炸弹'],
    ),
    Post(
      id: '3',
      userId: 'u3',
      userName: '汉服体验馆',
      userAvatar: 'https://picsum.photos/100/100?random=103',
      imageUrls: [
        'https://picsum.photos/400/500?random=6',
        'https://picsum.photos/400/500?random=7',
        'https://picsum.photos/400/500?random=8',
        'https://picsum.photos/400/500?random=9',
      ],
      title: '东湖樱园｜穿上汉服去赏花🌸',
      description: '三月东湖樱园，满园春色关不住。穿汉服免门票哦！推荐白色和粉色系的汉服，超级出片！',
      location: '武汉·东湖樱园',
      createTime: DateTime.now(),
      likeCount: 3456,
      commentCount: 234,
      favoriteCount: 123,
      isLiked: false,
      isFavorited: true,
      tags: ['汉服', '东湖', '樱花', '拍照'],
    ),
    Post(
      id: '4',
      userId: 'u4',
      userName: '博物馆爱好者',
      userAvatar: 'https://picsum.photos/100/100?random=104',
      imageUrls: [
        'https://picsum.photos/400/500?random=10',
        'https://picsum.photos/400/500?random=11',
      ],
      title: '湖北省博｜越王勾践剑实拍🗡️',
      description: '终于见到传说中的越王勾践剑！两千多年依然锋利，寒光凛凛。建议上午去，人少一点。记得提前预约！',
      location: '武汉·湖北省博物馆',
      createTime: DateTime.now(),
      likeCount: 4567,
      commentCount: 178,
      favoriteCount: 234,
      isLiked: false,
      isFavorited: false,
      tags: ['博物馆', '越王勾践剑', '历史'],
    ),
    Post(
      id: '5',
      userId: 'u5',
      userName: '民宿体验官',
      userAvatar: 'https://picsum.photos/100/100?random=105',
      imageUrls: [
        'https://picsum.photos/400/500?random=12',
        'https://picsum.photos/400/500?random=13',
        'https://picsum.photos/400/500?random=14',
      ],
      title: '武汉民宿｜藏在老洋房里的咖啡馆☕',
      description: '黎黄陂路这家民宿太有感觉了！百年老建筑改造，一楼是咖啡馆，二楼是客房。住在这里能感受到武汉的文艺气息。',
      location: '武汉·黎黄陂路',
      createTime: DateTime.now(),
      likeCount: 1678,
      commentCount: 98,
      favoriteCount: 67,
      isLiked: true,
      isFavorited: true,
      tags: ['民宿', '咖啡馆', '黎黄陂路'],
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

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('旅行日记'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF2196F3),
          labelColor: const Color(0xFF2196F3),
          unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          tabs: const [
            Tab(text: '推荐'),
            Tab(text: '最新'),
            Tab(text: '关注'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostList(isDark),
          _buildPostList(isDark),
          _buildEmptyFollow(isDark),
        ],
      ),
    );
  }

  Widget _buildPostList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return _buildPostCard(post, isDark);
      },
    );
  }

  Widget _buildPostCard(Post post, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                CircleAvatar(
                  backgroundImage: NetworkImage(post.userAvatar),
                  radius: 20,
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
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        post.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    post.isFavorited ? Icons.bookmark : Icons.bookmark_border,
                    color: post.isFavorited ? Colors.amber : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  ),
                  onPressed: () {
                    setState(() {
                      post.isFavorited = !post.isFavorited;
                      if (post.isFavorited) {
                        // 收藏到个人中心
                        _showSnackBar('已收藏');
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          
          // 图片瀑布流（小红书风格）
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
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
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
                return GestureDetector(
                  onTap: () {},
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF2196F3),
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
                  color: post.isLiked ? Colors.red : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
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
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  count: post.commentCount,
                  onTap: () => _showCommentDialog(context, post, isDark),
                ),
                const SizedBox(width: 20),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  count: null,
                  onTap: () => _showShareDialog(context, isDark),
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
        child: Image.network(
          imageUrls[0],
          fit: BoxFit.cover,
        ),
      );
    } else if (imageUrls.length == 2) {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 200,
              child: Image.network(imageUrls[0], fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Container(
              height: 200,
              child: Image.network(imageUrls[1], fit: BoxFit.cover),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Container(
              width: 200,
              margin: EdgeInsets.only(left: index == 0 ? 12 : 0, right: 4),
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
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
          Icon(icon, size: 20, color: color),
          if (count != null) ...[
            const SizedBox(width: 4),
            Text(
              _formatCount(count),
              style: TextStyle(fontSize: 13, color: color),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyFollow(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '还没有关注的人',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text('发现有趣的人'),
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

  void _showCommentDialog(BuildContext context, Post post, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '评论 (${post.commentCount})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text('用户123'),
                    subtitle: Text('拍得太美了！下次也要去！'),
                  ),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text('旅行达人'),
                    subtitle: Text('求攻略，求路线！'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '写评论...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('发送'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('分享到', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareItem(Icons.wechat, '微信', isDark),
                _buildShareItem(Icons.people, '朋友圈', isDark),
               _buildShareItem(Icons.camera_alt, '微博', isDark),
                _buildShareItem(Icons.link, '复制链接', isDark),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareItem(IconData icon, String label, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showSnackBar('已分享到$label');
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF2196F3)),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}