import 'package:flutter/material.dart';

class LanguageService with ChangeNotifier {
  Locale _currentLocale = const Locale('zh', 'CN');
  bool _isEnglish = false;

  Locale get currentLocale => _currentLocale;
  bool get isEnglish => _isEnglish;

  Map<String, String> get currentLanguage => _isEnglish ? _english : _chinese;

  void toggleLanguage() {
    _isEnglish = !_isEnglish;
    _currentLocale = _isEnglish ? const Locale('en', 'US') : const Locale('zh', 'CN');
    notifyListeners();
  }

  void setLanguage(bool isEnglish) {
    _isEnglish = isEnglish;
    _currentLocale = isEnglish ? const Locale('en', 'US') : const Locale('zh', 'CN');
    notifyListeners();
  }

  final Map<String, String> _chinese = {
    'appTitle': '九州Traveling',
    'aiTravelPlanning': 'AI智能旅行规划',
    'startYourJourney': '开启您的阳光之旅',
    'customizeYourTrip': '定制您的专属旅程',
    'days': '天数',
    'budget': '预算(元)',
    'travelPurpose': '旅游目的',
    'tellAI': '告诉AI您的详细计划',
    'exampleText': '我想去武汉玩3天，主要想看黄鹤楼和东湖...',
    'generatePlan': '生成AI旅行规划',
    'coreFeatures': '核心功能',
    'hotelBooking': '酒店预订',
    'travelLocation': '旅游定位',
    'specialFood': '特色美食',
    'intangibleCulture': '非遗文化',
    'moreFeatures': '更多功能',
    'smartMap': '智能地图',
    'moreAttractions': '更多景区',
    'photoWall': '照片墙',
    'reviews': '大众点评',
    'culturalExploration': '文化探索',
    'leisureVacation': '休闲度假',
    'foodTour': '美食之旅',
    'familyTrip': '家庭出游',
    'adventure': '冒险体验',
    'nightMode': '夜间模式',
    'english': 'English',
    'chinese': '中文',
    // 酒店页面
    'noHotelsFound': '未找到酒店',
    'advancedFilter': '高级筛选',
    'priceRange': '价格范围',
    'hotelType': '酒店类型',
    'reset': '重置',
    'apply': '应用',
    // 地图页面
    'searchLocation': '搜索地点...',
    'nearbyFood': '附近美食',
    'nearbyHotels': '附近酒店',
    'nearbyAttractions': '附近景点',
    'navigation': '路线规划',
    // 美食页面
    'noFoodFound': '未找到美食',
    'searchFood': '搜索美食...',
    'highestRating': '评分最高',
    'lowestPrice': '价格最低',
    'mostReviews': '评价最多',
    'viewOnMap': '在地图上查看',
    // 文化页面
    'noCultureItems': '未找到非遗项目',
    'searchCulture': '搜索非遗项目...',
    'like': '点赞',
    'share': '分享',
    'bookExperience': '预约体验',
    'createPost': '创建新帖子',
    'title': '标题',
    'content': '内容',
    'cancel': '取消',
    'publish': '发布',
  };

  final Map<String, String> _english = {
    'appTitle': 'JiuZhou Traveling',
    'aiTravelPlanning': 'AI Travel Planning',
    'startYourJourney': 'Start Your Sunny Journey',
    'customizeYourTrip': 'Customize Your Trip',
    'days': 'Days',
    'budget': 'Budget (¥)',
    'travelPurpose': 'Travel Purpose',
    'tellAI': 'Tell AI Your Detailed Plan',
    'exampleText': 'I want to visit Wuhan for 3 days, mainly to see Yellow Crane Tower and East Lake...',
    'generatePlan': 'Generate AI Travel Plan',
    'coreFeatures': 'Core Features',
    'hotelBooking': 'Hotel Booking',
    'travelLocation': 'Travel Location',
    'specialFood': 'Special Food',
    'intangibleCulture': 'Intangible Culture',
    'moreFeatures': 'More Features',
    'smartMap': 'Smart Map',
    'moreAttractions': 'More Attractions',
    'photoWall': 'Photo Wall',
    'reviews': 'Reviews',
    'culturalExploration': 'Cultural Exploration',
    'leisureVacation': 'Leisure Vacation',
    'foodTour': 'Food Tour',
    'familyTrip': 'Family Trip',
    'adventure': 'Adventure',
    'nightMode': 'Night Mode',
    'english': 'English',
    'chinese': '中文',
    // Hotel page
    'noHotelsFound': 'No hotels found',
    'advancedFilter': 'Advanced Filter',
    'priceRange': 'Price Range',
    'hotelType': 'Hotel Type',
    'reset': 'Reset',
    'apply': 'Apply',
    // Map page
    'searchLocation': 'Search location...',
    'nearbyFood': 'Nearby Food',
    'nearbyHotels': 'Nearby Hotels',
    'nearbyAttractions': 'Nearby Attractions',
    'navigation': 'Navigation',
    // Food page
    'noFoodFound': 'No food found',
    'searchFood': 'Search food...',
    'highestRating': 'Highest Rating',
    'lowestPrice': 'Lowest Price',
    'mostReviews': 'Most Reviews',
    'viewOnMap': 'View on Map',
    // Culture page
    'noCultureItems': 'No culture items found',
    'searchCulture': 'Search culture...',
    'like': 'Like',
    'share': 'Share',
    'bookExperience': 'Book Experience',
    'createPost': 'Create New Post',
    'title': 'Title',
    'content': 'Content',
    'cancel': 'Cancel',
    'publish': 'Publish',
  };
}