import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/culture_model.dart';
import '../services/culture_service.dart';
import '../widgets/culture_card.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

class CulturePage extends StatefulWidget {
  const CulturePage({super.key});

  @override
  State<CulturePage> createState() => _CulturePageState();
}

class _CulturePageState extends State<CulturePage> with TickerProviderStateMixin {
  final CultureService _cultureService = CultureService();
  List<CultureItem> _cultureItems = [];
  List<CultureItem> _filteredItems = [];
  bool _isLoading = true;
  String _selectedCategory = '全部';
  String _selectedRegion = '全部';
  final TextEditingController _searchController = TextEditingController();
  
  // 动画控制器
  late AnimationController _treeController;
  
  // Tab控制器
  late TabController _tabController;

  // ============ 青绿色系定义（与主页保持一致）============
  static const Color _primaryColor = Color(0xFF2E8B57); // 海松绿
  static const Color _secondaryColor = Color(0xFF66CDAA); // 中碧绿
  static const Color _accentColor = Color(0xFF40E0D0); // 青绿
  static const Color _darkGreen = Color(0xFF1B4D3E); // 深墨绿
  static const Color _lightGreen = Color(0xFF98FB98); // 淡绿
  static const Color _cloudWhite = Color(0xFFF0F8FF); // 云白
  static const Color _inkBlack = Color(0xFF2F4F4F); // 墨色
  static const Color _treeBrown = Color(0xFF8B5A2B); // 椿树棕

  // 分类选项（中英对照）
  final List<Map<String, String>> _categories = [
    {'zh': '全部', 'en': 'All'},
    {'zh': '传统技艺', 'en': 'Traditional Crafts'},
    {'zh': '表演艺术', 'en': 'Performing Arts'},
    {'zh': '民俗活动', 'en': 'Folk Activities'},
    {'zh': '传统医药', 'en': 'Traditional Medicine'},
    {'zh': '口头传统', 'en': 'Oral Traditions'},
  ];
  
  final List<Map<String, String>> _regions = [
    {'zh': '全部', 'en': 'All'},
    {'zh': '华中', 'en': 'Central China'},
    {'zh': '华东', 'en': 'East China'},
    {'zh': '华南', 'en': 'South China'},
    {'zh': '华北', 'en': 'North China'},
    {'zh': '西南', 'en': 'Southwest China'},
    {'zh': '西北', 'en': 'Northwest China'},
    {'zh': '东北', 'en': 'Northeast China'},
  ];
  
  // 微博式顶部导航标签
  final List<String> _tabKeys = ['recommended', 'latest', 'following', 'nearby'];

  // 模拟数据 - 英文版示例内容
  final List<Map<String, dynamic>> _mockPosts = [
    {
      'id': '1',
      'name': 'Wuhan University',
      'category': 'Cultural Heritage',
      'region': 'Central China',
      'description': 'Wuhan University is one of the most prestigious universities in China, known for its beautiful campus and cherry blossoms in spring. The ancient architecture blends perfectly with modern education.',
      'tags': ['university', 'cherry blossoms', 'history'],
      'likes': 1250,
      'images': ['https://picsum.photos/400/300?random=1'],
    },
    {
      'id': '2',
      'name': 'Yellow Crane Tower',
      'category': 'Historical Site',
      'region': 'Central China',
      'description': 'One of the Four Great Towers of China, the Yellow Crane Tower has been a symbol of Wuhan for centuries. Poets have written countless verses about its majestic beauty.',
      'tags': ['tower', 'history', 'poetry'],
      'likes': 980,
      'images': ['https://picsum.photos/400/300?random=2'],
    },
    {
      'id': '3',
      'name': 'East Lake',
      'category': 'Scenic Area',
      'region': 'Central China',
      'description': 'The largest urban lake in China, East Lake offers stunning views, cycling paths, and cultural sites. Perfect for a relaxing day out.',
      'tags': ['lake', 'nature', 'cycling'],
      'likes': 756,
      'images': ['https://picsum.photos/400/300?random=3'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabKeys.length, vsync: this);
    _treeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
    
    _loadCultureItems();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _treeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCultureItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await _cultureService.getAllCultureItems();
      setState(() {
        _cultureItems = items;
        _filteredItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _cultureItems;
      } else {
        _filteredItems = _cultureItems.where((item) {
          return item.name.toLowerCase().contains(query) ||
                 item.description.toLowerCase().contains(query) ||
                 item.tags.any((tag) => tag.toLowerCase().contains(query));
        }).toList();
      }
    });
    _applyFilters();
  }

  void _applyFilters() {
    List<CultureItem> filtered = _cultureItems;

    if (_selectedCategory != '全部') {
      filtered = filtered.where((item) => item.category == _selectedCategory).toList();
    }

    if (_selectedRegion != '全部') {
      filtered = filtered.where((item) => item.region == _selectedRegion).toList();
    }

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(query) ||
               item.description.toLowerCase().contains(query);
      }).toList();
    }

    setState(() => _filteredItems = filtered);
  }

  // 获取当前语言的分类标签
  String _getCategoryLabel(Map<String, String> category, bool isEnglish) {
    return isEnglish ? category['en']! : category['zh']!;
  }

  // 获取当前语言的地区标签
  String _getRegionLabel(Map<String, String> region, bool isEnglish) {
    return isEnglish ? region['en']! : region['zh']!;
  }

  // 获取示例帖子的英文内容
  String _getMockPostName(int index, bool isEnglish) {
    if (!isEnglish) return _mockPosts[index]['name'];
    switch (index) {
      case 0: return 'Wuhan University';
      case 1: return 'Yellow Crane Tower';
      case 2: return 'East Lake';
      default: return _mockPosts[index]['name'];
    }
  }

  String _getMockPostDescription(int index, bool isEnglish) {
    if (!isEnglish) return _mockPosts[index]['description'];
    switch (index) {
      case 0:
        return 'Wuhan University is one of the most prestigious universities in China, known for its beautiful campus and cherry blossoms in spring. The ancient architecture blends perfectly with modern education.';
      case 1:
        return 'One of the Four Great Towers of China, the Yellow Crane Tower has been a symbol of Wuhan for centuries. Poets have written countless verses about its majestic beauty.';
      case 2:
        return 'The largest urban lake in China, East Lake offers stunning views, cycling paths, and cultural sites. Perfect for a relaxing day out.';
      default:
        return _mockPosts[index]['description'];
    }
  }

  String _getMockPostTag(int index, int tagIndex, bool isEnglish) {
    if (!isEnglish) return _mockPosts[index]['tags'][tagIndex];
    final tags = [
      ['university', 'cherry blossoms', 'history'],
      ['tower', 'history', 'poetry'],
      ['lake', 'nature', 'cycling'],
    ];
    return tags[index][tagIndex];
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;
    final isEnglish = languageService.isEnglish;

    return Scaffold(
      backgroundColor: _cloudWhite,
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Intangible Cultural Heritage' : (texts['cultureTitle'] ?? '非遗文化'),
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
          tabs: _tabKeys.map((key) {
            String label;
            switch (key) {
              case 'recommended':
                label = isEnglish ? 'Recommended' : (texts['recommended'] ?? '推荐');
                break;
              case 'latest':
                label = isEnglish ? 'Latest' : (texts['latest'] ?? '最新');
                break;
              case 'following':
                label = isEnglish ? 'Following' : (texts['following'] ?? '关注');
                break;
              case 'nearby':
                label = isEnglish ? 'Nearby' : (texts['nearbyFood'] ?? '附近');
                break;
              default:
                label = key;
            }
            return Tab(text: label);
          }).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewPost,
            tooltip: isEnglish ? 'Create Post' : (texts['createPost'] ?? '创建帖子'),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 背景 - 大椿树影
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _treeController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.08,
                  child: Transform.translate(
                    offset: Offset(0, _treeController.value * 10),
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
                );
              },
            ),
          ),
          
          // 大椿装饰 - 左上
          Positioned(
            top: 10,
            left: 10,
            child: Opacity(
              opacity: 0.15,
              child: Icon(
                Icons.nature,
                size: 60,
                color: _treeBrown,
              ),
            ),
          ),
          
          // 大椿装饰 - 右下
          Positioned(
            bottom: 20,
            right: 10,
            child: Opacity(
              opacity: 0.12,
              child: Transform.rotate(
                angle: 0.2,
                child: Icon(
                  Icons.nature_people,
                  size: 80,
                  color: _darkGreen,
                ),
              ),
            ),
          ),
          
          // 主要内容 - 使用 CustomScrollView
          CustomScrollView(
            slivers: [
              // 搜索栏 Sliver
              SliverToBoxAdapter(
                child: _buildSearchBar(texts, isEnglish, isDark),
              ),
              
              // 筛选栏 Sliver
              SliverToBoxAdapter(
                child: _buildFilterBar(texts, isEnglish, isDark),
              ),
              
              // 内容列表 Sliver
              _isLoading
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: _primaryColor),
                            const SizedBox(height: 16),
                            Text(
                              isEnglish ? 'The leaves of the giant tree unfold...' : '大椿之叶，缓缓展开...',
                              style: TextStyle(color: _primaryColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // 使用模拟数据或真实数据
                          if (_filteredItems.isEmpty) {
                            return _buildMockWeiboStyleCard(index, texts, isEnglish, isDark);
                          }
                          return _buildWeiboStyleCard(_filteredItems[index], texts, isEnglish, isDark);
                        },
                        childCount: _filteredItems.isEmpty ? _mockPosts.length : _filteredItems.length,
                      ),
                    ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewPost,
        backgroundColor: _primaryColor,
        child: const Icon(Icons.edit, color: Colors.white),
        tooltip: isEnglish ? 'Create Post' : (texts['createPost'] ?? '创建帖子'),
      ),
    );
  }

  Widget _buildSearchBar(Map<String, String> texts, bool isEnglish, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
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
                  hintText: isEnglish ? 'Search cultural heritage...' : (texts['searchCulture'] ?? '搜索非遗项目...'),
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
                tooltip: isEnglish ? 'Clear' : (texts['cancel'] ?? '清除'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar(Map<String, String> texts, bool isEnglish, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, color: _primaryColor, size: 18),
              const SizedBox(width: 6),
              Text(
                isEnglish ? 'Category' : (texts['cultureCategory'] ?? '类别'),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _darkGreen,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category['zh'];
                final label = _getCategoryLabel(category, isEnglish);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category['zh']!);
                      _applyFilters();
                    },
                    backgroundColor: Colors.white,
                    selectedColor: _primaryColor,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? _primaryColor : _primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : _darkGreen,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Icon(Icons.location_on, color: _primaryColor, size: 18),
              const SizedBox(width: 6),
              Text(
                isEnglish ? 'Region' : (texts['region'] ?? '地区'),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _darkGreen,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _regions.map((region) {
                final isSelected = _selectedRegion == region['zh'];
                final label = _getRegionLabel(region, isEnglish);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedRegion = region['zh']!);
                      _applyFilters();
                    },
                    backgroundColor: Colors.white,
                    selectedColor: _primaryColor,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? _primaryColor : _primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : _darkGreen,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 模拟数据的微博式卡片
  Widget _buildMockWeiboStyleCard(int index, Map<String, String> texts, bool isEnglish, bool isDark) {
    final post = _mockPosts[index];
    
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
          // 用户信息区
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [_primaryColor, _secondaryColor],
                    ),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      isEnglish ? 'CH' : '文',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMockPostName(index, isEnglish),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _darkGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            size: 12,
                            color: _primaryColor.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isEnglish ? 'Cultural Heritage' : post['category'],
                            style: TextStyle(
                              fontSize: 11,
                              color: _primaryColor.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: _primaryColor.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isEnglish ? 'Central China' : post['region'],
                            style: TextStyle(
                              fontSize: 11,
                              color: _primaryColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 关注按钮
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: _primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    isEnglish ? '+ Follow' : '+ 关注',
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

          // 内容描述
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _getMockPostDescription(index, isEnglish),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: _darkGreen.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ),

          // 图片墙
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(post['images'][0]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 标签区
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: List.generate(3, (tagIndex) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _primaryColor.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    '#${_getMockPostTag(index, tagIndex, isEnglish)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: _primaryColor,
                    ),
                  ),
                );
              }),
            ),
          ),

          // 互动栏
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.favorite_border,
                  count: post['likes'],
                  color: Colors.red,
                  onTap: () {},
                  tooltip: isEnglish ? 'Like' : (texts['like'] ?? '点赞'),
                ),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  count: 42,
                  color: _primaryColor,
                  onTap: () {},
                  tooltip: isEnglish ? 'Comment' : (texts['comment'] ?? '评论'),
                ),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  count: 18,
                  color: _primaryColor,
                  onTap: () {},
                  tooltip: isEnglish ? 'Share' : (texts['share'] ?? '分享'),
                ),
                _buildActionButton(
                  icon: Icons.bookmark_border,
                  count: null,
                  color: _primaryColor,
                  onTap: () {},
                  tooltip: isEnglish ? 'Save' : (texts['save'] ?? '收藏'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 微博式卡片（真实数据）
  Widget _buildWeiboStyleCard(CultureItem item, Map<String, String> texts, bool isEnglish, bool isDark) {
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
          // 用户信息区
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [_primaryColor, _secondaryColor],
                    ),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      item.name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _darkGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            size: 12,
                            color: _primaryColor.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isEnglish ? _getCategoryEnglish(item.category) : item.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: _primaryColor.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: _primaryColor.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isEnglish ? _getRegionEnglish(item.region) : item.region,
                            style: TextStyle(
                              fontSize: 11,
                              color: _primaryColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 关注按钮
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: _primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    isEnglish ? '+ Follow' : '+ 关注',
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

          // 内容描述
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              item.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: _darkGreen.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ),

          // 图片墙
          if (item.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: item.images.length >= 3 ? 3 : item.images.length,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: item.images.length > 3 ? 3 : item.images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showCultureDetail(item, texts, isEnglish),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(item.images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: index == 2 && item.images.length > 3
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Text(
                                  '+${item.images.length - 3}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],

          // 标签区
          if (item.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                children: item.tags.take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: _primaryColor.withOpacity(0.2),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 11,
                        color: _primaryColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // 互动栏
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.favorite_border,
                  count: item.likes,
                  color: Colors.red,
                  onTap: () => _likeItem(item),
                  tooltip: isEnglish ? 'Like' : (texts['like'] ?? '点赞'),
                ),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  count: 42,
                  color: _primaryColor,
                  onTap: () => _showCultureDetail(item, texts, isEnglish),
                  tooltip: isEnglish ? 'Comment' : (texts['comment'] ?? '评论'),
                ),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  count: 18,
                  color: _primaryColor,
                  onTap: () => _shareItem(item),
                  tooltip: isEnglish ? 'Share' : (texts['share'] ?? '分享'),
                ),
                _buildActionButton(
                  icon: Icons.bookmark_border,
                  count: null,
                  color: _primaryColor,
                  onTap: () {},
                  tooltip: isEnglish ? 'Save' : (texts['save'] ?? '收藏'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 辅助函数：获取分类的英文名称
  String _getCategoryEnglish(String zhCategory) {
    for (var category in _categories) {
      if (category['zh'] == zhCategory) {
        return category['en']!;
      }
    }
    return zhCategory;
  }

  // 辅助函数：获取地区的英文名称
  String _getRegionEnglish(String zhRegion) {
    for (var region in _regions) {
      if (region['zh'] == zhRegion) {
        return region['en']!;
      }
    }
    return zhRegion;
  }

  Widget _buildActionButton({
    required IconData icon,
    int? count,
    required Color color,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip ?? '',
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: color,
            ),
            if (count != null) ...[
              const SizedBox(width: 4),
              Text(
                _formatCount(count),
                style: TextStyle(
                  fontSize: 12,
                  color: _darkGreen,
                ),
              ),
            ],
          ],
        ),
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

  void _showCultureDetail(CultureItem item, Map<String, String> texts, bool isEnglish) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.85,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  tooltip: isEnglish ? 'Close' : (texts['cancel'] ?? '关闭'),
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            // 标签
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(isEnglish ? _getCategoryEnglish(item.category) : item.category),
                  backgroundColor: _primaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: _primaryColor),
                  side: BorderSide.none,
                ),
                Chip(
                  label: Text(isEnglish ? _getRegionEnglish(item.region) : item.region),
                  backgroundColor: _secondaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: _secondaryColor),
                  side: BorderSide.none,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 图片轮播
            if (item.images.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: item.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(item.images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            
            const SizedBox(height: 20),
            
            // 描述
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  item.description,
                  style: TextStyle(
                    color: _darkGreen,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 操作按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.favorite_border, color: _primaryColor),
                    label: Text(
                      isEnglish ? 'Like ${item.likes}' : '${texts['like'] ?? '点赞'} ${item.likes}',
                      style: TextStyle(color: _primaryColor),
                    ),
                    onPressed: () => _likeItem(item),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.event, color: Colors.white),
                    label: Text(isEnglish ? 'Book Experience' : (texts['bookExperience'] ?? '预约体验')),
                    onPressed: () => _bookExperience(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createNewPost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        final languageService = Provider.of<LanguageService>(context);
        final texts = languageService.currentLanguage;
        final isEnglish = languageService.isEnglish;
        return _buildCreatePostSheet(texts, isEnglish);
      },
    );
  }

  Widget _buildCreatePostSheet(Map<String, String> texts, bool isEnglish) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEnglish ? 'Share Cultural Heritage' : (texts['createPost'] ?? '分享非遗文化'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _darkGreen,
            ),
          ),
          
          const SizedBox(height: 20),
          
          TextField(
            decoration: InputDecoration(
              labelText: isEnglish ? 'Title' : (texts['postTitle'] ?? '标题'),
              labelStyle: TextStyle(color: _primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _primaryColor.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _primaryColor),
              ),
            ),
            maxLines: 1,
          ),
          
          const SizedBox(height: 12),
          
          TextField(
            decoration: InputDecoration(
              labelText: isEnglish ? 'Content' : (texts['postContent'] ?? '内容'),
              labelStyle: TextStyle(color: _primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _primaryColor.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _primaryColor),
              ),
            ),
            maxLines: 4,
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.photo, color: _primaryColor),
                    const SizedBox(width: 4),
                    Text(isEnglish ? 'Add Photo' : (texts['addPhoto'] ?? '添加图片'), 
                         style: TextStyle(color: _primaryColor)),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isEnglish ? 'Cancel' : (texts['cancel'] ?? '取消'), 
                           style: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEnglish ? 'Post created' : '帖子已创建'),
                      backgroundColor: _primaryColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(isEnglish ? 'Publish' : (texts['publish'] ?? '发布')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _likeItem(CultureItem item) {
    setState(() {
      final index = _cultureItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _cultureItems[index] = _cultureItems[index].copyWith(
          likes: _cultureItems[index].likes + 1,
        );
        _applyFilters();
      }
    });
  }

  void _shareItem(CultureItem item) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final texts = languageService.currentLanguage;
    final isEnglish = languageService.isEnglish;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEnglish ? 'Sharing ${item.name}' : '${texts['share'] ?? '分享'} ${item.name}'),
        backgroundColor: _primaryColor,
      ),
    );
  }

  void _bookExperience(CultureItem item) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final texts = languageService.currentLanguage;
    final isEnglish = languageService.isEnglish;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEnglish ? 'Booking experience: ${item.name}' : '${texts['bookExperience'] ?? '预约体验'}：${item.name}'),
        backgroundColor: _primaryColor,
      ),
    );
  }
}