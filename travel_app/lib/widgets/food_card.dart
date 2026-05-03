import 'package:flutter/material.dart';
import '../models/food_model.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图片
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(food.images.isNotEmpty 
                        ? food.images[0] 
                        : 'https://picsum.photos/100/100?random=food'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 名称
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // 评分和价格
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(
                          ' ${food.rating.toStringAsFixed(1)}',
                          style: TextStyle(
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          ' (${food.reviewCount})',
                          style: TextStyle(
                            color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '¥${food.price.toInt()}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // 分类和标签
                    Wrap(
                      spacing: 6,
                      children: [
                        Chip(
                          label: Text(food.category),
                          backgroundColor: isDark 
                              ? const Color(0xFF2D2D2D) 
                              : Colors.grey.shade200,
                          labelStyle: const TextStyle(fontSize: 12),
                        ),
                        ...food.tags.take(2).map((tag) {
                          return Chip(
                            label: Text(tag),
                            backgroundColor: isDark 
                                ? const Color(0xFF2D2D2D) 
                                : Colors.grey.shade100,
                            labelStyle: const TextStyle(fontSize: 12),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // 地址
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, 
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            food.address,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}