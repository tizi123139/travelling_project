import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_model.dart';
import '../services/food_service.dart';
import '../widgets/food_card.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final FoodService _foodService = FoodService();
  List<Food> _foods = [];
  List<Food> _filteredFoods = [];
  bool _isLoading = true;
  String _selectedCity = '武汉';
  String _selectedCategory = '全部';
  String _sortBy = 'rating';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['全部', '特色小吃', '火锅', '烧烤', '早餐', '海鲜', '甜点', '饮品'];
  final List<String> _sortOptions = ['评分最高', '价格最低', '距离最近', '评价最多'];

  @override
  void initState() {
    super.initState();
    _loadFoods();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFoods() async {
    setState(() => _isLoading = true);
    try {
      final foods = await _foodService.getFoodsByCity(_selectedCity);
      setState(() {
        _foods = foods;
        _filteredFoods = foods;
        _isLoading = false;
      });
      _sortFoods();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredFoods = _foods;
      } else {
        _filteredFoods = _foods.where((food) {
          return food.name.toLowerCase().contains(query) ||
                 food.description.toLowerCase().contains(query) ||
                 food.tags.any((tag) => tag.toLowerCase().contains(query));
        }).toList();
      }
    });
    _sortFoods();
  }

  void _sortFoods() {
    setState(() {
      switch (_sortBy) {
        case 'rating':
          _filteredFoods.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'price':
          _filteredFoods.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'reviews':
          _filteredFoods.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
          break;
      }
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == '全部') {
        _filteredFoods = _foods;
      } else {
        _filteredFoods = _foods.where((food) => food.category == category).toList();
      }
    });
    _sortFoods();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(texts['specialFood'] ?? '特色美食'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2196F3),
      ),
      body: Column(
        children: [
          // 搜索栏
          _buildSearchBar(texts, isDark),
          
          // 分类筛选
          _buildCategoryFilter(isDark),
          
          // 排序和城市选择
          _buildSortBar(texts, isDark),
          
          // 美食列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredFoods.isEmpty
                    ? Center(child: Text(texts['noFoodFound'] ?? '未找到美食'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _filteredFoods.length,
                        itemBuilder: (context, index) {
                          return FoodCard(
                            food: _filteredFoods[index],
                            onTap: () => _showFoodDetail(_filteredFoods[index]),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(Map<String, String> texts, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: texts['searchFood'] ?? '搜索美食...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
            ),
            style: TextStyle(color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333)),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(bool isDark) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) => _filterByCategory(category),
              backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade200,
              selectedColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
              labelStyle: TextStyle(
                color: isSelected 
                    ? Colors.white 
                    : (isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortBar(Map<String, String> texts, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // 城市选择
          DropdownButton<String>(
            value: _selectedCity,
            dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            style: TextStyle(
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
              fontSize: 14,
            ),
            items: ['武汉', '北京', '上海', '广州', '成都', '西安'].map((city) {
              return DropdownMenuItem(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedCity = value!);
              _loadFoods();
            },
          ),
          
          const Spacer(),
          
          // 排序选择
          DropdownButton<String>(
            value: _sortBy,
            dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            style: TextStyle(
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
              fontSize: 14,
            ),
            items: [
              DropdownMenuItem(value: 'rating', child: Text(texts['highestRating'] ?? '评分最高')),
              DropdownMenuItem(value: 'price', child: Text(texts['lowestPrice'] ?? '价格最低')),
              DropdownMenuItem(value: 'reviews', child: Text(texts['mostReviews'] ?? '评价最多')),
            ],
            onChanged: (value) {
              setState(() => _sortBy = value!);
              _sortFoods();
            },
          ),
        ],
      ),
    );
  }

  void _showFoodDetail(Food food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final themeService = Provider.of<ThemeService>(context);
        final languageService = Provider.of<LanguageService>(context);
        final isDark = themeService.isDarkMode;
        final texts = languageService.currentLanguage;

        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    food.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              
              // 评分和价格
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(' ${food.rating.toStringAsFixed(1)}', style: TextStyle(
                    color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                  )),
                  Text(' (${food.reviewCount}条评价)', style: TextStyle(
                    color: Colors.grey,
                  )),
                  const Spacer(),
                  Text('¥${food.price}', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3),
                  )),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // 标签
              Wrap(
                spacing: 8,
                children: food.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade200,
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 20),
              
              // 描述
              Text(
                food.description,
                style: TextStyle(
                  color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 地址和营业时间
              _buildInfoRow(Icons.location_on, '地址：${food.address}', isDark),
              _buildInfoRow(Icons.access_time, '营业时间：${food.businessHours}', isDark),
              _buildInfoRow(Icons.phone, '电话：${food.phone}', isDark),
              
              const Spacer(),
              
              // 操作按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _navigateToRestaurant(food),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(texts['viewOnMap'] ?? '在地图上查看'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToRestaurant(Food food) {
    // TODO: 跳转到地图页面并定位
    Navigator.pop(context);
    print('导航到：${food.name}');
  }
}