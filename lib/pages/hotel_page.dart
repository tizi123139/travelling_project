import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hotel_model.dart';
import '../services/hotel_service.dart';
import '../widgets/hotel_card.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import 'hotel_booking_page.dart';

class HotelPage extends StatefulWidget {
  const HotelPage({super.key});

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  final HotelService _hotelService = HotelService();
  List<Hotel> _hotels = [];
  bool _isLoading = true;
  
  // 筛选条件
  String _selectedCity = '武汉';
  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 1));
  int _guestCount = 2;
  int _roomCount = 1;
  double _minPrice = 0;
  double _maxPrice = 5000;
  List<String> _selectedTypes = [];

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    setState(() => _isLoading = true);
    try {
      final hotels = await _hotelService.searchHotels(
        city: _selectedCity,
        checkIn: _checkInDate,
        checkOut: _checkOutDate,
        guests: _guestCount,
        rooms: _roomCount,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        types: _selectedTypes,
      );
      setState(() {
        _hotels = hotels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(texts['hotelBooking'] ?? '酒店预订'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2196F3),
      ),
      body: Column(
        children: [
          // 筛选工具栏
          _buildFilterBar(texts, isDark),
          
          // 酒店列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hotels.isEmpty
                    ? Center(child: Text(texts['noHotelsFound'] ?? '未找到酒店'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _hotels.length,
                        itemBuilder: (context, index) {
                          return HotelCard(
                            hotel: _hotels[index],
                            onBook: () => _bookHotel(_hotels[index]),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAdvancedFilter,
        backgroundColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
        child: const Icon(Icons.filter_alt, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterBar(Map<String, String> texts, bool isDark) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 城市选择
            Row(
              children: [
                Icon(Icons.location_on, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedCity,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    style: TextStyle(color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333)),
                    items: ['武汉', '北京', '上海', '广州', '西安', '苏州'].map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCity = value!);
                      _loadHotels();
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            // 日期选择
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(true),
                    icon: Icon(Icons.calendar_today, size: 16, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
                    label: Text(
                      '${_checkInDate.month}/${_checkInDate.day}',
                      style: TextStyle(color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333)),
                    ),
                  ),
                ),
                Text('→', style: TextStyle(color: isDark ? Colors.grey : Colors.black54)),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(false),
                    icon: Icon(Icons.calendar_today, size: 16, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
                    label: Text(
                      '${_checkOutDate.month}/${_checkOutDate.day}',
                      style: TextStyle(color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333)),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            // 人数和房间数
            Row(
              children: [
                _buildCounterButton(Icons.person, _guestCount, (value) {
                  setState(() => _guestCount = value);
                  _loadHotels();
                }),
                const SizedBox(width: 20),
                _buildCounterButton(Icons.hotel, _roomCount, (value) {
                  setState(() => _roomCount = value);
                  _loadHotels();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, int value, Function(int) onChanged) {
    final isDark = Provider.of<ThemeService>(context).isDarkMode;
    
    return Row(
      children: [
        Icon(icon, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.remove, size: 18),
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
          style: IconButton.styleFrom(
            backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade200,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('$value', style: TextStyle(
            fontSize: 16,
            color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
          )),
        ),
        IconButton(
          icon: const Icon(Icons.add, size: 18),
          onPressed: () => onChanged(value + 1),
          style: IconButton.styleFrom(
            backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate.isBefore(picked.add(const Duration(days: 1)))) {
            _checkOutDate = picked.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
      });
      _loadHotels();
    }
  }

  void _showAdvancedFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _buildAdvancedFilterSheet();
      },
    );
  }

  Widget _buildAdvancedFilterSheet() {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts['advancedFilter'] ?? '高级筛选',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          
          // 价格范围
          Text(
            texts['priceRange'] ?? '价格范围',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
            ),
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 10000,
            divisions: 20,
            labels: RangeLabels('¥$_minPrice', '¥$_maxPrice'),
            onChanged: (values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            },
          ),
          
          const SizedBox(height: 20),
          
          // 酒店类型
          Text(
            texts['hotelType'] ?? '酒店类型',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
            ),
          ),
          Wrap(
            spacing: 8,
            children: ['经济型', '舒适型', '豪华型', '民宿', '度假村'].map((type) {
              final isSelected = _selectedTypes.contains(type);
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTypes.add(type);
                    } else {
                      _selectedTypes.remove(type);
                    }
                  });
                },
                backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade200,
                selectedColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 30),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _minPrice = 0;
                      _maxPrice = 5000;
                      _selectedTypes.clear();
                    });
                    _loadHotels();
                  },
                  child: Text(texts['reset'] ?? '重置'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _loadHotels();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
                  ),
                  child: Text(texts['apply'] ?? '应用'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _bookHotel(Hotel hotel) async {
    // TODO: 跳转到预订详情页
   // 跳转到预订详情页，传递必要参数
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HotelBookingPage(
        hotel: hotel,
        checkIn: _checkInDate,
        checkOut: _checkOutDate,
        guests: _guestCount,
        rooms: _roomCount,
      ),
    ),
  );

  // 预订成功后可刷新列表（可选）
  if (result == true) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('预订成功！')),
    );
  }
  }
}