// lib/pages/more_attractions_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

class MoreAttractionsPage extends StatefulWidget {
  const MoreAttractionsPage({super.key});

  @override
  State<MoreAttractionsPage> createState() => _MoreAttractionsPageState();
}

class _MoreAttractionsPageState extends State<MoreAttractionsPage> {
  // 搜索控制器
  final TextEditingController _searchController = TextEditingController();
  String _currentAddress = 'Wuhan Hongshan District'; // 默认地址改为英文
  
  // 筛选条件
  String _selectedSort = 'Nearest';
  String _selectedPrice = 'All';
  double _minRating = 3.5;
  
  // 模拟景区数据（保持中文名称，但添加英文翻译字段）
  final List<Map<String, dynamic>> _allAttractions = [
    {
      'id': '1',
      'name': 'Yellow Crane Tower',
      'name_zh': '黄鹤楼',
      'image': 'https://picsum.photos/400/300?random=1',
      'rating': 4.8,
      'reviewCount': 12345,
      'price': '¥70',
      'priceLevel': 'Paid',
      'priceLevel_zh': '付费',
      'distance': '2.3km',
      'address': 'Snake Hill, Wuchang District',
      'address_zh': '武昌区蛇山西山坡特1号',
      'type': '5A Scenic Spot',
      'type_zh': '5A景区',
      'tags': ['Landmark', 'History', 'Night View'],
      'tags_zh': ['地标', '历史文化', '夜景'],
      'openTime': '08:00-18:00',
      'description': 'One of the three most famous towers south of the Yangtze River, known as "The First Tower Under Heaven".',
      'description_zh': '江南三大名楼之一，享有"天下江山第一楼"之美誉。',
      'latitude': 30.5467,
      'longitude': 114.2983,
    },
    {
      'id': '2',
      'name': 'East Lake Ecological Tourist Area',
      'name_zh': '东湖生态旅游区',
      'image': 'https://picsum.photos/400/300?random=2',
      'rating': 4.7,
      'reviewCount': 23456,
      'price': 'Free',
      'priceLevel': 'Free',
      'priceLevel_zh': '免费',
      'distance': '3.1km',
      'address': 'East Lake Road, Hongshan District',
      'address_zh': '洪山区东湖路',
      'type': '5A Scenic Spot',
      'type_zh': '5A景区',
      'tags': ['Nature', 'Cycling', 'Flowers'],
      'tags_zh': ['自然风光', '骑行', '赏花'],
      'openTime': 'Open All Day',
      'openTime_zh': '全天开放',
      'description': 'The largest urban lake in China, beautiful scenery, suitable for leisure.',
      'description_zh': '中国最大的城中湖，风景秀丽，适合休闲游玩。',
      'latitude': 30.5539,
      'longitude': 114.3601,
    },
    {
      'id': '3',
      'name': 'Hubei Provincial Museum',
      'name_zh': '湖北省博物馆',
      'image': 'https://picsum.photos/400/300?random=3',
      'rating': 4.9,
      'reviewCount': 18765,
      'price': 'Free',
      'priceLevel': 'Free',
      'priceLevel_zh': '免费',
      'distance': '4.5km',
      'address': '160 East Lake Road, Wuchang District',
      'address_zh': '武昌区东湖路160号',
      'type': 'First-Class Museum',
      'type_zh': '一级博物馆',
      'tags': ['History', 'Cultural Relics', 'Sword of Goujian'],
      'tags_zh': ['历史', '文物', '越王勾践剑'],
      'openTime': '09:00-17:00',
      'description': 'Rich collection of cultural relics, famous for the Sword of Goujian and Marquis Yi Bells.',
      'description_zh': '馆藏文物丰富，以越王勾践剑、曾侯乙编钟闻名。',
      'latitude': 30.5623,
      'longitude': 114.3621,
    },
    {
      'id': '4',
      'name': 'Wuhan University',
      'name_zh': '武汉大学',
      'image': 'https://picsum.photos/400/300?random=4',
      'rating': 4.6,
      'reviewCount': 15432,
      'price': 'Free',
      'priceLevel': 'Free',
      'priceLevel_zh': '免费',
      'distance': '5.2km',
      'address': 'Luojia Hill Street, Wuchang District',
      'address_zh': '武昌区珞珈山街道',
      'type': 'University',
      'type_zh': '高等学府',
      'tags': ['Cherry Blossoms', 'Architecture', 'Academics'],
      'tags_zh': ['樱花', '建筑', '学术'],
      'openTime': 'Open All Day',
      'openTime_zh': '全天开放',
      'description': 'One of the most beautiful universities in China, famous for cherry blossoms.',
      'description_zh': '中国最美大学之一，樱花季尤为著名。',
      'latitude': 30.5311,
      'longitude': 114.3572,
    },
    {
      'id': '5',
      'name': 'Guiyuan Temple',
      'name_zh': '归元禅寺',
      'image': 'https://picsum.photos/400/300?random=5',
      'rating': 4.5,
      'reviewCount': 9876,
      'price': '¥20',
      'priceLevel': 'Paid',
      'priceLevel_zh': '付费',
      'distance': '6.7km',
      'address': '20 Cuiwei Road, Hanyang District',
      'address_zh': '汉阳区翠微路20号',
      'type': 'Buddhist Temple',
      'type_zh': '佛教寺院',
      'tags': ['Blessing', 'Ancient Temple', 'Peaceful'],
      'tags_zh': ['祈福', '古刹', '宁静'],
      'openTime': '08:00-17:00',
      'description': 'Famous Buddhist temple in Wuhan with flourishing incense.',
      'description_zh': '武汉著名佛教寺院，香火旺盛。',
      'latitude': 30.5606,
      'longitude': 114.2534,
    },
    {
      'id': '6',
      'name': 'Hankou River Beach',
      'name_zh': '汉口江滩',
      'image': 'https://picsum.photos/400/300?random=6',
      'rating': 4.4,
      'reviewCount': 11234,
      'price': 'Free',
      'priceLevel': 'Free',
      'priceLevel_zh': '免费',
      'distance': '7.1km',
      'address': 'Yanjiang Avenue, Jiang\'an District',
      'address_zh': '江岸区沿江大道',
      'type': 'River Park',
      'type_zh': '江滩公园',
      'tags': ['River View', 'Walking', 'Night View'],
      'tags_zh': ['江景', '散步', '夜景'],
      'openTime': 'Open All Day',
      'openTime_zh': '全天开放',
      'description': 'Large riverside park along the Yangtze, perfect for walks and views.',
      'description_zh': '长江边的大型江滩公园，适合散步观景。',
      'latitude': 30.5788,
      'longitude': 114.2891,
    },
    {
      'id': '7',
      'name': 'Qingchuan Pavilion',
      'name_zh': '晴川阁',
      'image': 'https://picsum.photos/400/300?random=7',
      'rating': 4.3,
      'reviewCount': 5678,
      'price': 'Free',
      'priceLevel': 'Free',
      'priceLevel_zh': '免费',
      'distance': '3.8km',
      'address': '86 Xima Chang Street, Hanyang District',
      'address_zh': '汉阳区洗马长街86号',
      'type': 'Historic Building',
      'type_zh': '历史建筑',
      'tags': ['Ancient Architecture', 'River View'],
      'tags_zh': ['古建筑', '江景'],
      'openTime': '09:00-17:00',
      'description': 'Facing Yellow Crane Tower across the river, known as "Scenic Spot of Three Chu".',
      'description_zh': '与黄鹤楼隔江相望，有"三楚胜景"之称。',
      'latitude': 30.5667,
      'longitude': 114.2833,
    },
    {
      'id': '8',
      'name': 'Wuhan Happy Valley',
      'name_zh': '武汉欢乐谷',
      'image': 'https://picsum.photos/400/300?random=8',
      'rating': 4.5,
      'reviewCount': 21345,
      'price': '¥200',
      'priceLevel': 'Paid',
      'priceLevel_zh': '付费',
      'distance': '8.3km',
      'address': '196 Huanshan Avenue, Hongshan District',
      'address_zh': '洪山区欢乐大道196号',
      'type': 'Theme Park',
      'type_zh': '主题乐园',
      'tags': ['Amusement Park', 'Family'],
      'tags_zh': ['游乐场', '亲子'],
      'openTime': '09:30-18:00',
      'description': 'Large theme park suitable for family fun.',
      'description_zh': '大型主题乐园，适合家庭游玩。',
      'latitude': 30.5892,
      'longitude': 114.3821,
    },
  ];

  // 根据当前语言获取文本
  String _getText(Map<String, dynamic> item, String field) {
    final isEnglish = Provider.of<LanguageService>(context, listen: false).isEnglish;
    if (isEnglish) {
      // 如果有英文字段就返回英文，否则返回原字段
      if (item.containsKey('${field}_en')) return item['${field}_en'];
      if (field == 'name' && item.containsKey('name')) return item['name'];
      if (field == 'address' && item.containsKey('address')) return item['address'];
      if (field == 'type' && item.containsKey('type')) return item['type'];
      if (field == 'openTime' && item.containsKey('openTime')) return item['openTime'];
      if (field == 'description' && item.containsKey('description')) return item['description'];
      if (field == 'priceLevel' && item.containsKey('priceLevel')) return item['priceLevel'];
    }
    // 返回中文
    if (field == 'name') return item['name_zh'] ?? item['name'];
    if (field == 'address') return item['address_zh'] ?? item['address'];
    if (field == 'type') return item['type_zh'] ?? item['type'];
    if (field == 'openTime') return item['openTime_zh'] ?? item['openTime'];
    if (field == 'description') return item['description_zh'] ?? item['description'];
    if (field == 'priceLevel') return item['priceLevel_zh'] ?? item['priceLevel'];
    return '';
  }

  // 获取标签列表
  List<String> _getTags(Map<String, dynamic> item) {
    final isEnglish = Provider.of<LanguageService>(context, listen: false).isEnglish;
    if (isEnglish) {
      return List<String>.from(item['tags'] ?? []);
    } else {
      return List<String>.from(item['tags_zh'] ?? item['tags'] ?? []);
    }
  }

  // 获取筛选后的景区
  List<Map<String, dynamic>> get _filteredAttractions {
    return _allAttractions.where((attraction) {
      // 价格筛选
      if (_selectedPrice != 'All') {
        final priceLevel = _getText(attraction, 'priceLevel');
        if (_selectedPrice == 'Free' && priceLevel != 'Free') {
          return false;
        }
        if (_selectedPrice == 'Paid' && priceLevel == 'Free') {
          return false;
        }
      }
      
      // 评分筛选
      if (attraction['rating'] < _minRating) {
        return false;
      }
      
      // 搜索关键词筛选（如果有）
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        final name = _getText(attraction, 'name').toLowerCase();
        final address = _getText(attraction, 'address').toLowerCase();
        if (!name.contains(query) && !address.contains(query)) {
          return false;
        }
      }
      
      return true;
    }).toList()
    ..sort((a, b) {
      // 排序
      switch (_selectedSort) {
        case 'Nearest':
          return a['distance'].compareTo(b['distance']);
        case 'Highest Rated':
          return b['rating'].compareTo(a['rating']);
        case 'Lowest Price':
          // 免费排在前面
          final aPriceLevel = _getText(a, 'priceLevel');
          final bPriceLevel = _getText(b, 'priceLevel');
          if (aPriceLevel == 'Free' && bPriceLevel != 'Free') return -1;
          if (aPriceLevel != 'Free' && bPriceLevel == 'Free') return 1;
          return 0;
        default:
          return 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeService>(context).isDarkMode;
    final texts = Provider.of<LanguageService>(context).currentLanguage;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(texts['attractionsTitle'] ?? 'More Attractions'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2E8B57),
        elevation: 0,
        actions: [
          // 筛选按钮
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // 地址和搜索栏
          _buildLocationBar(isDark, texts),
          // 景区列表
          Expanded(
            child: _buildAttractionsList(isDark, texts),
          ),
        ],
      ),
    );
  }

  // 地址和搜索栏
  Widget _buildLocationBar(bool isDark, Map<String, String> texts) {
    return Container(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 当前位置显示
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Color(0xFF4CAF50),
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      texts['currentLocation'] ?? 'Current Location',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      _currentAddress,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: _changeAddress,
                icon: const Icon(Icons.edit, size: 16),
                label: Text(texts['changeLocation'] ?? 'Change'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2E8B57),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 搜索栏
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: texts['searchAttractions'] ?? 'Search attractions by name or address...',
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
                    : null,
              ),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 景区列表
  Widget _buildAttractionsList(bool isDark, Map<String, String> texts) {
    final filteredList = _filteredAttractions;
    
    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              texts['noData'] ?? 'No attractions found',
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
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final attraction = filteredList[index];
        return _buildAttractionCard(attraction, isDark, texts);
      },
    );
  }

  // 景区卡片（带大众点评评分）
  Widget _buildAttractionCard(Map<String, dynamic> attraction, bool isDark, Map<String, String> texts) {
    final tags = _getTags(attraction);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: InkWell(
        onTap: () => _showAttractionDetail(attraction, isDark, texts),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // 图片区域
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    attraction['image'],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // 距离标签
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.directions_walk, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            attraction['distance'],
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 类型标签
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E8B57),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getText(attraction, 'type'),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 内容区域
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题和评分
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getText(attraction, 'name'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8200).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Color(0xFFFF8200)),
                            const SizedBox(width: 2),
                            Text(
                              attraction['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8200),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '(${_formatNumber(attraction['reviewCount'])})',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // 地址
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _getText(attraction, 'address'),
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 标签
                  Wrap(
                    spacing: 6,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  // 价格和开放时间
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getText(attraction, 'priceLevel') == 'Free'
                              ? const Color(0xFF4CAF50).withOpacity(0.1)
                              : const Color(0xFFF44336).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          attraction['price'],
                          style: TextStyle(
                            fontSize: 12,
                            color: _getText(attraction, 'priceLevel') == 'Free'
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFF44336),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getText(attraction, 'openTime'),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 显示筛选对话框
  void _showFilterDialog() {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    final isDark = Provider.of<ThemeService>(context, listen: false).isDarkMode;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    texts['filter'] ?? 'Filter Attractions',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  // 排序方式
                  Text(texts['sort'] ?? 'Sort By', style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip(texts['nearest'] ?? 'Nearest', 'Nearest', setState),
                      _buildFilterChip(texts['highestRated'] ?? 'Highest Rated', 'Highest Rated', setState),
                      _buildFilterChip(texts['lowestPrice'] ?? 'Lowest Price', 'Lowest Price', setState),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 价格筛选
                  Text(texts['price'] ?? 'Price', style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildPriceChip(texts['all'] ?? 'All', 'All', setState),
                      _buildPriceChip(texts['free'] ?? 'Free', 'Free', setState),
                      _buildPriceChip(texts['paid'] ?? 'Paid', 'Paid', setState),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 最低评分
                  Text(texts['minimumRating'] ?? 'Minimum Rating', style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _minRating,
                          min: 0,
                          max: 5,
                          divisions: 10,
                          label: _minRating.toString(),
                          onChanged: (value) {
                            setState(() => _minRating = value);
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8200).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Color(0xFFFF8200)),
                            Text(
                              _minRating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8200),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 确认按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {}); // 刷新页面
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E8B57),
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
      },
    ).then((_) {
      setState(() {}); // 对话框关闭后刷新
    });
  }

  Widget _buildFilterChip(String label, String value, StateSetter setState) {
    final isSelected = _selectedSort == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedSort = value);
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: const Color(0xFF2E8B57).withOpacity(0.2),
      checkmarkColor: const Color(0xFF2E8B57),
    );
  }

  Widget _buildPriceChip(String label, String value, StateSetter setState) {
    final isSelected = _selectedPrice == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedPrice = value);
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: const Color(0xFF2E8B57).withOpacity(0.2),
      checkmarkColor: const Color(0xFF2E8B57),
    );
  }

  // 更换地址对话框
  void _changeAddress() {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    final TextEditingController controller = TextEditingController(text: _currentAddress);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(texts['changeLocation'] ?? 'Change Location'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: texts['enterAddress'] ?? 'Enter address',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(texts['cancel'] ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentAddress = controller.text;
                });
                Navigator.pop(context);
              },
              child: Text(texts['confirm'] ?? 'Confirm'),
            ),
          ],
        );
      },
    );
  }

  // 显示景区详情
  void _showAttractionDetail(Map<String, dynamic> attraction, bool isDark, Map<String, String> texts) {
    final tags = _getTags(attraction);
    
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // 标题
            Text(
              _getText(attraction, 'name'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            
            // 评分和地址
            Row(
              children: [
                _buildRatingStars(attraction['rating']),
                const SizedBox(width: 8),
                Text(
                  '${attraction['rating']}',
                  style: const TextStyle(color: Color(0xFFFF8200), fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${_formatNumber(attraction['reviewCount'])} reviews)',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // 地址
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  _getText(attraction, 'address'),
                  style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // 价格和开放时间
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getText(attraction, 'priceLevel') == 'Free'
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : const Color(0xFFF44336).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    attraction['price'],
                    style: TextStyle(
                      color: _getText(attraction, 'priceLevel') == 'Free'
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.access_time, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  _getText(attraction, 'openTime'),
                  style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 简介
            Text(texts['description'] ?? 'Description', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              _getText(attraction, 'description'),
              style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
            ),
            
            const SizedBox(height: 20),
            
            // 标签
            Text(texts['tags'] ?? 'Tags', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                  ),
                );
              }).toList(),
            ),
            
            const Spacer(),
            
            // 按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                    label: Text(texts['favorite'] ?? 'Favorite'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // 跳转到地图
                    },
                    icon: const Icon(Icons.map),
                    label: Text(texts['viewOnMap'] ?? 'View on Map'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E8B57),
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

  // 显示评分星星
  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;
    
    return Row(
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

  // 格式化数字
  String _formatNumber(int number) {
    if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}