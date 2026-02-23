import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

// 评价模型类
class Review {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String shopName;
  final String shopType;
  final String location;
  final double rating;
  final String content;
  final List<String> images;
  final DateTime visitTime;
  final DateTime createTime;
  
  // 可修改的字段
  int likeCount;
  int commentCount;
  int reviewCount;
  bool isLiked;
  final List<String> tags;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.shopName,
    required this.shopType,
    required this.location,
    required this.rating,
    required this.content,
    required this.images,
    required this.visitTime,
    required this.createTime,
    this.likeCount = 0,
    this.commentCount = 0,
    this.reviewCount = 0,
    this.isLiked = false,
    this.tags = const [],
  });
}

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // 搜索控制器
  final TextEditingController _searchController = TextEditingController();
  
  // 模拟数据 - 大众点评风格评价
  final List<Review> _reviews = [
    Review(
      id: '1',
      userId: 'u1',
      userName: '美食侦探小王',
      userAvatar: 'https://picsum.photos/100/100?random=201',
      shopName: '老通城豆皮',
      shopType: '小吃面食',
      location: '吉庆街店',
      rating: 4.5,
      content: '武汉老字号！三鲜豆皮外酥里嫩，糯米软糯，配料丰富。早上7点就开始排队，一定要早点来。蛋酒也很正宗。',
      images: [
        'https://picsum.photos/400/300?random=21',
        'https://picsum.photos/400/300?random=22',
      ],
      visitTime: DateTime.now(),
      createTime: DateTime.now(),
      likeCount: 89,
      commentCount: 12,
      reviewCount: 56,
      isLiked: false,
      tags: ['老字号', '早餐', '排队王'],
    ),
    Review(
      id: '2',
      userId: 'u2',
      userName: '酒店体验官',
      userAvatar: 'https://picsum.photos/100/100?random=202',
      shopName: '武汉光谷凯悦酒店',
      shopType: '豪华酒店',
      location: '洪山区',
      rating: 4.8,
      content: '服务态度非常好，大堂有淡淡的香氛。房间视野开阔，能看到东湖。早餐品种丰富，热干面是现煮的。',
      images: [
        'https://picsum.photos/400/300?random=23',
        'https://picsum.photos/400/300?random=24',
        'https://picsum.photos/400/300?random=25',
      ],
      visitTime: DateTime.now(),
      createTime: DateTime.now(),
      likeCount: 156,
      commentCount: 23,
      reviewCount: 89,
      isLiked: true,
      tags: ['服务好', '风景佳', '早餐赞'],
    ),
    Review(
      id: '3',
      userId: 'u3',
      userName: '景区评论员',
      userAvatar: 'https://picsum.photos/100/100?random=203',
      shopName: '黄鹤楼',
      shopType: '5A景区',
      location: '武昌区',
      rating: 4.7,
      content: '武汉地标，必打卡。建议下午4点后入园，夕阳下的黄鹤楼特别美。夜场有灯光秀，很震撼。',
      images: [
        'https://picsum.photos/400/300?random=26',
      ],
      visitTime: DateTime.now(),
      createTime: DateTime.now(),
      likeCount: 234,
      commentCount: 45,
      reviewCount: 123,
      isLiked: false,
      tags: ['地标', '夜景', '必去'],
    ),
    Review(
      id: '4',
      userId: 'u4',
      userName: '吃货小分队',
      userAvatar: 'https://picsum.photos/100/100?random=204',
      shopName: '夏氏砂锅',
      shopType: '湖北菜',
      location: '万松园',
      rating: 4.6,
      content: '武汉必吃榜！莲藕排骨汤很鲜甜，藕粉糯拉丝。牛三鲜砂锅够味，价格实惠，两个人200能吃很饱。',
      images: [
        'https://picsum.photos/400/300?random=27',
        'https://picsum.photos/400/300?random=28',
        'https://picsum.photos/400/300?random=29',
      ],
      visitTime: DateTime.now(),
      createTime: DateTime.now(),
      likeCount: 312,
      commentCount: 56,
      reviewCount: 167,
      isLiked: false,
      tags: ['必吃榜', '湖北菜', '砂锅'],
    ),
    Review(
      id: '5',
      userId: 'u5',
      userName: '民宿控',
      userAvatar: 'https://picsum.photos/100/100?random=205',
      shopName: '隐舍民宿',
      shopType: '民宿',
      location: '昙华林',
      rating: 4.9,
      content: '藏在昙华林的宝藏民宿！每个房间都有不同的主题，我住的"樱花阁"有榻榻米和投影仪。老板很热情，会推荐周边小众景点。',
      images: [
        'https://picsum.photos/400/300?random=30',
        'https://picsum.photos/400/300?random=31',
        'https://picsum.photos/400/300?random=32',
        'https://picsum.photos/400/300?random=33',
      ],
      visitTime: DateTime.now(),
      createTime: DateTime.now(),
      likeCount: 178,
      commentCount: 34,
      reviewCount: 92,
      isLiked: true,
      tags: ['设计感', '服务热情', '昙华林'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeService>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('大众点评 · 武汉站'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // 搜索栏
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '搜索景点、酒店、美食...',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search, 
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.filter_list,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                              onPressed: _showFilterDialog,
                            ),
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              // 分类Tab
              TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFFFF8200),
                labelColor: const Color(0xFFFF8200),
                unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                tabs: const [
                  Tab(text: '全部'),
                  Tab(text: '美食'),
                  Tab(text: '酒店'),
                  Tab(text: '景点'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReviewList(isDark, _reviews),
          _buildReviewList(isDark, _reviews.where((r) => r.shopType.contains('美食') || r.shopType.contains('小吃')).toList()),
          _buildReviewList(isDark, _reviews.where((r) => r.shopType.contains('酒店') || r.shopType.contains('民宿')).toList()),
          _buildReviewList(isDark, _reviews.where((r) => r.shopType.contains('景区')).toList()),
        ],
      ),
    );
  }

  // 构建评价列表
  Widget _buildReviewList(bool isDark, List<Review> reviews) {
    // 搜索过滤
    final filteredReviews = reviews.where((review) {
      if (_searchController.text.isEmpty) return true;
      final query = _searchController.text.toLowerCase();
      return review.shopName.toLowerCase().contains(query) ||
             review.location.toLowerCase().contains(query) ||
             review.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();

    if (filteredReviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '未找到相关评价',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filteredReviews.length,
      itemBuilder: (context, index) {
        final review = filteredReviews[index];
        return _buildReviewCard(review, isDark);
      },
    );
  }

  // 构建评分星星
  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Color(0xFFFF8200), size: 16);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: Color(0xFFFF8200), size: 16);
        } else {
          return const Icon(Icons.star_border, color: Color(0xFFFF8200), size: 16);
        }
      }),
    );
  }

  // 构建评价卡片
  Widget _buildReviewCard(Review review, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
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
                  backgroundImage: NetworkImage(review.userAvatar),
                  radius: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '点评 ${review.reviewCount}条 · 粉丝 ${review.likeCount}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // 评分
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8200).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildRatingStars(review.rating),
                      const SizedBox(width: 4),
                      Text(
                        review.rating.toString(),
                        style: const TextStyle(
                          color: Color(0xFFFF8200),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 商家信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    review.shopType,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.shopName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        review.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 评价图片
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: review.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(review.images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          
          // 评价内容
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标签
                Wrap(
                  spacing: 8,
                  children: review.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8200).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFF8200),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  review.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_formatDate(review.visitTime)} 到店 · 点评于${_formatDate(review.createTime)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // 互动栏
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildReviewAction(
                  icon: review.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: review.isLiked ? Colors.red : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  count: review.likeCount,
                  onTap: () {
                    setState(() {
                      review.isLiked = !review.isLiked;
                      if (review.isLiked) {
                        review.likeCount++;
                      } else {
                        review.likeCount--;
                      }
                    });
                  },
                ),
                const SizedBox(width: 20),
                _buildReviewAction(
                  icon: Icons.comment_outlined,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  count: review.commentCount,
                  onTap: () => _showCommentDialog(context, review, isDark),
                ),
                const SizedBox(width: 20),
                _buildReviewAction(
                  icon: Icons.share_outlined,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  count: null,
                  onTap: () => _showShareDialog(context, isDark),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _writeReview(review),
                  child: const Text('写点评'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建互动按钮
  Widget _buildReviewAction({
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
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ],
      ),
    );
  }

  // 显示筛选对话框
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('筛选', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('评分', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip('全部', true),
                  _buildFilterChip('3星以上', false),
                  _buildFilterChip('4星以上', false),
                ],
              ),
              const SizedBox(height: 16),
              const Text('排序', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip('最新', true),
                  _buildFilterChip('热门', false),
                  _buildFilterChip('评分最高', false),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8200),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('确认', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 构建筛选标签
  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (value) {},
      backgroundColor: Colors.grey.shade100,
      selectedColor: const Color(0xFFFF8200).withOpacity(0.2),
      checkmarkColor: const Color(0xFFFF8200),
    );
  }

  // 显示评论对话框
  void _showCommentDialog(BuildContext context, Review review, bool isDark) {
    final TextEditingController commentController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '写评论',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    backgroundImage: NetworkImage(review.userAvatar),
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(review.userName),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '写下你的评论...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('评论已发送')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8200),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('发送'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 显示分享对话框
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
                _buildShareItem(Icons.photo_camera, '微博', isDark),
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

  // 构建分享项
  Widget _buildShareItem(IconData icon, String label, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已分享到$label')),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFFF8200)),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  // 写点评
  void _writeReview(Review review) {
    // 跳转到写点评页面
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('写点评：${review.shopName}')),
    );
  }

  // 格式化日期
  String _formatDate(DateTime date) {
    return '${date.month}月${date.day}日';
  }

  // 格式化数字
  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}w';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}