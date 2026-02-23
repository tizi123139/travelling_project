import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hotel_model.dart';
import 'package:intl/intl.dart';

class HotelService {
  static const String baseUrl = 'http://localhost:8000/api/hotel';

 Future<List<Hotel>> searchHotels({
  required String city,
  required DateTime checkIn,
  required DateTime checkOut,
  required int guests,
  required int rooms,
  double minPrice = 0,
  double maxPrice = 5000,
  List<String> types = const [],
}) async {
  try {
    // 格式化日期为 yyyy-MM-dd（后端要求）
    final checkInStr = DateFormat('yyyy-MM-dd').format(checkIn);
    final checkOutStr = DateFormat('yyyy-MM-dd').format(checkOut);

    // 构建 Query 参数（后端要求通过URL传递）
    final params = {
      'destination': city,
      'checkIn': checkInStr,
      'checkOut': checkOutStr,
      'priceMin': minPrice.toInt().toString(),
      'priceMax': maxPrice.toInt().toString(),
      // 后端星级参数为 starLevel（三星/四星/五星），前端类型需映射，暂时传空
      'starLevel': '',
    };

    // 拼接URL和参数
    final url = Uri.parse('$baseUrl/list').replace(queryParameters: params);
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('酒店列表响应：${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['code'] == 200) {
        // 解析后端统一响应格式中的 data 字段
        final List<dynamic> data = responseData['data'];
        return data.map((item) => Hotel.fromJson(item)).toList();
      } else {
        print('搜索酒店失败：${responseData['message']}');
        return _getMockHotels(city);
      }
    } else {
      return _getMockHotels(city);
    }
  } catch (e) {
    print('酒店搜索异常：$e');
    return _getMockHotels(city);
  }
}

  Future<Map<String, dynamic>> bookHotel({
  required String hotelId,
  required String roomType,
  required DateTime checkIn,
  required DateTime checkOut,
  required int guests,
  required int rooms,
  required String userId, // 新增：用户ID（登录后获取）
  required String contactName, // 新增：联系人姓名
  required String contactPhone, // 新增：联系人电话
}) async {
  try {
    final checkInStr = DateFormat('yyyy-MM-dd').format(checkIn);
    final checkOutStr = DateFormat('yyyy-MM-dd').format(checkOut);

    // 构建请求体（参数名严格匹配后端 HotelBookRequest）
    final body = jsonEncode({
      'hotelId': hotelId,
      'roomType': roomType,
      'checkIn': checkInStr,
      'checkOut': checkOutStr,
      'userId': userId,
      'contactName': contactName,
      'contactPhone': contactPhone,
    });

    final response = await http.post(
      Uri.parse('$baseUrl/book'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('预订响应：${response.statusCode} - ${response.body}');
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['code'] == 200) {
      return {
        'success': true,
        'data': responseData['data'],
        'message': '预订成功'
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'] ?? '预订失败'
      };
    }
  } catch (e) {
    print('预订异常：$e');
    return {
      'success': false,
      'message': '网络异常：$e'
    };
  }
}

  // 模拟数据
  List<Hotel> _getMockHotels(String city) {
    return [
      Hotel(
        id: '1',
        name: '${city}希尔顿酒店',
        city: city,
        address: '${city}市中心人民路1号',
        price: 688,
        rating: 4.8,
        reviewCount: 1243,
        images: [
          'https://picsum.photos/300/200?random=1',
          'https://picsum.photos/300/200?random=2',
        ],
        amenities: ['免费WiFi', '游泳池', '健身房', '停车场', '餐厅'],
        type: '豪华型',
        latitude: 30.55,
        longitude: 114.3,
        description: '位于${city}市中心的五星级酒店，交通便利，设施齐全。',
        roomTypes: {
          '豪华大床房': 688.0,
          '行政套房': 1288.0,
          '家庭套房': 1688.0,
        },
      ),
      Hotel(
        id: '2',
        name: '${city}如家快捷酒店',
        city: city,
        address: '${city}火车站东广场',
        price: 198,
        rating: 4.2,
        reviewCount: 892,
        images: [
          'https://picsum.photos/300/200?random=3',
          'https://picsum.photos/300/200?random=4',
        ],
        amenities: ['免费WiFi', '24小时热水', '空调'],
        type: '经济型',
        latitude: 30.56,
        longitude: 114.32,
        description: '经济实惠的连锁酒店，适合商务和旅游。',
        roomTypes: {
          '标准间': 198.0,
          '大床房': 218.0,
        },
      ),
      Hotel(
        id: '3',
        name: '${city}文化主题客栈',
        city: city,
        address: '${city}古城区文化街28号',
        price: 358,
        rating: 4.6,
        reviewCount: 567,
        images: [
          'https://picsum.photos/300/200?random=5',
          'https://picsum.photos/300/200?random=6',
        ],
        amenities: ['免费WiFi', '庭院', '茶室', '自行车租赁'],
        type: '民宿',
        latitude: 30.54,
        longitude: 114.29,
        description: '具有地方文化特色的精品客栈，体验${city}传统文化。',
        roomTypes: {
          '文化主题房': 358.0,
          '庭院景观房': 458.0,
        },
      ),
    ];
  }
}