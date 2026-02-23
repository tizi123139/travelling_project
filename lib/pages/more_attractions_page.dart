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
  String _currentAddress = '武汉市洪山区'; // 默认地址
  
  // 筛选条件
  String _selectedSort = '距离最近';
  String _selectedPrice = '全部';
  double _minRating = 3.5;
  
  // 模拟景区数据（带大众点评评分）
  final List<Map<String, dynamic>> _allAttractions = [
    {
      'id': '1',
      'name': '黄鹤楼',
      'image': 'https://picsum.photos/400/300?random=1',
      'rating': 4.8, // 大众点评评分
      'reviewCount': 12345,
      'price': '¥70',
      'priceLevel': '付费',
      'distance': '2.3km',
      'address': '武昌区蛇山西山坡特1号',
      'type': '5A景区',
      'tags': ['地标', '历史文化', '夜景'],
      'openTime': '08:00-18:00',
      'description': '江南三大名楼之一，享有"天下江山第一楼"之美誉。',
      'latitude': 30.5467,
      'longitude': 114.2983,
    },
    {
      'id': '2',
      'name': '东湖生态旅游区',
      'image': 'https://picsum.photos/400/300?random=2',
      'rating': 4.7,
      'reviewCount': 23456,
      'price': '免费',
      'priceLevel': '免费',
      'distance': '3.1km',
      'address': '洪山区东湖路',
      'type': '5A景区',
      'tags': ['自然风光', '骑行', '赏花'],
      'openTime': '全天开放',
      'description': '中国最大的城中湖，风景秀丽，适合休闲游玩。',
      'latitude': 30.5539,
      'longitude': 114.3601,
    },
    {
      'id': '3',
      'name': '湖北省博物馆',
      'image': 'https://picsum.photos/400/300?random=3',
      'rating': 4.9,
      'reviewCount': 18765,
      'price': '免费',
      'priceLevel': '免费',
      'distance': '4.5km',
      'address': '武昌区东湖路160号',
      'type': '一级博物馆',
      'tags': ['历史', '文物', '越王勾践剑'],
      'openTime': '09:00-17:00',
      'description': '馆藏文物丰富，以越王勾践剑、曾侯乙编钟闻名。',
      'latitude': 30.5623,
      'longitude': 114.3621,
    },
    {
      'id': '4',
      'name': '武汉大学',
      'image': 'https://picsum.photos/400/300?random=4',
      'rating': 4.6,
      'reviewCount': 15432,
      'price': '免费',
      'priceLevel': '免费',
      'distance': '5.2km',
      'address': '武昌区珞珈山街道',
      'type': '高等学府',
      'tags': ['樱花', '建筑', '学术'],
      'openTime': '全天开放',
      'description': '中国最美大学之一，樱花季尤为著名。',
      'latitude': 30.5311,
      'longitude': 114.3572,
    },
    {
      'id': '5',
      'name': '归元禅寺',
      'image': 'https://picsum.photos/400/300?random=5',
      'rating': 4.5,
      'reviewCount': 9876,
      'price': '¥20',
      'priceLevel': '付费',
      'distance': '6.7km',
      'address': '汉阳区翠微路20号',
      'type': '佛教寺院',
      'tags': ['祈福', '古刹', '宁静'],
      'openTime': '08:00-17:00',
      'description': '武汉著名佛教寺院，香火旺盛。',
      'latitude': 30.5606,
      'longitude': 114.2534,
    },
    {
      'id': '6',
      'name': '汉口江滩',
      'image': 'https://picsum.photos/400/300?random=6',
      'rating': 4.4,
      'reviewCount': 11234,
      'price': '免费',
      'priceLevel': '免费',
      'distance': '7.1km',
      'address': '江岸区沿江大道',
      'type': '江滩公园',
      'tags': ['江景', '散步', '夜景'],
      'openTime': '全天开放',
      'description': '长江边的大型江滩公园，适合散步观景。',
      'latitude': 30.5788,
      'longitude': 114.2891,
    },
    {
      'id': '7',
      'name': '晴川阁',
      'image': 'https://picsum.photos/400/300?random=7',
      'rating': 4.3,
      'reviewCount': 5678,
      'price': '免费',
      'priceLevel': '免费',
      'distance': '3.8km',
      'address': '汉阳区洗马长街86号',
      'type': '历史建筑',
      'tags': ['古建筑', '江景'],
      'openTime': '09:00-17:00',
      'description': '与黄鹤楼隔江相望，有"三楚胜景"之称。',
      'latitude': 30.5667,
      'longitude': 114.2833,
    },
    {
      'id': '8',
      'name': '武汉欢乐谷',
      'image': 'https://picsum.photos/400/300?random=8',
      'rating': 4.5,
      'reviewCount': 21345,
      'price': '¥200',
      'priceLevel': '付费',
      'distance': '8.3km',
      'address': '洪山区欢乐大道196号',
      'type': '主题乐园',
      'tags': ['游乐场', '亲子'],
      'openTime': '09:30-18:00',
      'description': '大型主题乐园，适合家庭游玩。',
      'latitude': 30.5892,
      'longitude': 114.3821,
    },
  ];

  // 获取筛选后的景区
  List<Map<String, dynamic>> get _filteredAttractions {
    return _allAttractions.where((attraction) {
      // 价格筛选
      if (_selectedPrice != '全部') {
        if (_selectedPrice == '免费' && attraction['priceLevel'] != '免费') {
          return false;
        }
        if (_selectedPrice == '付费' && attraction['priceLevel'] != '付费') {
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
        final name = attraction['name'].toLowerCase();
        final address = attraction['address'].toLowerCase();
        if (!name.contains(query) && !address.contains(query)) {
          return false;
        }
      }
      
      return true;
    }).toList()
    ..sort((a, b) {
      // 排序
      switch (_selectedSort) {
        case '距离最近':
          return a['distance'].compareTo(b['distance']);
        case '评分最高':
          return b['rating'].compareTo(a['rating']);
        case '价格最低':
          // 免费排在前面
          if (a['priceLevel'] == '免费' && b['priceLevel'] != '免费') return -1;
          if (a['priceLevel'] != '免费' && b['priceLevel'] == '免费') return 1;
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
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('更多景区'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2196F3),
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
          _buildLocationBar(isDark),
          // 景区列表
          Expanded(
            child: _buildAttractionsList(isDark),
          ),
        ],
      ),
    );
  }

  // 地址和搜索栏
  Widget _buildLocationBar(bool isDark) {
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
                      '当前位置',
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
                label: const Text('更换'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2196F3),
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
                hintText: '搜索景区名称或地址...',
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
  Widget _buildAttractionsList(bool isDark) {
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
              '未找到符合条件的景区',
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
        return _buildAttractionCard(attraction, isDark);
      },
    );
  }

  // 景区卡片（带大众点评评分）
  Widget _buildAttractionCard(Map<String, dynamic> attraction, bool isDark) {
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
        onTap: () => _showAttractionDetail(attraction, isDark),
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
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        attraction['type'],
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
                          attraction['name'],
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
                          attraction['address'],
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
                    children: (attraction['tags'] as List).map((tag) {
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
                          color: attraction['priceLevel'] == '免费'
                              ? const Color(0xFF4CAF50).withOpacity(0.1)
                              : const Color(0xFFF44336).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          attraction['price'],
                          style: TextStyle(
                            fontSize: 12,
                            color: attraction['priceLevel'] == '免费'
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
                        attraction['openTime'],
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
                  const Text(
                    '筛选景区',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  // 排序方式
                  const Text('排序方式', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['距离最近', '评分最高', '价格最低'].map((option) {
                      return ChoiceChip(
                        label: Text(option),
                        selected: _selectedSort == option,
                        onSelected: (selected) {
                          setState(() => _selectedSort = option);
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 价格筛选
                  const Text('价格', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['全部', '免费', '付费'].map((option) {
                      return ChoiceChip(
                        label: Text(option),
                        selected: _selectedPrice == option,
                        onSelected: (selected) {
                          setState(() => _selectedPrice = option);
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 最低评分
                  const Text('最低评分', style: TextStyle(fontWeight: FontWeight.w500)),
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
                        backgroundColor: const Color(0xFF2196F3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('确认筛选', style: TextStyle(fontSize: 16)),
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

  // 更换地址对话框
  void _changeAddress() {
    final TextEditingController controller = TextEditingController(text: _currentAddress);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('修改当前位置'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '输入地址',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentAddress = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  // 显示景区详情
  void _showAttractionDetail(Map<String, dynamic> attraction, bool isDark) {
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
              attraction['name'],
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
                  '${attraction['rating']}分',
                  style: const TextStyle(color: Color(0xFFFF8200), fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${_formatNumber(attraction['reviewCount'])}条评价)',
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
                  attraction['address'],
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
                    color: attraction['priceLevel'] == '免费'
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : const Color(0xFFF44336).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    attraction['price'],
                    style: TextStyle(
                      color: attraction['priceLevel'] == '免费'
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.access_time, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  attraction['openTime'],
                  style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 简介
            const Text('简介', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              attraction['description'],
              style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
            ),
            
            const SizedBox(height: 20),
            
            // 标签
            const Text('特色标签', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: (attraction['tags'] as List).map((tag) {
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
                    label: const Text('收藏'),
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
                    label: const Text('查看地图'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
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
      return '${(number / 10000).toStringAsFixed(1)}万';
    }
    return number.toString();
  }
}