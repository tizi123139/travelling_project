import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import 'login_page.dart';  // 导入登录页面
import '../services/api_service.dart';  // 添加这行

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _days = 3;
  double _budget = 3000.0;
  String _purpose = 'culturalExploration';
  final TextEditingController _aiController = TextEditingController(
    text: '我想去武汉玩3天，主要想看黄鹤楼和东湖，喜欢吃当地小吃，希望住在地铁附近的舒适型酒店，预算大约3000元。'
  );

  // 导航方法
  void _navigateToHotelPage() {
    Navigator.pushNamed(context, '/hotel');
  }

  void _navigateToMapPage() {
    _openExternalMap();
  }

  void _navigateToFoodPage() {
    Navigator.pushNamed(context, '/food');
  }

  void _navigateToCulturePage() {
    Navigator.pushNamed(context, '/culture');
  }

  void _navigateToSmartMap() {
    _openExternalMap();
  }

  void _navigateToMoreAttractions() {
    Navigator.pushNamed(context, '/more_attractions');
  }

  void _navigateToPhotoWall() {
    Navigator.pushNamed(context, '/photo_wall');
  }

  void _navigateToReviews() {
    Navigator.pushNamed(context, '/reviews');
  }

  // ============ 1. 登录弹窗 ============
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.travel_explore,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '登录/注册',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '登录后体验更多功能',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/login').then((value) {
                      if (value == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('登录成功！')),
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('去登录'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('暂不登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ 2. 个人中心入口 ============
  void _navigateToProfile() {
    final userService = Provider.of<UserService>(context, listen: false);
    if (userService.isLoggedIn) {
      Navigator.pushNamed(context, '/profile');
    } else {
      _showLoginDialog();
    }
  }

  // ============ 3. VIP充值 ============
  void _navigateToVip() {
    final userService = Provider.of<UserService>(context, listen: false);
    if (userService.isLoggedIn) {
      Navigator.pushNamed(context, '/vip_recharge');
    } else {
      _showLoginDialog();
    }
  }

  // ============ 4. 一键生成弹窗（接收API返回的数据）============
void _showGeneratePlanDialog(Map<String, dynamic>? planData) {
  // 如果planData为null，使用默认数据
  final plan = planData ?? {
    'days': [
      {'day': 1, 'spots': ['黄鹤楼', '户部巷', '长江大桥']},
      {'day': 2, 'spots': ['东湖', '武汉大学', '楚河汉街']},
      {'day': 3, 'spots': ['湖北省博物馆', '归元禅寺']},
    ]
  };

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFF2196F3),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '行程规划已生成',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // 从plan数据中动态生成
                  ...List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2196F3).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '第${index + 1}天',
                              style: const TextStyle(
                                color: Color(0xFF2196F3),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              index == 0 ? '黄鹤楼 → 户部巷 → 长江大桥' :
                              index == 1 ? '东湖 → 武汉大学 → 楚河汉街' :
                              '湖北省博物馆 → 归元禅寺',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('行程已保存到个人中心')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('保存行程'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
  // ========================================

  void _generatePlan() async {
  print('生成AI规划: ${_aiController.text}');
  
  // 显示加载中
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    // 调用API
    final response = await ApiService.generatePlan(
      days: _days,
      budget: _budget,
      purpose: _purpose,
      userInput: _aiController.text,
    );

    // 关闭加载对话框
    if (context.mounted) Navigator.pop(context);

    if (response['code'] == 200) {
      // 传参给弹窗
      _showGeneratePlanDialog(response['data']);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? '生成失败')),
        );
        // 即使失败也显示默认弹窗（可选）
        _showGeneratePlanDialog(null);
      }
    }
  } catch (e) {
    // 关闭加载对话框
    if (context.mounted) Navigator.pop(context);
    
    print('API调用失败: $e');
    // 出错时显示默认弹窗
    if (context.mounted) _showGeneratePlanDialog(null);
  }
}
  void _quickBook() {
    print('一键购票');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在为您抢购最优票价...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPlanItem(String day, String plan) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              day,
              style: const TextStyle(
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              plan,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // 外部地图跳转功能
  void _openExternalMap() {
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
              const Text(
                '选择地图',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildMapOption(
                icon: Icons.map,
                color: Colors.blue,
                title: '高德地图',
                mapType: 'amap',
              ),
              _buildMapOption(
                icon: Icons.explore,
                color: Colors.green,
                title: '腾讯地图',
                mapType: 'qqmap',
              ),
              _buildMapOption(
                icon: Icons.location_on,
                color: Colors.red,
                title: '百度地图',
                mapType: 'baidumap',
              ),
              const SizedBox(height: 10),
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

  Widget _buildMapOption({
    required IconData icon,
    required Color color,
    required String title,
    required String mapType,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context);
        _launchMap(mapType, title);
      },
    );
  }

  Future<void> _launchMap(String mapType, String mapName) async {
    final double latitude = 30.5467;
    final double longitude = 114.2983;
    final String locationName = '黄鹤楼';
    
    Uri? url;
    
    try {
      switch (mapType) {
        case 'amap':
          url = Uri.parse(
            'amapuri://route/plan/?sourceApplication=九州Traveling&dlat=$latitude&dlon=$longitude&dname=$locationName&dev=0&t=0'
          );
          break;
        case 'qqmap':
          url = Uri.parse(
            'qqmap://map/routeplan?type=drive&to=$locationName&tocoord=$latitude,$longitude'
          );
          break;
        case 'baidumap':
          url = Uri.parse(
            'baidumap://map/direction?destination=$locationName&latitude=$latitude&longitude=$longitude&mode=driving'
          );
          break;
        default:
          return;
      }

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        final webUrl = Uri.parse(
          'https://maps.qq.com/?type=search&keyword=$locationName'
        );
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('未检测到$mapName，已为您打开网页版'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('地图打开失败: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('打开地图失败，请稍后重试'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _aiController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _aiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final userService = Provider.of<UserService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          texts['appTitle'] ?? '智游灵境',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2196F3),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // ============ 登录弹窗按钮 ============
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.login, color: Colors.white, size: 20),
              onPressed: _showLoginDialog,
              tooltip: '登录/注册',
            ),
          ),
          // ======================================
          
          // ============ 个人中心按钮 ============
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(
                userService.isLoggedIn ? Icons.person : Icons.person_outline,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _navigateToProfile,
              tooltip: userService.isLoggedIn ? '个人中心' : '登录/注册',
            ),
          ),
          // ======================================
          
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(
                languageService.isEnglish ? Icons.language : Icons.translate,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                languageService.toggleLanguage();
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(
                isDark ? Icons.wb_sunny : Icons.nights_stay,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                themeService.toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF121212),
                    Color(0xFF1E1E1E),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF5F9FF),
                    Color(0xFFE8F1FF),
                  ],
                ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(texts, isDark, screenWidth),
                const SizedBox(height: 20),
                _buildAICard(texts, isDark),
                const SizedBox(height: 20),
                _buildActionButtons(texts, isDark),
                const SizedBox(height: 24),
                _buildFunctionSection(texts, isDark),
                const SizedBox(height: 20),
                _buildCommunitySection(texts, isDark),
                const SizedBox(height: 20),
                _buildBottomSection(texts, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, String> texts, bool isDark, double screenWidth) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark 
                  ? const Color(0xFF1976D2).withOpacity(0.2)
                  : const Color(0xFF2196F3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.travel_explore,
              color: Color(0xFF2196F3),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  texts['aiTravelPlanning'] ?? 'AI智能旅行规划',
                  style: TextStyle(
                    fontSize: screenWidth > 400 ? 24 : 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  texts['startYourJourney'] ?? '开启您的阳光之旅',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAICard(Map<String, String> texts, bool isDark) {
    final List<Map<String, dynamic>> purposeOptions = [
      {'value': 'culturalExploration', 'label': texts['culturalExploration'] ?? '文化探索', 'icon': Icons.museum},
      {'value': 'leisureVacation', 'label': texts['leisureVacation'] ?? '休闲度假', 'icon': Icons.beach_access},
      {'value': 'foodTour', 'label': texts['foodTour'] ?? '美食之旅', 'icon': Icons.ramen_dining},
      {'value': 'familyTrip', 'label': texts['familyTrip'] ?? '家庭出游', 'icon': Icons.family_restroom},
      {'value': 'adventure', 'label': texts['adventure'] ?? '冒险探索', 'icon': Icons.hiking},
    ];

    return Card(
      elevation: isDark ? 0 : 4,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isDark 
            ? BorderSide(color: Colors.grey.shade800, width: 1)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: Color(0xFF2196F3),
                ),
                const SizedBox(width: 8),
                Text(
                  texts['customizeYourTrip'] ?? '定制您的专属旅程',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCompactField(
                    texts['days'] ?? '天数', 
                    _days.toString(), 
                    Icons.calendar_today,
                    isDark,
                    onChanged: (value) {
                      setState(() {
                        _days = int.tryParse(value) ?? 3;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCompactField(
                    texts['budget'] ?? '预算（元）', 
                    _budget.toInt().toString(), 
                    Icons.account_balance_wallet,
                    isDark,
                    onChanged: (value) {
                      setState(() {
                        _budget = double.tryParse(value) ?? 3000.0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCompactDropdown(
                    _purpose, 
                    purposeOptions, 
                    isDark,
                    onChanged: (value) {
                      setState(() {
                        _purpose = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark 
                      ? Colors.grey.shade800 
                      : Colors.grey.shade200,
                ),
              ),
              child: TextField(
                maxLines: 3,
                controller: _aiController,
                decoration: InputDecoration(
                  hintText: texts['exampleText'] ?? '例如：我想去武汉玩3天，预算3000...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 20,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactField(String label, String value, IconData icon, bool isDark, {required Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 16, color: const Color(0xFF2196F3)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactDropdown(
    String value,
    List<Map<String, dynamic>> options,
    bool isDark, {
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '目的',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
            ),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.flag, size: 16, color: Color(0xFF2196F3)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF2196F3),
            ),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option['value'] as String,
                child: Row(
                  children: [
                    Icon(
                      option['icon'] as IconData,
                      size: 16,
                      color: const Color(0xFF2196F3),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      option['label'] as String,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, String> texts, bool isDark) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2196F3).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _generatePlan,
                borderRadius: BorderRadius.circular(16),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '生成AI旅行规划',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF2196F3).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _quickBook,
                borderRadius: BorderRadius.circular(16),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_activity,
                        color: Color(0xFF2196F3),
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '一键购票',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFunctionSection(Map<String, String> texts, bool isDark) {
    final List<Map<String, dynamic>> functions = [
      {
        'icon': Icons.hotel,
        'title': texts['hotelBooking'] ?? '酒店预订',
        'color': const Color(0xFF2196F3),
        'onTap': _navigateToHotelPage,
      },
      {
        'icon': Icons.location_on,
        'title': texts['travelLocation'] ?? '旅游定位',
        'color': const Color(0xFF03A9F4),
        'onTap': _navigateToMapPage,
      },
      {
        'icon': Icons.restaurant,
        'title': texts['specialFood'] ?? '特色美食',
        'color': const Color(0xFF00BCD4),
        'onTap': _navigateToFoodPage,
      },
      {
        'icon': Icons.history_edu,
        'title': texts['intangibleCulture'] ?? '非遗文化',
        'color': const Color(0xFF673AB7),
        'onTap': _navigateToCulturePage,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '常用服务',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ),
        Row(
          children: functions.map((func) {
            return Expanded(
              child: _buildMiniFunctionCard(func, isDark),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMiniFunctionCard(Map<String, dynamic> data, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: data['onTap'] as VoidCallback,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (data['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    data['icon'] as IconData,
                    color: data['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommunitySection(Map<String, String> texts, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '社区精选',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              TextButton(
                onPressed: _navigateToPhotoWall,
                child: Text(
                  '查看全部 >',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
          child: InkWell(
            onTap: _navigateToPhotoWall,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D6D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.photo_library,
                      color: Color(0xFFFF4D6D),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '旅行日记',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '分享你的旅程 · 小红书风格',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
          child: InkWell(
            onTap: _navigateToReviews,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8200).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Color(0xFFFF8200),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '大众点评',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '真实评价 · 发现好店',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection(Map<String, String> texts, bool isDark) {
    final List<Map<String, dynamic>> functions = [
      {
        'icon': Icons.map,
        'title': texts['smartMap'] ?? '智能地图',
        'onTap': _navigateToSmartMap,
      },
      {
        'icon': Icons.landscape,
        'title': texts['moreAttractions'] ?? '更多景区',
        'onTap': _navigateToMoreAttractions,
      },
      {
        'icon': Icons.photo_library,
        'title': texts['photoWall'] ?? '照片墙',
        'onTap': _navigateToPhotoWall,
      },
      {
        'icon': Icons.star,
        'title': texts['reviews'] ?? '大众点评',
        'onTap': _navigateToReviews,
      },
      // 添加VIP充值入口
      {
        'icon': Icons.workspace_premium,
        'title': 'VIP充值',
        'onTap': _navigateToVip,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '发现更多',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.8,
            mainAxisSpacing: 8,
            crossAxisSpacing: 4,
          ),
          itemCount: functions.length,
          itemBuilder: (context, index) {
            return _buildMiniBottomCard(functions[index], isDark);
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            '© 2026 九州Traveling',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniBottomCard(Map<String, dynamic> data, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: data['onTap'] as VoidCallback,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  data['icon'] as IconData,
                  color: const Color(0xFF2196F3),
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  data['title'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}