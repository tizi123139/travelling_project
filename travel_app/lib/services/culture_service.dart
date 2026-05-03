import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/culture_model.dart';

class CultureService {
  static const String baseUrl = 'http://localhost:8000/api/intangible';

  Future<List<CultureItem>> getAllCultureItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/data/culture'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => CultureItem.fromJson(item)).toList();
      } else {
        return _getMockCultureItems();
      }
    } catch (e) {
      return _getMockCultureItems();
    }
  }

  Future<List<CultureItem>> getCultureItemsByRegion(String region) async {
    final response = await http.get(
      Uri.parse('$baseUrl/data/culture/region/$region'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((item) => CultureItem.fromJson(item)).toList();
    }
    throw Exception('获取数据失败');
  }

  Future<CulturePost> createPost({
    required String title,
    required String content,
    required List<String> images,
    required List<String> videos,
    required String cultureItemId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/culture/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'content': content,
        'images': images,
        'videos': videos,
        'culture_item_id': cultureItemId,
      }),
    );

    if (response.statusCode == 200) {
      return CulturePost.fromJson(jsonDecode(response.body));
    }
    throw Exception('发布失败');
  }

  Future<void> likeItem(String itemId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/culture/$itemId/like'),
    );

    if (response.statusCode != 200) {
      throw Exception('点赞失败');
    }
  }

  Future<CultureComment> addComment({
    required String itemId,
    required String content,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/culture/$itemId/comments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'content': content,
      }),
    );

    if (response.statusCode == 200) {
      return CultureComment.fromJson(jsonDecode(response.body));
    }
    throw Exception('评论失败');
  }

  List<CultureItem> _getMockCultureItems() {
    return [
      CultureItem(
        id: '1',
        name: '汉绣',
        category: '传统技艺',
        region: '华中',
        description: '汉绣是湖北省武汉市地方传统刺绣艺术，以色彩鲜艳、构图饱满、装饰性强而著称。',
        images: [
          'https://picsum.photos/300/200?random=10',
          'https://picsum.photos/300/200?random=11',
        ],
        tags: ['刺绣', '手工艺', '传统'],
        likes: 345,
        shares: 78,
        viewCount: 1234,
        posts: [
          CulturePost(
            id: '1',
            userId: 'user1',
            userName: '手工艺爱好者',
            title: '汉绣体验日记',
            content: '今天体验了汉绣制作，太有意思了！',
            images: ['https://picsum.photos/300/200?random=12'],
            videos: [],
            likes: 45,
            comments: 12,
            shares: 5,
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
            commentsList: [],
          ),
        ],
        experienceLocation: '武汉市汉绣博物馆',
        experienceContact: '027-88888888',
        experiencePrice: 150.0,
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
      ),
      CultureItem(
        id: '2',
        name: '楚剧',
        category: '表演艺术',
        region: '华中',
        description: '楚剧是湖北地方戏曲剧种，唱腔优美，表演生动，富有地方特色。',
        images: ['https://picsum.photos/300/200?random=13'],
        tags: ['戏曲', '表演', '传统艺术'],
        likes: 278,
        shares: 56,
        viewCount: 987,
        posts: [],
        experienceLocation: '武汉剧院',
        experienceContact: '027-99999999',
        experiencePrice: 80.0,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
      ),
      CultureItem(
        id: '3',
        name: '端午节龙舟赛',
        category: '民俗活动',
        region: '华中',
        description: '端午节划龙舟是武汉传统民俗活动，已有千年历史。',
        images: ['https://picsum.photos/300/200?random=14'],
        tags: ['端午', '龙舟', '民俗'],
        likes: 512,
        shares: 124,
        viewCount: 2345,
        posts: [],
        experienceLocation: '东湖风景区',
        experienceContact: '027-77777777',
        experiencePrice: 0.0,
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
      ),
    ];
  }
}