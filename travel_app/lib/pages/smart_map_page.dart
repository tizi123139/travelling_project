import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

class SmartMapPage extends StatefulWidget {
  const SmartMapPage({super.key});

  @override
  State<SmartMapPage> createState() => _SmartMapPageState();
}

class _SmartMapPageState extends State<SmartMapPage> {
  String _selectedCity = '武汉';
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _cities = [
    {'name': '武汉', 'count': 156},
    {'name': '苏州', 'count': 128},
    {'name': '西安', 'count': 142},
    {'name': '成都', 'count': 135},
  ];

  final List<Map<String, dynamic>> _attractions = [
    {
      'id': '1',
      'name': '黄鹤楼',
      'image': 'https://picsum.photos/200/300?random=1',
      'rating': 4.8,
      'reviews': 1234,
      'price': '¥70',
      'type': '5A景区',
      'distance': '2.3km',
      'position': '武昌区',
      'tags': ['地标', '文化', '夜景'],
    },
    {
      'id': '2',
      'name': '东湖生态旅游区',
      'image': 'https://picsum.photos/200/300?random=2',
      'rating': 4.7,
      'reviews': 2341,
      'price': '免费',
      'type': '5A景区',
      'distance': '3.1km',
      'position': '洪山区',
      'tags': ['自然', '骑行', '赏花'],
    },
    {
      'id': '3',
      'name': '湖北省博物馆',
      'image': 'https://picsum.photos/200/300?random=3',
      'rating': 4.9,
      'reviews': 3124,
      'price': '免费',
      'type': '一级博物馆',
      'distance': '4.5km',
      'position': '武昌区',
      'tags': ['历史', '文物', '必去'],
    },
    {
      'id': '4',
      'name': '武汉大学',
      'image': 'https://picsum.photos/200/300?random=4',
      'rating': 4.6,
      'reviews': 4321,
      'price': '免费',
      'type': '高等学府',
      'distance': '5.2km',
      'position': '武昌区',
      'tags': ['樱花', '建筑', '学术'],
    },
    {
      'id': '5',
      'name': '江汉路步行街',
      'image': 'https://picsum.photos/200/300?random=5',
      'rating': 4.5,
      'reviews': 5432,
      'price': '免费',
      'type': '商业街',
      'distance': '1.8km',
      'position': '江汉区',
      'tags': ['购物', '美食', '夜景'],
    },
    {
      'id': '6',
      'name': '归元禅寺',
      'image': 'https://picsum.photos/200/300?random=6',
      'rating': 4.7,
      'reviews': 2134,
      'price': '¥20',
      'type': '佛教寺院',
      'distance': '6.7km',
      'position': '汉阳区',
      'tags': ['祈福', '古刹', '宁静'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeService>(context).isDarkMode;
    final texts = Provider.of<LanguageService>(context).currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('智能地图 · 景区导览'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2196F3),
      ),
      body: Column(
        children: [
          // 城市选择器
          _buildCitySelector(isDark),
          // 搜索栏
          _buildSearchBar(isDark, texts),
          // 分类筛选
          _buildCategoryFilter(isDark),
          // 景点列表
          Expanded(
            child: _buildAttractionsList(isDark, texts),
          ),
        ],
      ),
    );
  }

  Widget _buildCitySelector(bool isDark) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _cities.length,
        itemBuilder: (context, index) {
          final city = _cities[index];
          final isSelected = _selectedCity == city['name'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCity = city['name']),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3))
                    : (isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Text(
                    city['name'],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${city['count']}',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white70
                          : (isDark ? Colors.grey.shade500 : Colors.grey.shade600),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, Map<String, String> texts) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: '搜索景区、博物馆、地标...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            suffixIcon: IconButton(
              icon: Icon(Icons.filter_list, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              onPressed: () => _showFilterDialog(context, isDark),
            ),
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(bool isDark) {
    final categories = [
      {'icon': Icons.landscape, 'label': '自然风光'},
      {'icon': Icons.museum, 'label': '博物馆'},
      {'icon': Icons.history_edu, 'label': '古迹'},
      {'icon': Icons.local_activity, 'label': '乐园'},
      {'icon': Icons.shopping_bag, 'label': '购物'},
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(category['icon'] as IconData, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                const SizedBox(width: 4),
                Text(
                  category['label'] as String,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttractionsList(bool isDark, Map<String, String> texts) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _attractions.length,
      itemBuilder: (context, index) {
        final attraction = _attractions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Card(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () => _showAttractionDetail(context, attraction, isDark),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 图片
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        attraction['image'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  attraction['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, size: 14, color: Colors.white),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${attraction['rating']}',
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            attraction['position'],
                            style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.directions_walk, size: 14, color: isDark ? Colors.grey.shade500 : Colors.grey.shade600),
                              const SizedBox(width: 2),
                              Text(
                                attraction['distance'],
                                style: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade600, fontSize: 12),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.attach_money, size: 14, color: isDark ? Colors.grey.shade500 : Colors.grey.shade600),
                              const SizedBox(width: 2),
                              Text(
                                attraction['price'],
                                style: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // 标签
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: (attraction['tags'] as List).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
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
            ),
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: const Text('筛选'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('价格区间'),
            const Slider(value: 200, min: 0, max: 500, onChanged: null),
            const Text('评分'),
            const Row(children: [Icon(Icons.star), Icon(Icons.star), Icon(Icons.star), Icon(Icons.star), Icon(Icons.star)]),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('重置')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('确定')),
        ],
      ),
    );
  }

  void _showAttractionDetail(BuildContext context, Map<String, dynamic> attraction, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
            Text(attraction['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // 更多详情...
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // 跳转到景区详情
                },
                child: const Text('查看详情'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}