import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_model.dart';

class FoodService {
  static const String baseUrl = 'http://localhost:8000/api/food';

  Future<List<Food>> getFoodsByCity(String city) async {
    try {
      // 构建后端要求的Query参数：destination=城市
      final params = {'destination': city};
      final url = Uri.parse('$baseUrl/list').replace(queryParameters: params);
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('美食列表响应：${response.statusCode} - ${response.body}');
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // 适配后端统一响应格式
      if (response.statusCode == 200 && responseData['code'] == 200) {
        final List<dynamic> data = responseData['data'];
        // 转换后端字段为前端模型字段
        return data.map((item) => _convertToFoodModel(item)).toList();
      } else {
        print('获取美食列表失败：${responseData['message'] ?? '未知错误'}');
        return _getMockFoods(city);
      }
    } catch (e) {
      print('美食列表请求异常：$e');
      return _getMockFoods(city);
    }
  }
Future<Food?> getFoodDetail(String foodId) async {
    try {
      final params = {'foodId': foodId};
      final url = Uri.parse('$baseUrl/detail').replace(queryParameters: params);
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['code'] == 200) {
        final dynamic data = responseData['data'];
        return _convertToFoodModel(data, isDetail: true);
      } else {
        print('获取美食详情失败：${responseData['message']}');
        return null;
      }
    } catch (e) {
      print('美食详情请求异常：$e');
      return null;
    }
  }

   Food _convertToFoodModel(Map<String, dynamic> item, {bool isDetail = false}) {
    // 处理店铺列表（详情页才有）
    List<String> shopAddresses = [];
    if (isDetail && item['shopList'] != null) {
      shopAddresses = (item['shopList'] as List)
    .map((shop) => (shop['address'] ?? '').toString()) // 确保元素是 String
    .where((addr) => addr.isNotEmpty)
    .toList()
    .cast<String>(); // 核心修复：强转为 List<String>
    }

    return Food(
      id: item['foodId'] ?? '', // 后端foodId → 前端id
      name: item['name'] ?? '',
      city: item['destination'] ?? '', // 后端destination → 前端city
      address: shopAddresses.isNotEmpty ? shopAddresses[0] : item['recommendedShop'] ?? '', // 后端推荐店铺→前端地址
      price: (item['price'] ?? 0).toDouble(),
      rating: isDetail ? 4.5 : (item['rating'] ?? 4.0).toDouble(), // 后端无rating，前端默认值
      reviewCount: isDetail ? 1000 : (item['reviewCount'] ?? 500), // 后端无reviewCount，前端默认值
      images: [// 后端无图片，用默认图
        'https://picsum.photos/300/200?random=food${item['foodId'] ?? 0}'
      ],
      category: item['type'] ?? '特色小吃', // 后端type → 前端category
      tags: isDetail ? (item['ingredient'] as List? ?? []).cast<String>() : ['特色', '本地'], // 后端配料→前端标签
      description: item['feature'] ?? '本地特色美食，口感绝佳', // 后端feature → 前端description
      businessHours: '09:00-22:00', // 后端无，前端默认
      phone: '13800138000', // 后端无，前端默认
      latitude: 30.55 + (item['foodId'] ?? '0').hashCode % 10 / 100, // 模拟经纬度
      longitude: 114.31 + (item['foodId'] ?? '0').hashCode % 10 / 100,
      reviews: [], // 后端无评价，前端空列表
    );
  }

  Future<List<Food>> searchFoods({
    required String city,
    required String query,
    String category = '全部',
    String sortBy = 'rating',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/data/foods/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'city': city,
        'query': query,
        'category': category,
        'sort_by': sortBy,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((item) => Food.fromJson(item)).toList();
    }
    throw Exception('搜索失败');
  }

  Future<void> submitReview({
    required String foodId,
    required double rating,
    required String content,
    List<String> images = const [],
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/data/foods/$foodId/reviews'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'rating': rating,
        'content': content,
        'images': images,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('评价提交失败');
    }
  }

  List<Food> _getMockFoods(String city) {
    return [
      Food(
        id: '1',
        name: '${city}热干面',
        city: city,
        address: '${city}户部巷美食街12号',
        price: 15,
        rating: 4.7,
        reviewCount: 2345,
        images: ['https://picsum.photos/300/200?random=7'],
        category: '特色小吃',
        tags: ['早餐', '面食', '传统'],
        description: '${city}传统特色小吃，面条劲道，芝麻酱香浓。',
        businessHours: '06:00-14:00',
        phone: '13800138000',
        latitude: 30.55,
        longitude: 114.31,
        reviews: [
          FoodReview(
            id: '1',
            userId: 'user1',
            userName: '美食爱好者',
            rating: 5.0,
            content: '非常正宗的热干面，芝麻酱特别香！',
            images: [],
            likes: 24,
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
            replies: [],
          ),
        ],
      ),
      Food(
        id: '2',
        name: '${city}鸭脖',
        city: city,
        address: '${city}江汉路步行街88号',
        price: 35,
        rating: 4.5,
        reviewCount: 1876,
        images: ['https://picsum.photos/300/200?random=8'],
        category: '特色小吃',
        tags: ['辣味', '零食', '休闲'],
        description: '香辣可口的${city}特色鸭脖，回味无穷。',
        businessHours: '10:00-22:00',
        phone: '13800138001',
        latitude: 30.56,
        longitude: 114.28,
        reviews: [],
      ),
      Food(
        id: '3',
        name: '${city}火锅城',
        city: city,
        address: '${city}解放大道666号',
        price: 80,
        rating: 4.8,
        reviewCount: 3120,
        images: ['https://picsum.photos/300/200?random=9'],
        category: '火锅',
        tags: ['火锅', '聚餐', '辣'],
        description: '${city}最地道的川味火锅，汤底浓郁，食材新鲜。',
        businessHours: '11:00-24:00',
        phone: '13800138002',
        latitude: 30.57,
        longitude: 114.3,
        reviews: [],
      ),
    ];
  }
}