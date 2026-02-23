import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hotel_model.dart';

class HotelService {
  static const String baseUrl = 'http://localhost:5000/api/v1';

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
      final response = await http.post(
        Uri.parse('$baseUrl/data/hotels/search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'city': city,
          'check_in': checkIn.toIso8601String(),
          'check_out': checkOut.toIso8601String(),
          'guests': guests,
          'rooms': rooms,
          'min_price': minPrice,
          'max_price': maxPrice,
          'types': types,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => Hotel.fromJson(item)).toList();
      } else {
        // 模拟数据（用于演示）
        return _getMockHotels(city);
      }
    } catch (e) {
      // 返回模拟数据
      return _getMockHotels(city);
    }
  }

  Future<HotelBooking> bookHotel({
    required String hotelId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required int rooms,
    required Map<String, int> selectedRooms,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/plans/book_hotel'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'hotel_id': hotelId,
        'check_in': checkIn.toIso8601String(),
        'check_out': checkOut.toIso8601String(),
        'guests': guests,
        'rooms': rooms,
        'selected_rooms': selectedRooms,
      }),
    );

    if (response.statusCode == 200) {
      return HotelBooking.fromJson(jsonDecode(response.body));
    }
    throw Exception('酒店预订失败');
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