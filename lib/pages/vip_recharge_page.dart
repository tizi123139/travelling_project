// lib/pages/vip_recharge_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../models/user_model.dart';

class VipRechargePage extends StatefulWidget {
  const VipRechargePage({super.key});

  @override
  State<VipRechargePage> createState() => _VipRechargePageState();
}

class _VipRechargePageState extends State<VipRechargePage> {
  String _selectedPackage = 'month';
  String _selectedPayment = 'wechat';

  final List<VipPackage> _packages = [
    VipPackage(
      id: 'month',
      name: '月度会员',
      days: 30,
      price: 30.0,
      originalPrice: 45.0,
      benefits: [
        '专属行程规划',
        '酒店预订9.5折',
        '门票预订9折',
        '客服优先响应',
      ],
      isPopular: false,
      color: '0xFF2196F3',
    ),
    VipPackage(
      id: 'quarter',
      name: '季度会员',
      days: 90,
      price: 78.0,
      originalPrice: 135.0,
      benefits: [
        '月度会员全部权益',
        '酒店预订9折',
        '门票预订8.5折',
        '专属旅行顾问',
      ],
      isPopular: true,
      color: '0xFF4CAF50',
    ),
    VipPackage(
      id: 'year',
      name: '年度会员',
      days: 365,
      price: 258.0,
      originalPrice: 540.0,
      benefits: [
        '季度会员全部权益',
        '酒店预订8.5折',
        '门票预订8折',
        '生日大礼包',
        '专属客服经理',
      ],
      isPopular: false,
      color: '0xFFFFA500',
    ),
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'wechat', 'name': '微信支付', 'icon': Icons.wechat, 'color': const Color(0xFF07C160)},
    {'id': 'alipay', 'name': '支付宝', 'icon': Icons.payment, 'color': const Color(0xFF1677FF)},
    {'id': 'card', 'name': '银行卡', 'icon': Icons.credit_card, 'color': const Color(0xFFF44336)},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeService>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('VIP会员充值'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // ============ 调整上下间距，减小padding ============
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            // 头部权益展示 - 减小高度
            _buildHeader(isDark),
            
            const SizedBox(height: 8),
            
            // 会员套餐 - 减小卡片间距
            ..._packages.map((package) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: _buildPackageCard(package, isDark),
            )),
            
            const SizedBox(height: 8),
            
            // 支付方式
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: _buildPaymentSection(isDark),
            ),
            
            const SizedBox(height: 8),
            
            // 确认支付按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: _buildPayButton(isDark),
            ),
            
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ============ 头部 - 减小高度和间距 ============
  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '开通VIP会员',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '享受更多专属权益',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildBenefitItem(Icons.hotel, '酒店折扣'),
                    const SizedBox(width: 12),
                    _buildBenefitItem(Icons.local_activity, '门票折扣'),
                    const SizedBox(width: 12),
                    _buildBenefitItem(Icons.support_agent, '专属客服'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  // ============ 套餐卡片 - 减小内边距 ============
  Widget _buildPackageCard(VipPackage package, bool isDark) {
    final isSelected = _selectedPackage == package.id;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFFFA500)
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          if (package.isPopular)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '热门',
                  style: TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              text: '¥${package.price}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFA500),
                              ),
                              children: [
                                TextSpan(
                                  text: ' 原价¥${package.originalPrice}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: package.id,
                      groupValue: _selectedPackage,
                      onChanged: (value) {
                        setState(() {
                          _selectedPackage = value!;
                        });
                      },
                      activeColor: const Color(0xFFFFA500),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...package.benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFFFFA500), size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ 支付方式 - 减小内边距 ============
  Widget _buildPaymentSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '支付方式',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ..._paymentMethods.map((method) => RadioListTile<String>(
            value: method['id'],
            groupValue: _selectedPayment,
            onChanged: (value) {
              setState(() {
                _selectedPayment = value!;
              });
            },
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: (method['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    method['icon'] as IconData,
                    color: method['color'] as Color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(method['name'], style: const TextStyle(fontSize: 13)),
              ],
            ),
            activeColor: const Color(0xFFFFA500),
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          )),
        ],
      ),
    );
  }

  // ============ 支付按钮 ============
  Widget _buildPayButton(bool isDark) {
    final selectedPackage = _packages.firstWhere((p) => p.id == _selectedPackage);
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('实付：', style: TextStyle(fontSize: 14)),
            Text(
              '¥${selectedPackage.price}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFA500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handlePay,
              borderRadius: BorderRadius.circular(8),
              child: const Center(
                child: Text(
                  '确认支付',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handlePay() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('支付成功'),
        content: const Text('恭喜您成为VIP会员，开始享受专属权益吧！'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}