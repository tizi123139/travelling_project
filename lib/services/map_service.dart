import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String _searchQuery = '';
  
  // 武汉的景点坐标数据
  final List<Map<String, dynamic>> _wuhanAttractions = [
    {
      'name': '黄鹤楼',
      'lat': 30.5467,
      'lng': 114.2983,
      'type': '文化古迹',
      'icon': Icons.landscape,
    },
    {
      'name': '东湖',
      'lat': 30.5539,
      'lng': 114.3601,
      'type': '自然风光',
      'icon': Icons.water,
    },
    {
      'name': '武汉大学',
      'lat': 30.5311,
      'lng': 114.3572,
      'type': '教育文化',
      'icon': Icons.school,
    },
    {
      'name': '江汉路',
      'lat': 30.5788,
      'lng': 114.2891,
      'type': '商业街区',
      'icon': Icons.shopping_bag,
    },
    {
      'name': '归元禅寺',
      'lat': 30.5606,
      'lng': 114.2534,
      'type': '宗教文化',
      'icon': Icons.temple_buddhist,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(texts['travelLocation'] ?? '旅游定位'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2196F3),
      ),
      body: Column(
        children: [
          // 搜索栏
          _buildSearchBar(texts, isDark),
          
          // 地图展示（使用模拟地图）
          Expanded(
            child: _buildMapPreview(isDark),
          ),
          
          // 景点列表
          _buildAttractionsList(texts, isDark),
        ],
      ),
    );
  }

  Widget _buildSearchBar(Map<String, String> texts, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 4,
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: texts['searchLocation'] ?? '搜索武汉的景点...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3),
                    ),
                  ),
                  style: TextStyle(
                    color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                  ),
                  onChanged: (value) => _searchQuery = value,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.my_location,
                  color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3),
                ),
                onPressed: _getCurrentLocation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapPreview(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF0F0F0),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 80,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '地图预览',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '实际应用中会集成高德/百度地图SDK',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // 模拟打开外部地图
                _showMapOptions();
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('查看详细地图'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttractionsList(Map<String, String> texts, bool isDark) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              texts['wuhanAttractions'] ?? '武汉热门景点',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _wuhanAttractions.length,
              itemBuilder: (context, index) {
                final attraction = _wuhanAttractions[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF0D47A1) : const Color(0xFFE3F2FD),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  attraction['icon'] as IconData,
                                  size: 20,
                                  color: isDark ? const Color(0xFF90CAF9) : const Color(0xFF1976D2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  attraction['type'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            attraction['name'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '坐标: ${attraction['lat']}, ${attraction['lng']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _viewAttraction(attraction);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Text(
                                texts['viewOnMap'] ?? '查看地图',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _getCurrentLocation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('定位服务'),
        content: const Text('正在获取当前位置...\n（演示功能）'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showMapOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '选择地图服务',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildMapOptionTile('高德地图', Icons.map, () {
                Navigator.pop(context);
                _openExternalMap('amap');
              }),
              _buildMapOptionTile('百度地图', Icons.explore, () {
                Navigator.pop(context);
                _openExternalMap('baidu');
              }),
              _buildMapOptionTile('腾讯地图', Icons.location_on, () {
                Navigator.pop(context);
                _openExternalMap('tencent');
              }),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapOptionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2196F3)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _openExternalMap(String type) {
    // 这里可以调用外部地图应用
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('打开地图'),
        content: Text('将使用$type打开地图...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _viewAttraction(Map<String, dynamic> attraction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(attraction['name'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('类型: ${attraction['type']}'),
            Text('坐标: ${attraction['lat']}, ${attraction['lng']}'),
            const SizedBox(height: 16),
            const Text('功能说明:'),
            const Text('- 实际应用中将显示实时地图'),
            const Text('- 支持路线规划和导航'),
            const Text('- 可以查看周边设施'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}