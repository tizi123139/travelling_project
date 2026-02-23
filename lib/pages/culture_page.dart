import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/culture_model.dart';
import '../services/culture_service.dart';
import '../widgets/culture_card.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

class CulturePage extends StatefulWidget {
  const CulturePage({super.key});

  @override
  State<CulturePage> createState() => _CulturePageState();
}

class _CulturePageState extends State<CulturePage> {
  final CultureService _cultureService = CultureService();
  List<CultureItem> _cultureItems = [];
  List<CultureItem> _filteredItems = [];
  bool _isLoading = true;
  String _selectedCategory = '全部';
  String _selectedRegion = '全部';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['全部', '传统技艺', '表演艺术', '民俗活动', '传统医药', '口头传统'];
  final List<String> _regions = ['全部', '华中', '华东', '华南', '华北', '西南', '西北', '东北'];

  @override
  void initState() {
    super.initState();
    _loadCultureItems();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCultureItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await _cultureService.getAllCultureItems();
      setState(() {
        _cultureItems = items;
        _filteredItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _cultureItems;
      } else {
        _filteredItems = _cultureItems.where((item) {
          return item.name.toLowerCase().contains(query) ||
                 item.description.toLowerCase().contains(query) ||
                 item.tags.any((tag) => tag.toLowerCase().contains(query));
        }).toList();
      }
    });
    _applyFilters();
  }

  void _applyFilters() {
    List<CultureItem> filtered = _cultureItems;

    // 类别筛选
    if (_selectedCategory != '全部') {
      filtered = filtered.where((item) => item.category == _selectedCategory).toList();
    }

    // 地区筛选
    if (_selectedRegion != '全部') {
      filtered = filtered.where((item) => item.region == _selectedRegion).toList();
    }

    // 搜索筛选
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(query) ||
               item.description.toLowerCase().contains(query);
      }).toList();
    }

    setState(() => _filteredItems = filtered);
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(texts['intangibleCulture'] ?? '非遗文化'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2196F3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewPost,
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          _buildSearchBar(texts, isDark),
          
          // 筛选栏
          _buildFilterBar(isDark),
          
          // 内容列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredItems.isEmpty
                    ? Center(child: Text(texts['noCultureItems'] ?? '未找到非遗项目'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          return CultureCard(
                            cultureItem: _filteredItems[index],
                            onTap: () => _showCultureDetail(_filteredItems[index]),
                            onLike: () => _likeItem(_filteredItems[index]),
                            onShare: () => _shareItem(_filteredItems[index]),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewPost,
        backgroundColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
        child: const Icon(Icons.edit, color: Colors.white),
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
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: texts['searchCulture'] ?? '搜索非遗项目...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
                  ),
                  style: TextStyle(color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333)),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 类别筛选
            Text('类别：', style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
            )),
            Wrap(
              spacing: 8,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = category);
                    _applyFilters();
                  },
                  backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade200,
                  selectedColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
                  labelStyle: TextStyle(
                    color: isSelected 
                        ? Colors.white 
                        : (isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333)),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 12),
            
            // 地区筛选
            Text('地区：', style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
            )),
            Wrap(
              spacing: 8,
              children: _regions.map((region) {
                final isSelected = _selectedRegion == region;
                return FilterChip(
                  label: Text(region),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedRegion = region);
                    _applyFilters();
                  },
                  backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade200,
                  selectedColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
                  labelStyle: TextStyle(
                    color: isSelected 
                        ? Colors.white 
                        : (isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCultureDetail(CultureItem item) {
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
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
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
              
              // 标签和统计
              Row(
                children: [
                  Chip(
                    label: Text(item.category),
                    backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade200,
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(item.region),
                    backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade200,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.red, size: 16),
                      Text(' ${item.likes}', style: TextStyle(
                        color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                      )),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // 图片展示
              if (item.images.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(item.images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              
              const SizedBox(height: 20),
              
              // 描述
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    item.description,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 操作按钮
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.favorite_border, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
                      label: Text(texts['like'] ?? '点赞'),
                      onPressed: () => _likeItem(item),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.share, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
                      label: Text(texts['share'] ?? '分享'),
                      onPressed: () => _shareItem(item),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 体验按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _bookExperience(item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(texts['bookExperience'] ?? '预约体验'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _createNewPost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _buildCreatePostSheet();
      },
    );
  }

  Widget _buildCreatePostSheet() {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts['createPost'] ?? '创建新帖子',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF333333),
            ),
          ),
          
          const SizedBox(height: 20),
          
          TextField(
            decoration: InputDecoration(
              labelText: texts['title'] ?? '标题',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 1,
          ),
          
          const SizedBox(height: 12),
          
          TextField(
            decoration: InputDecoration(
              labelText: texts['content'] ?? '内容',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 4,
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.photo, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.videocam, color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3)),
                onPressed: () {},
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(texts['cancel'] ?? '取消'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
                ),
                child: Text(texts['publish'] ?? '发布'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _likeItem(CultureItem item) {
    setState(() {
      final index = _cultureItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _cultureItems[index] = _cultureItems[index].copyWith(
          likes: _cultureItems[index].likes + 1,
        );
        _applyFilters();
      }
    });
  }

  void _shareItem(CultureItem item) {
    // TODO: 实现分享功能
    print('分享：${item.name}');
  }

  void _bookExperience(CultureItem item) {
    // TODO: 跳转到体验预约页面
    print('预约体验：${item.name}');
  }
}