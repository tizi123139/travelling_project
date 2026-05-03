import 'package:flutter/material.dart';
import '../models/culture_model.dart';

class CultureCard extends StatelessWidget {
  final CultureItem cultureItem;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onShare;

  const CultureCard({
    super.key,
    required this.cultureItem,
    required this.onTap,
    required this.onLike,
    required this.onShare,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: NetworkImage(cultureItem.images.isNotEmpty 
                      ? cultureItem.images[0] 
                      : 'https://picsum.photos/300/200?random=culture'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题和分类
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cultureItem.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Chip(
                        label: Text(cultureItem.category),
                        backgroundColor: isDark 
                            ? const Color(0xFF2D2D2D) 
                            : Colors.grey.shade200,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 地区和标签
                  Wrap(
                    spacing: 6,
                    children: [
                      Chip(
                        label: Text(cultureItem.region),
                        backgroundColor: isDark 
                            ? const Color(0xFF2D2D2D) 
                            : Colors.grey.shade100,
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                      ...cultureItem.tags.take(2).map((tag) {
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

                  const SizedBox(height: 8),

                  // 描述
                  Text(
                    cultureItem.description,
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // 统计和操作按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                            onPressed: onLike,
                            iconSize: 20,
                          ),
                          Text(
                            cultureItem.likes.toString(),
                            style: TextStyle(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                            onPressed: onShare,
                            iconSize: 20,
                          ),
                          Text(
                            cultureItem.shares.toString(),
                            style: TextStyle(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      if (cultureItem.experiencePrice != null)
                        Text(
                          '体验价: ¥${cultureItem.experiencePrice!.toInt()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF00BCD4) : const Color(0xFF2196F3),
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
    );
  }
}