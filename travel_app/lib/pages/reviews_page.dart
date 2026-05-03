import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

// 评价模型类（保持不变）
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

class _ReviewsPageState extends State<ReviewsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // 搜索控制器
  final TextEditingController _searchController = TextEditingController();
  
  // ============ 青绿色系定义 ============
  static const Color _primaryColor = Color(0xFF2E8B57); // 海松绿
  static const Color _secondaryColor = Color(0xFF66CDAA); // 中碧绿
  static const Color _accentColor = Color(0xFF40E0D0); // 青绿
  static const Color _darkGreen = Color(0xFF1B4D3E); // 深墨绿
  static const Color _lightGreen = Color(0xFF98FB98); // 淡绿
  static const Color _cloudWhite = Color(0xFFF0F8FF); // 云白
  static const Color _inkBlack = Color(0xFF2F4F4F); // 墨色
  static const Color _treeBrown = Color(0xFF8B5A2B); // 椿树棕
  
  // 模拟数据 - 全部改为英文
  final List<Review> _reviews = [
    Review(
      id: '1',
      userId: 'u1',
      userName: 'Food Detective Wang',
      userAvatar: 'https://picsum.photos/100/100?random=201',
      shopName: 'Lao Tongcheng Bean Skin',
      shopType: 'Snacks',
      location: 'Jiqing Street Branch',
      rating: 4.5,
      content: 'Wuhan time-honored brand! Crispy outside and soft inside, glutinous rice is soft and rich in ingredients. The queue starts at 7 AM, come early. Egg wine is also authentic.',
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
      tags: ['Time-honored', 'Breakfast', 'Queue King'],
    ),
    Review(
      id: '2',
      userId: 'u2',
      userName: 'Hotel Expert',
      userAvatar: 'https://picsum.photos/100/100?random=202',
      shopName: 'Hyatt Regency Wuhan',
      shopType: 'Luxury Hotel',
      location: 'Hongshan District',
      rating: 4.8,
      content: 'Excellent service, subtle fragrance in the lobby. Rooms have a great view of East Lake. Breakfast variety is rich, hot dry noodles are freshly cooked.',
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
      tags: ['Great Service', 'Good View', 'Breakfast'],
    ),
    Review(
      id: '3',
      userId: 'u3',
      userName: 'Scenic Reviewer',
      userAvatar: 'https://picsum.photos/100/100?random=203',
      shopName: 'Yellow Crane Tower',
      shopType: '5A Scenic Spot',
      location: 'Wuchang District',
      rating: 4.7,
      content: 'Wuhan landmark, must-visit. Enter after 4 PM for beautiful sunset views. Night show with light display is spectacular.',
      images: [
        'https://picsum.photos/400/300?random=26',
      ],
      visitTime: DateTime.now(),
      createTime: DateTime.now(),
      likeCount: 234,
      commentCount: 45,
      reviewCount: 123,
      isLiked: false,
      tags: ['Landmark', 'Night View', 'Must-visit'],
    ),
    Review(
      id: '4',
      userId: 'u4',
      userName: 'Foodie Team',
      userAvatar: 'https://picsum.photos/100/100?random=204',
      shopName: 'Xia\'s Clay Pot',
      shopType: 'Hubei Cuisine',
      location: 'Wansongyuan',
      rating: 4.6,
      content: 'Wuhan must-eat list! Lotus root pork rib soup is sweet, lotus root is soft and stretchy. Beef tripe clay pot is flavorful, affordable price, two people can eat well for 200.',
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
      tags: ['Must-eat', 'Hubei Cuisine', 'Clay Pot'],
    ),
    Review(
      id: '5',
      userId: 'u5',
      userName: 'B&B Lover',
      userAvatar: 'https://picsum.photos/100/100?random=205',
      shopName: 'Yinshe B&B',
      shopType: 'Bed & Breakfast',
      location: 'Tanhualin',
      rating: 4.9,
      content: 'Hidden gem in Tanhualin! Each room has different themes, I stayed in "Sakura Pavilion" with tatami and projector. The host is very welcoming and recommends nearby hidden spots.',
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
      tags: ['Design', 'Friendly Service', 'Tanhualin'],
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
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;

    return Scaffold(
      backgroundColor: _cloudWhite,
      appBar: AppBar(
        title: Text(
          texts['reviewsTitle'] ?? 'Reviews',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // 搜索栏
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: _primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.search, color: _primaryColor),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: texts['search'] ?? 'Search attractions, hotels, food...',
                            hintStyle: TextStyle(color: _primaryColor.withOpacity(0.5)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          style: const TextStyle(color: _darkGreen),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear, color: _primaryColor),
                          onPressed: () => _searchController.clear(),
                        ),
                    ],
                  ),
                ),
              ),
              // 分类Tab - 使用英文
              TabBar(
                controller: _tabController,
                indicatorColor: _primaryColor,
                labelColor: _primaryColor,
                unselectedLabelColor: _darkGreen.withOpacity(0.5),
                tabs: [
                  Tab(text: texts['all'] ?? 'All'),
                  Tab(text: texts['food'] ?? 'Food'),
                  Tab(text: texts['hotel'] ?? 'Hotel'),
                  Tab(text: texts['attraction'] ?? 'Attractions'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // 背景装饰 - 大椿树影
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/tree_pattern.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      _treeBrown.withOpacity(0.3),
                      BlendMode.overlay,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 主要内容
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildReviewList(isDark, texts, _reviews),
                  _buildReviewList(isDark, texts, _reviews.where((r) => r.shopType.contains('Snacks') || r.shopType.contains('Cuisine')).toList()),
                  _buildReviewList(isDark, texts, _reviews.where((r) => r.shopType.contains('Hotel') || r.shopType.contains('Bed & Breakfast')).toList()),
                  _buildReviewList(isDark, texts, _reviews.where((r) => r.shopType.contains('Scenic')).toList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建评价列表
  Widget _buildReviewList(bool isDark, Map<String, String> texts, List<Review> reviews) {
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
              color: _primaryColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              texts['noData'] ?? 'No reviews found',
              style: TextStyle(
                fontSize: 16,
                color: _darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              texts['footerQuote'] ?? 'Carefree Journey · All things arise',
              style: TextStyle(
                fontSize: 12,
                color: _primaryColor.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReviews.length,
      itemBuilder: (context, index) {
        final review = filteredReviews[index];
        return _buildReviewCard(review, isDark, texts);
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
          return Icon(Icons.star, color: _primaryColor, size: 16);
        } else if (index == fullStars && hasHalfStar) {
          return Icon(Icons.star_half, color: _primaryColor, size: 16);
        } else {
          return Icon(Icons.star_border, color: _primaryColor, size: 16);
        }
      }),
    );
  }

  // 构建评价卡片
  Widget _buildReviewCard(Review review, bool isDark, Map<String, String> texts) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(review.userAvatar),
                  radius: 20,
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
                          fontSize: 16,
                          color: _darkGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${texts['reviews'] ?? 'Reviews'} ${review.reviewCount} · ${texts['followers'] ?? 'Followers'} ${review.likeCount}',
                        style: TextStyle(
                          fontSize: 12,
                          color: _primaryColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                // 评分
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildRatingStars(review.rating),
                      const SizedBox(width: 4),
                      Text(
                        review.rating.toString(),
                        style: TextStyle(
                          color: _primaryColor,
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    review.shopType,
                    style: TextStyle(
                      fontSize: 11,
                      color: _secondaryColor,
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
                          color: _darkGreen,
                        ),
                      ),
                      Text(
                        review.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: _primaryColor.withOpacity(0.6),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: review.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
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
            padding: const EdgeInsets.all(16),
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
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 11,
                          color: _primaryColor,
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
                    color: _darkGreen.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_formatDate(review.visitTime)} ${texts['visit'] ?? 'visited'} · ${texts['reviewed'] ?? 'reviewed on'} ${_formatDate(review.createTime)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: _primaryColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          
          // 互动栏
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildReviewAction(
                  icon: review.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: review.isLiked ? Colors.red : _primaryColor,
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
                  color: _primaryColor,
                  count: review.commentCount,
                  onTap: () => _showCommentDialog(context, review, isDark, texts),
                ),
                const SizedBox(width: 20),
                _buildReviewAction(
                  icon: Icons.share_outlined,
                  color: _primaryColor,
                  count: null,
                  onTap: () => _showShareDialog(context, isDark, texts),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _writeReview(review, texts),
                  style: TextButton.styleFrom(
                    foregroundColor: _primaryColor,
                  ),
                  child: Text(texts['writeReview'] ?? 'Write Review'),
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
              style: TextStyle(fontSize: 12, color: _darkGreen),
            ),
          ],
        ],
      ),
    );
  }

  // 显示筛选对话框
  void _showFilterDialog(BuildContext context, Map<String, String> texts) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
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
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                texts['filter'] ?? 'Filter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _darkGreen),
              ),
              const SizedBox(height: 16),
              Text(
                texts['rating'] ?? 'Rating',
                style: TextStyle(fontWeight: FontWeight.w500, color: _darkGreen),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip(texts['all'] ?? 'All', true),
                  _buildFilterChip('3★+', false),
                  _buildFilterChip('4★+', false),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                texts['sort'] ?? 'Sort',
                style: TextStyle(fontWeight: FontWeight.w500, color: _darkGreen),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip(texts['latest'] ?? 'Latest', true),
                  _buildFilterChip(texts['popular'] ?? 'Popular', false),
                  _buildFilterChip(texts['highestRated'] ?? 'Highest Rated', false),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(texts['confirm'] ?? 'Confirm', style: const TextStyle(fontSize: 16)),
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
      backgroundColor: Colors.white,
      selectedColor: _primaryColor.withOpacity(0.2),
      checkmarkColor: _primaryColor,
      side: BorderSide(
        color: isSelected ? _primaryColor : _primaryColor.withOpacity(0.3),
      ),
      labelStyle: TextStyle(
        color: isSelected ? _primaryColor : _darkGreen,
      ),
    );
  }

  // 显示评论对话框
  void _showCommentDialog(BuildContext context, Review review, bool isDark, Map<String, String> texts) {
    final TextEditingController commentController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                    backgroundImage: NetworkImage(review.userAvatar),
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(review.userName, style: TextStyle(color: _darkGreen)),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(texts['commentSent'] ?? 'Comment sent'),
                        backgroundColor: _primaryColor,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(texts['send'] ?? 'Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 显示分享对话框
  void _showShareDialog(BuildContext context, bool isDark, Map<String, String> texts) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                _buildShareItem(Icons.wechat, texts['wechat'] ?? 'WeChat', isDark, texts),
                _buildShareItem(Icons.people, texts['moments'] ?? 'Moments', isDark, texts),
                _buildShareItem(Icons.photo_camera, texts['weibo'] ?? 'Weibo', isDark, texts),
                _buildShareItem(Icons.link, texts['copyLink'] ?? 'Copy Link', isDark, texts),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: _primaryColor,
              ),
              child: Text(texts['cancel'] ?? 'Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  // 构建分享项
  Widget _buildShareItem(IconData icon, String label, bool isDark, Map<String, String> texts) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${texts['shared'] ?? 'Shared to'} $label'),
            backgroundColor: _primaryColor,
          ),
        );
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
          Text(label, style: TextStyle(color: _darkGreen)),
        ],
      ),
    );
  }

  // 写点评
  void _writeReview(Review review, Map<String, String> texts) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${texts['writeReview'] ?? 'Write review'}: ${review.shopName}'),
        backgroundColor: _primaryColor,
      ),
    );
  }

  // 格式化日期 - 改为英文格式
  String _formatDate(DateTime date) {
    // 英文月份缩写
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
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