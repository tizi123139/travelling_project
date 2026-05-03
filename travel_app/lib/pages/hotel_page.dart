import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

class HotelPage extends StatefulWidget {
  const HotelPage({super.key});

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  String _selectedCity = '武汉';
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guests = 2;
  int _rooms = 1;
  String _selectedSort = 'recommended';
  
  final List<String> _cities = ['武汉', '北京', '上海', '广州', '深圳', '成都', '杭州', '西安'];
  final List<String> _citiesEn = ['Wuhan', 'Beijing', 'Shanghai', 'Guangzhou', 'Shenzhen', 'Chengdu', 'Hangzhou', 'Xi\'an'];
  
  final List<String> _hotelTypes = ['全部', '豪华型', '舒适型', '经济型', '民宿', '公寓'];
  final List<String> _hotelTypesEn = ['All', 'Luxury', 'Comfortable', 'Economy', 'Homestay', 'Apartment'];
  
  // 模拟酒店数据
  final List<Map<String, dynamic>> _hotels = [
    {
      'id': '1',
      'name': '武汉光谷凯悦酒店',
      'name_en': 'Hyatt Regency Wuhan',
      'image': 'https://picsum.photos/400/300?random=101',
      'rating': 4.8,
      'reviewCount': 2341,
      'price': 688,
      'originalPrice': 888,
      'type': '豪华型',
      'type_en': 'Luxury',
      'address': '洪山区珞喻路1077号',
      'address_en': '1077 Luoyu Road, Hongshan District',
      'distance': 3.5,
      'facilities': ['wifi', 'breakfast', 'parking', 'gym', 'pool'],
      'facilities_en': ['Wi-Fi', 'Breakfast', 'Parking', 'Gym', 'Pool'],
      'tags': ['近地铁', '商圈', '景观房'],
      'tags_en': ['Near Subway', 'Business District', 'View Room'],
    },
    {
      'id': '2',
      'name': '武汉万达瑞华酒店',
      'name_en': 'Wanda Reign Wuhan',
      'image': 'https://picsum.photos/400/300?random=102',
      'rating': 4.9,
      'reviewCount': 1876,
      'price': 888,
      'originalPrice': 1288,
      'type': '豪华型',
      'type_en': 'Luxury',
      'address': '武昌区水果湖街东湖路138号',
      'address_en': '138 Donghu Road, Shuiguohu Street, Wuchang District',
      'distance': 4.2,
      'facilities': ['wifi', 'breakfast', 'parking', 'gym', 'pool', 'spa'],
      'facilities_en': ['Wi-Fi', 'Breakfast', 'Parking', 'Gym', 'Pool', 'Spa'],
      'tags': ['东湖旁', '奢华', '服务好'],
      'tags_en': ['Near East Lake', 'Luxury', 'Good Service'],
    },
    {
      'id': '3',
      'name': '武汉香格里拉大酒店',
      'name_en': 'Shangri-La Wuhan',
      'image': 'https://picsum.photos/400/300?random=103',
      'rating': 4.7,
      'reviewCount': 3124,
      'price': 758,
      'originalPrice': 958,
      'type': '豪华型',
      'type_en': 'Luxury',
      'address': '江岸区建设大道700号',
      'address_en': '700 Jianshe Avenue, Jiang\'an District',
      'distance': 5.1,
      'facilities': ['wifi', 'breakfast', 'parking', 'gym', 'pool'],
      'facilities_en': ['Wi-Fi', 'Breakfast', 'Parking', 'Gym', 'Pool'],
      'tags': ['市中心', '交通便利', '老牌酒店'],
      'tags_en': ['City Center', 'Convenient', 'Classic Hotel'],
    },
    {
      'id': '4',
      'name': '武汉万科君澜酒店',
      'name_en': 'Narada Grand Hotel Wuhan',
      'image': 'https://picsum.photos/400/300?random=104',
      'rating': 4.6,
      'reviewCount': 1567,
      'price': 528,
      'originalPrice': 688,
      'type': '舒适型',
      'type_en': 'Comfortable',
      'address': '江汉区常青路177号',
      'address_en': '177 Changqing Road, Jianghan District',
      'distance': 6.3,
      'facilities': ['wifi', 'breakfast', 'parking', 'gym'],
      'facilities_en': ['Wi-Fi', 'Breakfast', 'Parking', 'Gym'],
      'tags': ['性价比高', '安静', '适合家庭'],
      'tags_en': ['Good Value', 'Quiet', 'Family Friendly'],
    },
    {
      'id': '5',
      'name': '武汉光谷万豪酒店',
      'name_en': 'Wuhan Marriott Hotel',
      'image': 'https://picsum.photos/400/300?random=105',
      'rating': 4.8,
      'reviewCount': 2034,
      'price': 698,
      'originalPrice': 898,
      'type': '豪华型',
      'type_en': 'Luxury',
      'address': '洪山区高新大道797号',
      'address_en': '797 Gaoxin Avenue, Hongshan District',
      'distance': 7.8,
      'facilities': ['wifi', 'breakfast', 'parking', 'gym', 'pool'],
      'facilities_en': ['Wi-Fi', 'Breakfast', 'Parking', 'Gym', 'Pool'],
      'tags': ['光谷', '新开业', '智能客房'],
      'tags_en': ['Optics Valley', 'New Opening', 'Smart Room'],
    },
  ];

  // 获取当前语言的城市列表
  List<String> get _displayCities {
    final isEnglish = Provider.of<LanguageService>(context, listen: false).isEnglish;
    return isEnglish ? _citiesEn : _cities;
  }

  // 获取当前语言的酒店类型列表
  List<String> get _displayHotelTypes {
    final isEnglish = Provider.of<LanguageService>(context, listen: false).isEnglish;
    return isEnglish ? _hotelTypesEn : _hotelTypes;
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;
    final isEnglish = languageService.isEnglish;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(texts['hotelTitle'] ?? 'Hotel Booking'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2E8B57),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索和筛选栏
          _buildSearchBar(isDark, texts, isEnglish),
          
          // 酒店列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _hotels.length,
              itemBuilder: (context, index) {
                return _buildHotelCard(_hotels[index], isDark, texts, isEnglish);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, Map<String, String> texts, bool isEnglish) {
    return Container(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 城市选择
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCity,
                    isExpanded: true,
                    underline: const SizedBox(),
                    dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    items: _cities.asMap().entries.map((entry) {
                      final index = entry.key;
                      final city = entry.value;
                      return DropdownMenuItem(
                        value: city,
                        child: Text(isEnglish ? _citiesEn[index] : city),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _selectDateRange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _checkInDate == null
                                ? (texts['checkIn'] ?? 'Check-in')
                                : '${_checkInDate!.month}/${_checkInDate!.day} - ${_checkOutDate!.month}/${_checkOutDate!.day}',
                            style: TextStyle(
                              color: _checkInDate == null
                                  ? (isDark ? Colors.grey.shade500 : Colors.grey.shade600)
                                  : (isDark ? Colors.white : Colors.black87),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 人数和房间选择
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.people, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<int>(
                          value: _guests,
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          items: List.generate(10, (index) {
                            return DropdownMenuItem(
                              value: index + 1,
                              child: Text(isEnglish 
                                  ? '${index + 1} ${index == 0 ? 'Guest' : 'Guests'}' 
                                  : '${index + 1} ${texts['guests'] ?? '人'}'),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              _guests = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.meeting_room, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<int>(
                          value: _rooms,
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          items: List.generate(5, (index) {
                            return DropdownMenuItem(
                              value: index + 1,
                              child: Text(isEnglish 
                                  ? '${index + 1} ${index == 0 ? 'Room' : 'Rooms'}' 
                                  : '${index + 1} ${texts['rooms'] ?? '间'}'),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              _rooms = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 搜索按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E8B57),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(texts['searchHotel'] ?? 'Search Hotels'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel, bool isDark, Map<String, String> texts, bool isEnglish) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showHotelDetail(hotel, isDark, texts, isEnglish),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 酒店图片
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    hotel['image'],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // 距离标签
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${hotel['distance']}km',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                // 酒店类型标签
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E8B57),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isEnglish ? hotel['type_en'] : hotel['type'],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 酒店名称和评分
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isEnglish ? hotel['name_en'] : hotel['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
                            const SizedBox(width: 2),
                            Text(
                              hotel['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD700),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '(${hotel['reviewCount']})',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // 地址
                  Text(
                    isEnglish ? hotel['address_en'] : hotel['address'],
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 标签
                  Wrap(
                    spacing: 6,
                    children: (isEnglish ? hotel['tags_en'] : hotel['tags']).map<Widget>((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 设施
                  Wrap(
                    spacing: 8,
                    children: (isEnglish ? hotel['facilities_en'] : hotel['facilities']).take(3).map<Widget>((facility) {
                      IconData icon;
                      if (facility.toLowerCase().contains('wifi') || facility.contains('Wi-Fi')) {
                        icon = Icons.wifi;
                      } else if (facility.toLowerCase().contains('breakfast')) {
                        icon = Icons.free_breakfast;
                      } else if (facility.toLowerCase().contains('parking')) {
                        icon = Icons.local_parking;
                      } else if (facility.toLowerCase().contains('gym')) {
                        icon = Icons.fitness_center;
                      } else if (facility.toLowerCase().contains('pool')) {
                        icon = Icons.pool;
                      } else if (facility.toLowerCase().contains('spa')) {
                        icon = Icons.spa;
                      } else {
                        icon = Icons.check_circle;
                      }
                      
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 14, color: const Color(0xFF2E8B57)),
                          const SizedBox(width: 2),
                          Text(
                            facility,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 价格和预订按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '¥${hotel['price']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E8B57),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '/${texts['night'] ?? 'night'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${texts['originalPrice'] ?? 'Original'} ¥${hotel['originalPrice']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => _bookHotel(hotel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E8B57),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(texts['bookNow'] ?? 'Book Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHotelDetail(Map<String, dynamic> hotel, bool isDark, Map<String, String> texts, bool isEnglish) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isEnglish ? hotel['name_en'] : hotel['name'],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // 评分
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${hotel['rating']} (${hotel['reviewCount']})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E8B57).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isEnglish ? hotel['type_en'] : hotel['type'],
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF2E8B57),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 图片轮播
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: 300,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage('https://picsum.photos/400/300?random=${101 + index}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 地址
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF2E8B57), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isEnglish ? hotel['address_en'] : hotel['address'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 价格
            Row(
              children: [
                const Icon(Icons.attach_money, color: Color(0xFF2E8B57), size: 18),
                const SizedBox(width: 8),
                Text(
                  '¥${hotel['price']} / ${texts['night'] ?? 'night'}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E8B57),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${texts['originalPrice'] ?? 'Original'} ¥${hotel['originalPrice']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 标签
            Wrap(
              spacing: 8,
              children: (isEnglish ? hotel['tags_en'] : hotel['tags']).map<Widget>((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // 设施
            Text(
              texts['facilities'] ?? 'Facilities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: (isEnglish ? hotel['facilities_en'] : hotel['facilities']).map<Widget>((facility) {
                IconData icon;
                if (facility.toLowerCase().contains('wifi') || facility.contains('Wi-Fi')) {
                  icon = Icons.wifi;
                } else if (facility.toLowerCase().contains('breakfast')) {
                  icon = Icons.free_breakfast;
                } else if (facility.toLowerCase().contains('parking')) {
                  icon = Icons.local_parking;
                } else if (facility.toLowerCase().contains('gym')) {
                  icon = Icons.fitness_center;
                } else if (facility.toLowerCase().contains('pool')) {
                  icon = Icons.pool;
                } else if (facility.toLowerCase().contains('spa')) {
                  icon = Icons.spa;
                } else {
                  icon = Icons.check_circle;
                }
                
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 16, color: const Color(0xFF2E8B57)),
                    const SizedBox(width: 4),
                    Text(
                      facility,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            
            const Spacer(),
            
            // 预订按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _bookHotel(hotel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E8B57),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  texts['bookNow'] ?? 'Book Now',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    final isEnglish = Provider.of<LanguageService>(context, listen: false).isEnglish;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(texts['filter'] ?? 'Filter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 酒店类型筛选
            Text(isEnglish ? 'Hotel Type' : '酒店类型'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _displayHotelTypes.map((type) {
                return FilterChip(
                  label: Text(type),
                  selected: false,
                  onSelected: (value) {},
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            
            // 价格范围
            Text(isEnglish ? 'Price Range' : '价格范围'),
            const SizedBox(height: 8),
            RangeSlider(
              values: const RangeValues(0, 2000),
              min: 0,
              max: 5000,
              onChanged: (values) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(texts['cancel'] ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(texts['confirm'] ?? 'Confirm'),
          ),
        ],
      ),
    );
  }

  void _selectDateRange() async {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    
    DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E8B57),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (range != null) {
      setState(() {
        _checkInDate = range.start;
        _checkOutDate = range.end;
      });
    }
  }

  void _bookHotel(Map<String, dynamic> hotel) {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    final isEnglish = Provider.of<LanguageService>(context, listen: false).isEnglish;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${texts['bookNow'] ?? 'Booking'} ${isEnglish ? hotel['name_en'] : hotel['name']}'),
        backgroundColor: const Color(0xFF2E8B57),
      ),
    );
  }
}