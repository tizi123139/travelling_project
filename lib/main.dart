import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/hotel_page.dart';
import 'pages/map_page.dart';
import 'pages/food_page.dart';
import 'pages/culture_page.dart';

// ============ 导入所有新页面 ============
import 'pages/smart_map_page.dart';           // 智能地图页面
import 'pages/photo_wall_page.dart';          // 小红书风格照片墙
import 'pages/reviews_page.dart';              // 大众点评页面
import 'pages/more_attractions_page.dart';     // 更多景区页面
import 'pages/login_page.dart';                // 登录注册页面
import 'pages/profile_page.dart';              // 个人中心页面
import 'pages/vip_recharge_page.dart';         // VIP充值页面
// =======================================

import 'services/theme_service.dart';
import 'services/language_service.dart';
import 'services/user_service.dart';           // 用户服务

void main() {
  // 确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => LanguageService()),
        ChangeNotifierProvider(create: (_) => UserService()), // 添加用户服务
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智游灵境',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2196F3),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF2196F3),
          secondary: Color(0xFF03A9F4),
          surface: Color(0xFFF5F9FF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F9FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          elevation: 4,
        ),
        // 亮色主题
cardTheme: ThemeData().cardTheme.copyWith(
  color: Colors.white,
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1976D2),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1976D2),
          secondary: Color(0xFF0D47A1),
          surface: Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 4,
        ),
       // 暗色主题
cardTheme: ThemeData.dark().cardTheme.copyWith(
  color: const Color(0xFF1E1E1E),
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
),
      ),
      themeMode: Provider.of<ThemeService>(context).themeMode,
      // ============ 完整路由配置 ============
      routes: {
        '/': (context) => const HomePage(),
        '/hotel': (context) => const HotelPage(),
        '/map': (context) => const MapPage(),
        '/food': (context) => const FoodPage(),
        '/culture': (context) => const CulturePage(),
        
        // 新页面路由
        '/smart_map': (context) => const SmartMapPage(),           // 智能地图
        '/photo_wall': (context) => const PhotoWallPage(),        // 照片墙
        '/reviews': (context) => const ReviewsPage(),             // 大众点评
        '/more_attractions': (context) => const MoreAttractionsPage(), // 更多景区
        '/login': (context) => const LoginPage(),                  // 登录注册
        '/profile': (context) => const ProfilePage(),              // 个人中心
        '/vip_recharge': (context) => const VipRechargePage(),     // VIP充值
      },
      // ====================================
      initialRoute: '/',
    );
  }
}