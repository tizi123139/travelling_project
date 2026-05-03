import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_model.dart';

class FoodService {
  static const String baseUrl = 'http://localhost:8000/api';

  Future<List<Food>> getFoodsByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/data/foods?city=$city'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => Food.fromJson(item)).toList();
      } else {
        return _getMockFoods(city);
      }
    } catch (e) {
      return _getMockFoods(city);
    }
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