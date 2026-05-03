import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../services/api_service.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '全部';
  String _selectedCategoryEn = 'All';
  String _selectedSort = '综合排序';
  String _selectedSortEn = 'Comprehensive';
  bool _isLoading = false;
  
  // 模拟美食数据
  List<Map<String, dynamic>> _foodItems = [];
  List<Map<String, dynamic>> _filteredItems = [];

  // 青绿色系定义
  static const Color _primaryColor = Color(0xFF2E8B57); // 海松绿
  static const Color _secondaryColor = Color(0xFF66CDAA); // 中碧绿
  static const Color _darkGreen = Color(0xFF1B4D3E); // 深墨绿
  static const Color _cloudWhite = Color(0xFFF0F8FF); // 云白

  // 分类选项（中英对照）
  final List<Map<String, String>> _categories = [
    {'zh': '全部', 'en': 'All'},
    {'zh': '热干面', 'en': 'Hot Dry Noodles'},
    {'zh': '豆皮', 'en': 'Bean Skin'},
    {'zh': '汤包', 'en': 'Soup Dumplings'},
    {'zh': '面窝', 'en': 'Fried Dough Ring'},
    {'zh': '糊汤粉', 'en': 'Rice Noodle Soup'},
    {'zh': '糯米包油条', 'en': 'Sticky Rice Roll'},
  ];

  // 排序选项（中英对照）
  final List<Map<String, String>> _sortOptions = [
    {'zh': '综合排序', 'en': 'Comprehensive'},
    {'zh': '评分最高', 'en': 'Highest Rated'},
    {'zh': '距离最近', 'en': 'Nearest'},
    {'zh': '价格最低', 'en': 'Lowest Price'},
    {'zh': '人气最高', 'en': 'Most Popular'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _loadFoodData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFoodData() async {
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _foodItems = [
        {
          'id': '1',
          'name': '蔡林记热干面',
          'nameEn': 'Cailinji Hot Dry Noodles',
          'image': 'https://picsum.photos/400/300?random=101',
          'rating': 4.8,
          'reviewCount': 12345,
          'price': 15,
          'category': '热干面',
          'categoryEn': 'Hot Dry Noodles',
          'distance': '1.2km',
          'address': '江汉区中山大道539号',
          'addressEn': '539 Zhongshan Avenue, Jianghan District',
          'hours': '06:00-21:00',
          'phone': '027-82831234',
          'tags': ['老字号', '早餐', '必吃'],
          'tagsEn': ['Time-honored', 'Breakfast', 'Must-try'],
          'recommended': ['热干面', '蛋酒', '面窝'],
          'recommendedEn': ['Hot Dry Noodles', 'Egg Wine', 'Fried Dough Ring'],
          'latitude': 30.5788,
          'longitude': 114.2891,
        },
        {
          'id': '2',
          'name': '老通城豆皮',
          'nameEn': 'Laotongcheng Bean Skin',
          'image': 'https://picsum.photos/400/300?random=102',
          'rating': 4.7,
          'reviewCount': 8765,
          'price': 12,
          'category': '豆皮',
          'categoryEn': 'Bean Skin',
          'distance': '2.5km',
          'address': '江岸区吉庆街78号',
          'addressEn': '78 Jiqing Street, Jiang\'an District',
          'hours': '06:30-20:30',
          'phone': '027-82781234',
          'tags': ['老字号', '非遗', '排队王'],
          'tagsEn': ['Time-honored', 'Intangible Heritage', 'Long Queue'],
          'recommended': ['三鲜豆皮', '蛋酒', '糊米酒'],
          'recommendedEn': ['Three Delicacies Bean Skin', 'Egg Wine', 'Rice Wine'],
          'latitude': 30.5812,
          'longitude': 114.2923,
        },
        {
          'id': '3',
          'name': '四季美汤包',
          'nameEn': 'Sijimei Soup Dumplings',
          'image': 'https://picsum.photos/400/300?random=103',
          'rating': 4.6,
          'reviewCount': 6543,
          'price': 25,
          'category': '汤包',
          'categoryEn': 'Soup Dumplings',
          'distance': '1.8km',
          'address': '江汉区江汉路步行街121号',
          'addressEn': '121 Jianghan Road Pedestrian Street, Jianghan District',
          'hours': '07:00-21:00',
          'phone': '027-82849876',
          'tags': ['老字号', '汤包', '必吃'],
          'tagsEn': ['Time-honored', 'Soup Dumplings', 'Must-try'],
          'recommended': ['鲜肉汤包', '蟹黄汤包', '鸡汤'],
          'recommendedEn': ['Pork Soup Dumplings', 'Crab Roe Soup Dumplings', 'Chicken Soup'],
          'latitude': 30.5795,
          'longitude': 114.2878,
        },
        {
          'id': '4',
          'name': '户部巷徐嫂糊汤粉',
          'nameEn': 'Xusao Rice Noodle Soup',
          'image': 'https://picsum.photos/400/300?random=104',
          'rating': 4.5,
          'reviewCount': 4321,
          'price': 10,
          'category': '糊汤粉',
          'categoryEn': 'Rice Noodle Soup',
          'distance': '3.1km',
          'address': '武昌区户部巷自由路18号',
          'addressEn': '18 Ziyou Road, Hubu Alley, Wuchang District',
          'hours': '06:00-14:00',
          'phone': '027-88871234',
          'tags': ['老字号', '早餐', '糊汤粉'],
          'tagsEn': ['Time-honored', 'Breakfast', 'Rice Noodle Soup'],
          'recommended': ['糊汤粉', '油条', '面窝'],
          'recommendedEn': ['Rice Noodle Soup', 'Fried Dough Stick', 'Fried Dough Ring'],
          'latitude': 30.5467,
          'longitude': 114.2983,
        },
        {
          'id': '5',
          'name': '陈记炸酱面',
          'nameEn': 'Chen\'s Noodles',
          'image': 'https://picsum.photos/400/300?random=105',
          'rating': 4.4,
          'reviewCount': 3210,
          'price': 18,
          'category': '面食',
          'categoryEn': 'Noodles',
          'distance': '2.2km',
          'address': '江汉区民生路176号',
          'addressEn': '176 Minsheng Road, Jianghan District',
          'hours': '07:00-22:00',
          'phone': '027-85679876',
          'tags': ['炸酱面', '午餐', '晚餐'],
          'tagsEn': ['Noodles', 'Lunch', 'Dinner'],
          'recommended': ['炸酱面', '红烧牛肉面', '凉菜'],
          'recommendedEn': ['Noodles with Soybean Paste', 'Braised Beef Noodles', 'Cold Dishes'],
          'latitude': 30.5756,
          'longitude': 114.2856,
        },
      ];
      _filteredItems = _foodItems;
      _applyFilters();
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_foodItems);
    final isEnglish = Provider.of<LanguageService>(context, listen: false).isEnglish;

    if (_selectedCategory != '全部') {
      filtered = filtered.where((item) => 
        isEnglish ? item['categoryEn'] == _selectedCategoryEn : item['category'] == _selectedCategory
      ).toList();
    }

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((item) {
        if (isEnglish) {
          return item['nameEn'].toLowerCase().contains(query) ||
                 (item['tagsEn'] as List).any((tag) => tag.toLowerCase().contains(query)) ||
                 item['addressEn'].toLowerCase().contains(query);
        } else {
          return item['name'].toLowerCase().contains(query) ||
                 (item['tags'] as List).any((tag) => tag.toLowerCase().contains(query)) ||
                 item['address'].toLowerCase().contains(query);
        }
      }).toList();
    }

    switch (_selectedSort) {
      case '评分最高':
      case 'Highest Rated':
        filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      case '距离最近':
      case 'Nearest':
        filtered.sort((a, b) => a['distance'].compareTo(b['distance']));
        break;
      case '价格最低':
      case 'Lowest Price':
        filtered.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case '人气最高':
      case 'Most Popular':
        filtered.sort((a, b) => b['reviewCount'].compareTo(a['reviewCount']));
        break;
      default:
        break;
    }

    setState(() {
      _filteredItems = filtered;
    });
  }

  String _getCategoryText(Map<String, String> category, bool isEnglish) {
    return isEnglish ? category['en']! : category['zh']!;
  }

  String _getSortText(Map<String, String> sort, bool isEnglish) {
    return isEnglish ? sort['en']! : sort['zh']!;
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
          isEnglish ? 'Local Food' : '特色美食',
          style: const TextStyle(
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
            Tab(text: isEnglish ? 'Recommended' : '推荐'),
            Tab(text: isEnglish ? 'Nearby' : '附近'),
            Tab(text: isEnglish ? 'Popular' : '人气'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: _primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    isEnglish ? 'Loading delicacies...' : '美食加载中...',
                    style: TextStyle(color: _primaryColor),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                // 搜索栏
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: _primaryColor.withOpacity(0.3),
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
                                hintText: isEnglish ? 'Search food...' : '搜索美食...',
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
                ),

                // 分类筛选
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final categoryZh = category['zh']!;
                          final categoryEn = category['en']!;
                          final isSelected = isEnglish 
                              ? _selectedCategoryEn == categoryEn
                              : _selectedCategory == categoryZh;
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(isEnglish ? categoryEn : categoryZh),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (isEnglish) {
                                    _selectedCategoryEn = categoryEn;
                                    _selectedCategory = categoryZh;
                                  } else {
                                    _selectedCategory = categoryZh;
                                    _selectedCategoryEn = categoryEn;
                                  }
                                  _applyFilters();
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: _primaryColor,
                              checkmarkColor: Colors.white,
                              side: BorderSide(
                                color: isSelected ? _primaryColor : _primaryColor.withOpacity(0.3),
                              ),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : _darkGreen,
                                fontSize: 13,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // 排序选项
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _sortOptions.length,
                        itemBuilder: (context, index) {
                          final sort = _sortOptions[index];
                          final sortZh = sort['zh']!;
                          final sortEn = sort['en']!;
                          final isSelected = isEnglish 
                              ? _selectedSortEn == sortEn
                              : _selectedSort == sortZh;
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(isEnglish ? sortEn : sortZh),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (isEnglish) {
                                    _selectedSortEn = sortEn;
                                    _selectedSort = sortZh;
                                  } else {
                                    _selectedSort = sortZh;
                                    _selectedSortEn = sortEn;
                                  }
                                  _applyFilters();
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: _primaryColor.withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: isSelected ? _primaryColor : _darkGreen,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Tab内容 - 作为Sliver
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFoodList(_filteredItems, isEnglish), // 推荐
                      _buildFoodList(_filteredItems.where((item) => double.parse(item['distance'].replaceAll('km', '')) < 2).toList(), isEnglish), // 附近
                      _buildFoodList(_filteredItems.where((item) => item['reviewCount'] > 5000).toList(), isEnglish), // 人气
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFoodList(List<Map<String, dynamic>> items, bool isEnglish) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 80,
              color: _primaryColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              isEnglish ? 'No food found' : '未找到相关美食',
              style: TextStyle(
                fontSize: 16,
                color: _darkGreen,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildFoodCard(item, isEnglish);
      },
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> item, bool isEnglish) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showFoodDetail(item, isEnglish),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                item['image'],
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            // 内容
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isEnglish ? item['nameEn'] : item['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _darkGreen,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              item['rating'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _darkGreen,
                              ),
                            ),
                            Text(
                              ' (${item['reviewCount']})',
                              style: TextStyle(
                                fontSize: 12,
                                color: _darkGreen.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: _primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        item['distance'],
                        style: TextStyle(
                          fontSize: 13,
                          color: _darkGreen.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.attach_money, size: 14, color: _primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        '¥${item['price']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: _darkGreen.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    isEnglish ? item['addressEn'] : item['address'],
                    style: TextStyle(
                      fontSize: 13,
                      color: _darkGreen.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 标签
                  Wrap(
                    spacing: 6,
                    children: (isEnglish ? item['tagsEn'] : item['tags']).map<Widget>((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFoodDetail(Map<String, dynamic> item, bool isEnglish) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              _cloudWhite,
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isEnglish ? item['nameEn'] : item['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _darkGreen,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // 评分
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFD700)),
                const SizedBox(width: 4),
                Text(
                  '${item['rating']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
                Text(
                  ' (${item['reviewCount']} ${isEnglish ? 'reviews' : '条评价'})',
                  style: TextStyle(
                    fontSize: 14,
                    color: _darkGreen.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 图片
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 信息
            _buildInfoRow(Icons.location_on, isEnglish ? 'Address' : '地址', isEnglish ? item['addressEn'] : item['address']),
            _buildInfoRow(Icons.access_time, isEnglish ? 'Hours' : '营业时间', item['hours']),
            _buildInfoRow(Icons.phone, isEnglish ? 'Phone' : '电话', item['phone']),
            _buildInfoRow(Icons.attach_money, isEnglish ? 'Avg. Price' : '人均消费', '¥${item['price']}'),
            
            const SizedBox(height: 20),
            
            // 推荐菜品
            Text(
              isEnglish ? 'Recommended Dishes' : '推荐菜品',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _darkGreen,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Wrap(
              spacing: 8,
              children: (isEnglish ? item['recommendedEn'] : item['recommended']).map<Widget>((dish) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    dish,
                    style: TextStyle(color: _primaryColor),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 20),
            
            // 按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.favorite_border, color: _primaryColor),
                    label: Text(
                      isEnglish ? 'Add to Favorites' : '收藏',
                      style: TextStyle(color: _primaryColor),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isEnglish ? 'Added to favorites' : '已加入收藏'),
                          backgroundColor: _primaryColor,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.navigation, color: Colors.white),
                    label: Text(
                      isEnglish ? 'Navigate' : '导航',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _openMap(item['latitude'], item['longitude'], isEnglish ? item['nameEn'] : item['name']);
                    },
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: _primaryColor),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: _darkGreen.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: _darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openMap(double lat, double lng, String name) {
    print('打开地图：$name at $lat, $lng');
  }
}