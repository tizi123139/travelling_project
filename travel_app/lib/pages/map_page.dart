import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _recentSearches = [];
  
  // ============ 青绿色系定义 ============
  static const Color _primaryColor = Color(0xFF2E8B57); // 海松绿
  static const Color _secondaryColor = Color(0xFF66CDAA); // 中碧绿
  static const Color _darkGreen = Color(0xFF1B4D3E); // 深墨绿
  static const Color _lightGreen = Color(0xFF98FB98); // 淡绿
  static const Color _cloudWhite = Color(0xFFF0F8FF); // 云白

  // 武汉中心坐标
  final double _wuhanLat = 30.5467;
  final double _wuhanLng = 114.2983;

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
          '扶摇 · 云游',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 搜索栏
            _buildSearchBar(texts, isDark),
            
            // 地图预览卡片
            _buildMapPreview(isDark),
            
            // 常用功能按钮
            _buildQuickActions(texts, isDark),
            
            // 近期搜索
            if (_recentSearches.isNotEmpty) _buildRecentSearches(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(Map<String, String> texts, bool isDark) {
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
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.search, color: _primaryColor),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: texts['searchLocation'] ?? '搜索地点...',
                  hintStyle: TextStyle(color: _primaryColor.withOpacity(0.5)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) => _searchQuery = value,
                onSubmitted: (value) => _openTencentMap(value),
                style: const TextStyle(color: _darkGreen),
              ),
            ),
            IconButton(
              icon: Icon(Icons.my_location, color: _primaryColor),
              onPressed: _getCurrentLocation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPreview(bool isDark) {
    return GestureDetector(
      onTap: () => _openTencentMap(_searchQuery),
      child: Container(
        margin: const EdgeInsets.all(12),
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _lightGreen.withOpacity(0.3),
              _primaryColor.withOpacity(0.2),
            ],
          ),
          border: Border.all(
            color: _primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 80,
                    color: _primaryColor.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '扶摇直上九万里',
                    style: TextStyle(
                      fontSize: 16,
                      color: _darkGreen.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '点击打开腾讯地图',
                    style: TextStyle(
                      fontSize: 14,
                      color: _darkGreen.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.open_in_new, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '腾讯地图',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(Map<String, String> texts, bool isDark) {
    final List<Map<String, dynamic>> quickActions = [
      {'icon': Icons.restaurant, 'label': texts['nearbyFood'] ?? '附近美食', 'query': '美食'},
      {'icon': Icons.hotel, 'label': texts['nearbyHotels'] ?? '附近酒店', 'query': '酒店'},
      {'icon': Icons.local_attraction, 'label': texts['nearbyAttractions'] ?? '附近景点', 'query': '景点'},
    ];

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
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
              Icon(Icons.explore, color: _primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                '云游四方',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: quickActions.map((action) {
              final String label = action['label'] as String;
              final String query = action['query'] as String;
              
              return GestureDetector(
                onTap: () => _openTencentMap(query),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: _primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: _darkGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
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
              Icon(Icons.history, color: _primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                '最近搜索',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._recentSearches.take(3).map((search) {
            return ListTile(
              leading: Icon(Icons.location_on, color: _primaryColor, size: 18),
              title: Text(
                search['query'],
                style: const TextStyle(color: _darkGreen),
              ),
              trailing: Text(
                _formatTime(search['time']),
                style: TextStyle(
                  fontSize: 12,
                  color: _darkGreen.withOpacity(0.5),
                ),
              ),
              onTap: () => _openTencentMap(search['query']),
              dense: true,
            );
          }),
        ],
      ),
    );
  }

  // ============ 直接打开腾讯地图 ============
  Future<void> _openTencentMap(String query) async {
    String locationName = query.isEmpty ? '黄鹤楼' : query;
    String encodedLocation = Uri.encodeComponent(locationName);
    
    // 保存搜索记录
    if (query.isNotEmpty) {
      setState(() {
        _recentSearches.insert(0, {
          'query': query,
          'time': DateTime.now(),
        });
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }
    
    try {
      // 腾讯地图 App Scheme
      Uri appUrl = Uri.parse(
        'qqmap://map/routeplan?type=drive&to=$encodedLocation&tocoord=$_wuhanLat,$_wuhanLng'
      );
      
      // 腾讯地图网页版备用
      Uri webUrl = Uri.parse(
        'https://maps.qq.com/?type=search&keyword=$encodedLocation'
      );
      
      // 尝试打开 App
      if (await canLaunchUrl(appUrl)) {
        await launchUrl(appUrl);
      } else {
        // 如果没安装 App，打开网页版
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('未检测到腾讯地图App，已为您打开网页版'),
              backgroundColor: _primaryColor,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('地图打开失败: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('打开地图失败，请稍后重试'),
            backgroundColor: _darkGreen,
          ),
        );
      }
    }
  }

  void _getCurrentLocation() {
    _openTencentMap('当前位置');
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else {
      return '${difference.inDays}天前';
    }
  }
}