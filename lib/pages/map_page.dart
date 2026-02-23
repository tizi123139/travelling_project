import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late WebViewController _controller;
  String _searchQuery = '';
  List<Map<String, dynamic>> _recentSearches = [];
  
  // 高德地图API配置（需要申请自己的key）
  final String _amapKey = 'YOUR_AMAP_API_KEY';
  final String _amapUrl = 'https://uri.amap.com/marker';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(_getInitialMapUrl()));
  }

  String _getInitialMapUrl() {
    // 默认显示武汉中心
    return 'https://www.openstreetmap.org/export/embed.html?bbox=114.2,30.5,114.4,30.6&layer=mapnik&marker=30.55,114.3';
  }

  String _getSearchUrl(String query) {
    // 构造高德地图搜索URL
    return '$_amapUrl?position=114.3,30.55&name=$query&src=mypage&coordinate=gaode&callnative=0';
  }

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
          
          // 地图显示
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
          
          // 常用功能按钮
          _buildQuickActions(texts, isDark),
        ],
      ),
    );
  }

  Widget _buildSearchBar(Map<String, String> texts, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: texts['searchLocation'] ?? '搜索地点...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
                  ),
                  onChanged: (value) => _searchQuery = value,
                  onSubmitted: (value) => _searchLocation(value),
                  style: TextStyle(color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333)),
                ),
              ),
              IconButton(
                icon: Icon(Icons.my_location, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
                onPressed: _getCurrentLocation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(Map<String, String> texts, bool isDark) {
    // 修复：明确指定类型
    final List<Map<String, dynamic>> quickActions = [
      {'icon': Icons.restaurant, 'label': texts['nearbyFood'] ?? '附近美食'},
      {'icon': Icons.hotel, 'label': texts['nearbyHotels'] ?? '附近酒店'},
      {'icon': Icons.local_attraction, 'label': texts['nearbyAttractions'] ?? '附近景点'},
      {'icon': Icons.directions, 'label': texts['navigation'] ?? '路线规划'},
    ];

    return Card(
      margin: const EdgeInsets.all(8),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: quickActions.map((action) {
            // 修复：明确转换类型
            final IconData icon = action['icon'] as IconData;
            final String label = action['label'] as String;
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(icon),
                  color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3),
                  onPressed: () => _handleQuickAction(label),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _searchLocation(String query) {
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
      
      _controller.loadRequest(Uri.parse(_getSearchUrl(query)));
    }
  }

  void _getCurrentLocation() {
    // TODO: 获取当前位置并显示
    _controller.loadRequest(Uri.parse(_getInitialMapUrl()));
  }

  void _handleQuickAction(String action) {
    // TODO: 根据动作类型执行相应操作
    switch (action) {
      case '附近美食':
        _searchLocation('美食');
        break;
      case '附近酒店':
        _searchLocation('酒店');
        break;
      case '附近景点':
        _searchLocation('景点');
        break;
      case '路线规划':
        _showRoutePlanning();
        break;
    }
  }

  void _showRoutePlanning() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('路线规划'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: '起点'),
                onChanged: (value) {},
              ),
              TextField(
                decoration: const InputDecoration(labelText: '终点'),
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('开始导航'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}