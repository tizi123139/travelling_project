import 'package:flutter/material.dart';
import '../models/hotel_model.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback onBook;

  const HotelCard({
    super.key,
    required this.hotel,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图片
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              image: DecorationImage(
                image: NetworkImage(hotel.images.isNotEmpty 
                    ? hotel.images[0] 
                    : 'https://picsum.photos/300/200?random=hotel'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black54 : Colors.white54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          hotel.rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 信息区域
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 名称和类型
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hotel.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Chip(
                      label: Text(hotel.type),
                      backgroundColor: isDark 
                          ? const Color(0xFF2D2D2D) 
                          : Colors.grey.shade200,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 地址
                Row(
                  children: [
                    Icon(Icons.location_on, 
                        color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3), 
                        size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hotel.address,
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 设施标签
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: hotel.amenities.take(3).map((amenity) {
                    return Chip(
                      label: Text(amenity),
                      backgroundColor: isDark 
                          ? const Color(0xFF2D2D2D) 
                          : Colors.grey.shade100,
                      labelStyle: const TextStyle(fontSize: 12),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                // 价格和预订按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¥${hotel.price.toInt()}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3),
                          ),
                        ),
                        Text(
                          '${hotel.reviewCount}条评价',
                          style: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: onBook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark 
                            ? const Color(0xFF1976D2) 
                            : const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('立即预订'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}