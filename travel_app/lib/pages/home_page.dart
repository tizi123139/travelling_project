import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import 'login_page.dart';
import '../services/api_service.dart';
import '../widgets/gif_background.dart';

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
    text: 'I want to visit Wuhan for 3 days, mainly want to see Yellow Crane Tower and East Lake, enjoy local snacks, hope to stay in a comfortable hotel near the subway, budget about 3000 yuan.'
  );

  // ============ 青绿色系定义 ============
  static const Color _primaryColor = Color(0xFF2E8B57); // 海松绿
  static const Color _secondaryColor = Color(0xFF66CDAA); // 中碧绿
  static const Color _accentColor = Color(0xFF40E0D0); // 青绿
  static const Color _darkGreen = Color(0xFF1B4D3E); // 深墨绿
  static const Color _lightGreen = Color(0xFF98FB98); // 淡绿
  static const Color _cloudWhite = Color(0xFFF0F8FF); // 云白
  static const Color _inkBlack = Color(0xFF2F4F4F); // 墨色
  static const Color _goldColor = Color(0xFFFFD700); // 金色
  static const Color _bambooLight = Color(0xFFE8D5B5); // 浅竹色
  static const Color _bambooDark = Color(0xFF8B7355); // 深竹色

  // ============ 导航方法 ============
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

  // ============ 登录弹窗 ============
  void _showLoginDialog() {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white.withOpacity(0.95),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _primaryColor.withOpacity(0.3), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [_secondaryColor.withOpacity(0.2), _primaryColor.withOpacity(0.1)],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Icon(
                    Icons.auto_awesome,
                    color: _primaryColor,
                    size: 40,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                texts['appTitle']!,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                texts['footerQuote']!,
                style: TextStyle(
                  fontSize: 12,
                  color: _primaryColor.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/login').then((value) {
                      if (value == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(texts['loginSuccess']!)),
                        );
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _darkGreen,
                    side: BorderSide(color: _primaryColor, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '${texts['login']}/${texts['register']}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _darkGreen,
                    side: BorderSide(color: _primaryColor.withOpacity(0.5), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    texts['cancel']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ 个人中心入口 ============
  void _navigateToProfile() {
    final userService = Provider.of<UserService>(context, listen: false);
    if (userService.isLoggedIn) {
      Navigator.pushNamed(context, '/profile');
    } else {
      _showLoginDialog();
    }
  }

  // ============ VIP充值 ============
  void _navigateToVip() {
    final userService = Provider.of<UserService>(context, listen: false);
    if (userService.isLoggedIn) {
      Navigator.pushNamed(context, '/vip_recharge');
    } else {
      _showLoginDialog();
    }
  }

  // ============ 竹简分隔条 ============
  Widget _buildBambooStrip() {
    return Container(
      width: 4,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _bambooLight,
            _bambooDark,
            _bambooLight,
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // ============ 金色小篆字符 ============
  Widget _buildGoldCharacter(String char) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        char,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: _goldColor,
          shadows: [
            Shadow(
              color: _goldColor.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
            Shadow(
              color: _goldColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }

  // ============ 先秦竹简风格AI生成弹窗 ============
  void _showGeneratePlanDialog(Map<String, dynamic>? planData) {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    
    final plan = planData ?? {
      'days': [
        {'day': 1, 'spots': ['Yellow Crane Tower', 'Hubu Alley', 'Yangtze River Bridge']},
        {'day': 2, 'spots': ['East Lake', 'Wuhan University', 'Chu River Han Street']},
        {'day': 3, 'spots': ['Hubei Provincial Museum', 'Guiyuan Temple']},
      ]
    };

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _goldColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: _goldColor.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                _bambooLight,
                _bambooLight.withOpacity(0.9),
                _bambooDark.withOpacity(0.3),
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // 竖向竹简纹理
              Positioned.fill(
                child: Row(
                  children: List.generate(15, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _bambooLight,
                              _bambooDark.withOpacity(0.1),
                              _bambooLight,
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              
              // 右侧金色竖排小篆
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: _goldColor, width: 2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGoldCharacter('逍'),
                      _buildGoldCharacter('遥'),
                      _buildGoldCharacter('游'),
                      const SizedBox(height: 20),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _goldColor, width: 1),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.circle,
                            color: _goldColor,
                            size: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // 左侧装饰条
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _goldColor,
                        _goldColor.withOpacity(0.5),
                        _goldColor,
                      ],
                    ),
                  ),
                ),
              ),
              
              // 内容区域
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 70),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 金色标题条
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: _goldColor, width: 1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, color: _goldColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            texts['aiPlanGenerated']!,
                            style: TextStyle(
                              color: _goldColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 竹简行程内容
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: _goldColor.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: List.generate(3, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildBambooStrip(),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${texts['day']}${index + 1}${texts['daySuffix']}',
                                            style: TextStyle(
                                              color: _goldColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: _goldColor.withOpacity(0.3),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        index == 0 
                                            ? 'Yellow Crane Tower → Hubu Alley → Yangtze River Bridge'
                                            : index == 1 
                                                ? 'East Lake → Wuhan University → Chu River Han Street'
                                                : 'Hubei Provincial Museum → Guiyuan Temple',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _darkGreen,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 印章按钮
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              foregroundColor: _darkGreen,
                              side: BorderSide(color: _goldColor.withOpacity(0.5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(texts['cancel']!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: _goldColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.transparent,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(texts['savePlan']!),
                                    backgroundColor: _darkGreen,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: _goldColor,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(texts['savePlan']!),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 底部印章
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: _goldColor.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          texts['appTitle']!,
                          style: TextStyle(
                            color: _goldColor.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generatePlan() async {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    
    print('生成AI规划: ${_aiController.text}');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_bambooLight, _bambooDark.withOpacity(0.2)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _goldColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: _goldColor),
              const SizedBox(height: 16),
              Text(
                texts['aiGenerating']!,
                style: TextStyle(color: _darkGreen),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final response = await ApiService.generatePlan(
        days: _days,
        budget: _budget,
        purpose: _purpose,
        userInput: _aiController.text,
      );

      if (context.mounted) Navigator.pop(context);

      if (response['code'] == 200) {
        _showGeneratePlanDialog(response['data']);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? texts['aiPlanGenerated']!)),
          );
          _showGeneratePlanDialog(null);
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      print('API调用失败: $e');
      if (context.mounted) _showGeneratePlanDialog(null);
    }
  }

  void _quickBook() {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    
    print('一键购票');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: _secondaryColor),
            const SizedBox(width: 8),
            Text(texts['quickBook']!),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: _darkGreen,
      ),
    );
  }

  // 外部地图跳转功能
  void _openExternalMap() {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white.withOpacity(0.95),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: _primaryColor.withOpacity(0.3), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                texts['chooseMap']!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                ),
              ),
              const SizedBox(height: 20),
              _buildMapOption(
                icon: Icons.map,
                color: _primaryColor,
                title: texts['amap']!,
                mapType: 'amap',
              ),
              _buildMapOption(
                icon: Icons.explore,
                color: _secondaryColor,
                title: texts['qqMap']!,
                mapType: 'qqmap',
              ),
              _buildMapOption(
                icon: Icons.location_on,
                color: _accentColor,
                title: texts['baiduMap']!,
                mapType: 'baidumap',
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  texts['cancel']!,
                  style: TextStyle(color: _primaryColor),
                ),
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
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(color: _darkGreen)),
      trailing: Icon(Icons.chevron_right, color: color),
      onTap: () {
        Navigator.pop(context);
        _launchMap(mapType, title);
      },
    );
  }

  Future<void> _launchMap(String mapType, String mapName) async {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    final double latitude = 30.5467;
    final double longitude = 114.2983;
    final String locationName = 'Yellow Crane Tower';
    
    Uri? url;
    
    try {
      switch (mapType) {
        case 'amap':
          url = Uri.parse(
            'amapuri://route/plan/?sourceApplication=逍遥游&dlat=$latitude&dlon=$longitude&dname=$locationName&dev=0&t=0'
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
              content: Text('$mapName ${texts['cancel']}'),
              duration: const Duration(seconds: 2),
              backgroundColor: _darkGreen,
            ),
          );
        }
      }
    } catch (e) {
      print('地图打开失败: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(texts['cancel']!),
            duration: const Duration(seconds: 2),
            backgroundColor: _darkGreen,
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

    return GifBackground(
      gifPath: 'assets/gifs/kunpeng.gif',
      primaryColor: _primaryColor,
      gifOpacity: 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            texts['appTitle']!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          backgroundColor: _primaryColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // 登录弹窗按钮
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.login, color: Colors.white, size: 20),
                onPressed: _showLoginDialog,
                tooltip: '${texts['login']}/${texts['register']}',
              ),
            ),
            
            // 个人中心按钮
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
                tooltip: userService.isLoggedIn ? texts['profile'] : '${texts['login']}/${texts['register']}',
              ),
            ),
            
            // 语言切换按钮（翻译按钮）
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: Icon(
                  languageService.isEnglish ? Icons.translate_rounded : Icons.language,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  languageService.toggleLanguage();
                },
                tooltip: languageService.isEnglish ? 'Switch to Chinese' : '切换到英文',
              ),
            ),
            
            // 主题切换
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
                tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              ),
            ),
          ],
        ),
        body: SafeArea(
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
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _primaryColor.withOpacity(0.3), width: 1),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: _primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  texts['aiTravelPlanning']!,
                  style: TextStyle(
                    fontSize: screenWidth > 400 ? 24 : 22,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  texts['footerQuote']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: _primaryColor,
                    fontStyle: FontStyle.italic,
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
      {'value': 'culturalExploration', 'label': texts['culturalExploration']!, 'icon': Icons.museum},
      {'value': 'leisureVacation', 'label': texts['leisureVacation']!, 'icon': Icons.beach_access},
      {'value': 'foodTour', 'label': texts['foodTour']!, 'icon': Icons.ramen_dining},
      {'value': 'familyTrip', 'label': texts['familyTrip']!, 'icon': Icons.family_restroom},
      {'value': 'adventure', 'label': texts['adventure']!, 'icon': Icons.hiking},
    ];

    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: _primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: _primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  texts['customizeYourTrip']!,
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
              children: [
                Expanded(
                  child: _buildCompactField(
                    texts['days']!, 
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
                    texts['budget']!, 
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                maxLines: 3,
                controller: _aiController,
                decoration: InputDecoration(
                  hintText: texts['tellAI']!,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: _primaryColor.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 20,
                      color: _primaryColor,
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 14, color: _darkGreen),
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
            color: _primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 14, color: _darkGreen),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 16, color: _primaryColor),
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
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          texts['travelPurpose']!,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.white,
            style: const TextStyle(fontSize: 14, color: _darkGreen),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.flag, size: 16, color: _primaryColor),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: _primaryColor,
            ),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option['value'] as String,
                child: Row(
                  children: [
                    Icon(
                      option['icon'] as IconData,
                      size: 16,
                      color: _primaryColor,
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
              gradient: LinearGradient(
                colors: [_primaryColor, _darkGreen],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.3),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        texts['generatePlan']!,
                        style: const TextStyle(
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _primaryColor,
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _quickBook,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_activity,
                        color: _primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        texts['quickBook']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _primaryColor,
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
        'title': texts['hotelBooking']!,
        'color': _primaryColor,
        'onTap': _navigateToHotelPage,
      },
      {
        'icon': Icons.location_on,
        'title': texts['travelLocation']!,
        'color': _secondaryColor,
        'onTap': _navigateToMapPage,
      },
      {
        'icon': Icons.restaurant,
        'title': texts['specialFood']!,
        'color': _accentColor,
        'onTap': _navigateToFoodPage,
      },
      {
        'icon': Icons.history_edu,
        'title': texts['intangibleCulture']!,
        'color': _darkGreen,
        'onTap': _navigateToCulturePage,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            texts['coreFeatures']!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _darkGreen,
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
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (data['color'] as Color).withOpacity(0.3),
                width: 1,
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
                    color: _darkGreen,
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
                texts['community']!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _darkGreen,
                ),
              ),
              TextButton(
                onPressed: _navigateToPhotoWall,
                child: Text(
                  '${texts['all']} >',
                  style: TextStyle(
                    fontSize: 12,
                    color: _primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _primaryColor.withOpacity(0.3),
              width: 1,
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
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.photo_library,
                      color: _primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          texts['photoWall']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _darkGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          texts['community']!,
                          style: TextStyle(
                            fontSize: 13,
                            color: _darkGreen.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: _primaryColor,
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
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _primaryColor.withOpacity(0.3),
              width: 1,
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
                      color: _secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.star,
                      color: _secondaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          texts['reviews']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _darkGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          texts['community']!,
                          style: TextStyle(
                            fontSize: 13,
                            color: _darkGreen.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: _secondaryColor,
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
        'title': texts['smartMap']!,
        'onTap': _navigateToSmartMap,
      },
      {
        'icon': Icons.landscape,
        'title': texts['moreAttractions']!,
        'onTap': _navigateToMoreAttractions,
      },
      {
        'icon': Icons.photo_library,
        'title': texts['photoWall']!,
        'onTap': _navigateToPhotoWall,
      },
      {
        'icon': Icons.star,
        'title': texts['reviews']!,
        'onTap': _navigateToReviews,
      },
      {
        'icon': Icons.workspace_premium,
        'title': texts['vipRecharge']!,
        'onTap': _navigateToVip,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            texts['moreFeatures']!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _darkGreen,
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
          child: Column(
            children: [
              Text(
                texts['appTitle']!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: _darkGreen,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                texts['footerQuote']!,
                style: TextStyle(
                  fontSize: 10,
                  color: _darkGreen.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                texts['copyright']!,
                style: TextStyle(
                  fontSize: 10,
                  color: _darkGreen.withOpacity(0.5),
                ),
              ),
            ],
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
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  data['icon'] as IconData,
                  color: _primaryColor,
                  size: 18,
                ),
                const SizedBox(height: 4),
                Text(
                  data['title'] as String,
                  style: TextStyle(
                    fontSize: 9,
                    color: _darkGreen,
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