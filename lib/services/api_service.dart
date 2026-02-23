// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  // TODO: 替换为你的后端地址
  static const String baseUrl = 'http://localhost:8000/api';
  
  // ============ 1. 用户模块 ============
  // POST /api/users/register
  // static Future<Map<String, dynamic>> register({
  //   required String email,
  //   required String phone,
  //   required String password,
  // }) async {
  //    try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/users/register'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'email': email,
  //         'phone': phone,
  //         'password': password,
  //       }),
  //     );
  //     // 增加状态码判断
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       return jsonDecode(response.body);
  //     } else {
  //       return {'success': false, 'message': '请求失败：${response.statusCode}'};
  //     }
  //   } catch (e) {
  //     return {'success': false, 'message': '网络错误：$e'};
  //   }
  // }

  // // POST /api/users/login
  // static Future<Map<String, dynamic>> login({
  //   required String account,
  //   required String password,
  // }) async {
  //    try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/users/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'account': account,
  //         'password': password,
  //       }),
  //     );
  //     // 增加状态码和错误处理
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       return jsonDecode(response.body);
  //     } else {
  //       return {
  //         'success': false,
  //         'message': '登录失败：${response.statusCode}，${response.body}',
  //       };
  //     }
  //   } catch (e) {
  //     return {'success': false, 'message': '网络异常：$e'};
  //   }
  // }
    static Map<String, String> _headers = {
      'Content-Type': 'application/json',
    };

    // 登录接口：修正为 /api/users/login
    static Future<Map<String, dynamic>> login({
      required String username,
      required String password,
    }) async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/users/login'), // 这里改成 users/login
          headers: _headers,
          body: jsonEncode({
            'username': username,
            'password': password,
          }),
        );
        print('登录响应状态码：${response.statusCode}');
        print('登录响应原始数据：${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['code'] == 200) {
         final prefs = await SharedPreferences.getInstance();
      // 从 data 中获取 Token 数据（关键修复）
      final tokenData = responseData['data'];
      await prefs.setString('access_token', tokenData['access_token']);
      await prefs.setString('username', tokenData['username']);
      await prefs.setInt('expires_at', tokenData['expires_at']);
      return {
        'success': true,
        'data': tokenData, // 返回 Token 详情
        'message': responseData['message'] ?? '登录成功'
      };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '登录失败'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': '网络异常: $e'
      };
    }
  }

  // 注册接口：修正为 /api/users/register
  static Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'), // 这里改成 users/register
        headers: _headers,
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['code'] == 200) {
        return {
          'success': true,
          'data': responseData['data'],
          'message': responseData['message']
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '注册失败'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': '网络异常: $e'
      };
    }
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('username');
  }

  // ============ 2. 行程规划 ============
  // POST /api/travel/plan/generate
  static Future<Map<String, dynamic>> generatePlan({
    required int days,
    required double budget,
    required String purpose,
    required String userInput,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/travel/plan/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'days': days,
        'budget': budget,
        'purpose': purpose,
        'user_input': userInput,
      }),
    );
    return jsonDecode(response.body);
  }

  // GET /api/travel/plan/list
  static Future<Map<String, dynamic>> getPlanList({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/travel/plan/list?userId=$userId&page=$page&pageSize=$pageSize'),
    );
    return jsonDecode(response.body);
  }

  // GET /api/travel/plan/detail
  static Future<Map<String, dynamic>> getPlanDetail({
    required String planId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/travel/plan/detail?planId=$planId'),
    );
    return jsonDecode(response.body);
  }

  // ============ 3. 酒店服务 ============
  // GET /api/hotel/list
  static Future<Map<String, dynamic>> getHotelList({
    required String city,
    String? keyword,
    DateTime? checkIn,
    DateTime? checkOut,
    int? guests,
    int page = 1,
    int pageSize = 10,
  }) async {
    String url = '$baseUrl/hotel/list?city=$city&page=$page&pageSize=$pageSize';
    if (keyword != null) url += '&keyword=$keyword';
    if (checkIn != null) url += '&checkIn=${checkIn.toIso8601String()}';
    if (checkOut != null) url += '&checkOut=${checkOut.toIso8601String()}';
    if (guests != null) url += '&guests=$guests';
    
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  // GET /api/hotel/detail
  static Future<Map<String, dynamic>> getHotelDetail({
    required String hotelId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/hotel/detail?hotelId=$hotelId'),
    );
    return jsonDecode(response.body);
  }

  // POST /api/hotel/book
  static Future<Map<String, dynamic>> bookHotel({
    required String userId,
    required String hotelId,
    required String roomType,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required double totalPrice,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/hotel/book'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'hotelId': hotelId,
        'roomType': roomType,
        'checkIn': checkIn.toIso8601String(),
        'checkOut': checkOut.toIso8601String(),
        'guests': guests,
        'totalPrice': totalPrice,
      }),
    );
    return jsonDecode(response.body);
  }

  // ============ 4. 美食板块 ============
  // GET /api/food/list
  static Future<Map<String, dynamic>> getFoodList({
    required String city,
    String? category,
    int page = 1,
    int pageSize = 10,
  }) async {
    String url = '$baseUrl/food/list?city=$city&page=$page&pageSize=$pageSize';
    if (category != null) url += '&category=$category';
    
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  // GET /api/food/detail
  static Future<Map<String, dynamic>> getFoodDetail({
    required String foodId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/food/detail?foodId=$foodId'),
    );
    return jsonDecode(response.body);
  }

  // ============ 5. 非遗板块 ============
  // GET /api/intangible/list
  static Future<Map<String, dynamic>> getIntangibleList({
    required String city,
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/intangible/list?city=$city&page=$page&pageSize=$pageSize'),
    );
    return jsonDecode(response.body);
  }

  // GET /api/intangible/detail
  static Future<Map<String, dynamic>> getIntangibleDetail({
    required String intangibleId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/intangible/detail?intangibleId=$intangibleId'),
    );
    return jsonDecode(response.body);
  }

  // ============ 6. 景区板块 ============
  // GET /api/scenic/hot
  static Future<Map<String, dynamic>> getHotScenic({
    required String city,
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/scenic/hot?city=$city&page=$page&pageSize=$pageSize'),
    );
    return jsonDecode(response.body);
  }

  // GET /api/scenic/detail
  static Future<Map<String, dynamic>> getScenicDetail({
    required String scenicId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/scenic/detail?scenicId=$scenicId'),
    );
    return jsonDecode(response.body);
  }

  // ============ 7. 智能地图 ============
  // GET /api/map/route
  static Future<Map<String, dynamic>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    String? mode, // 'drive', 'walk', 'bike'
  }) async {
    String url = '$baseUrl/map/route?startLat=$startLat&startLng=$startLng&endLat=$endLat&endLng=$endLng';
    if (mode != null) url += '&mode=$mode';
    
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  // GET /api/map/coordinate
  static Future<Map<String, dynamic>> getCoordinate({
    required String targetId,
    required String targetType, // 'scenic', 'hotel', 'food'
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/map/coordinate?targetId=$targetId&targetType=$targetType'),
    );
    return jsonDecode(response.body);
  }

  // ============ 8. 旅游定位 ============
  // GET /api/travel/location
  static Future<Map<String, dynamic>> getTravelLocation({
    required String location,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/travel/location?location=$location'),
    );
    return jsonDecode(response.body);
  }

  // GET /api/travel/around
  static Future<Map<String, dynamic>> getAroundPoi({
    required double latitude,
    required double longitude,
    int radius = 1000, // 半径(米)
    String? type, // 'hotel', 'food', 'scenic'
    int page = 1,
    int pageSize = 20,
  }) async {
    String url = '$baseUrl/travel/around?lat=$latitude&lng=$longitude&radius=$radius&page=$page&pageSize=$pageSize';
    if (type != null) url += '&type=$type';
    
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  // ============ 9. 用户点评 ============
  // GET /api/comment/list
  static Future<Map<String, dynamic>> getCommentList({
    required String targetId,
    required String targetType, // 'scenic', 'hotel', 'food'
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/comment/list?targetId=$targetId&targetType=$targetType&page=$page&pageSize=$pageSize'),
    );
    return jsonDecode(response.body);
  }

  // POST /api/comment/publish
  static Future<Map<String, dynamic>> publishComment({
    required String userId,
    required String targetId,
    required String targetType,
    required String content,
    double rating = 5.0,
    List<String>? images,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comment/publish'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'targetId': targetId,
        'targetType': targetType,
        'content': content,
        'rating': rating,
        'images': images ?? [],
      }),
    );
    return jsonDecode(response.body);
  }

  // ============ 10. 照片模块 ============
  // GET /api/photo/wall
  static Future<Map<String, dynamic>> getPhotoWall({
    required String userId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/photo/wall?userId=$userId&page=$page&pageSize=$pageSize'),
    );
    return jsonDecode(response.body);
  }

  // POST /api/photo/upload
  static Future<Map<String, dynamic>> uploadPhoto({
    required String userId,
    required String imageBase64,
    required String description,
    required String location,
    List<String>? tags,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/photo/upload'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'image': imageBase64,
        'description': description,
        'location': location,
        'tags': tags ?? [],
      }),
    );
    return jsonDecode(response.body);
  }
}