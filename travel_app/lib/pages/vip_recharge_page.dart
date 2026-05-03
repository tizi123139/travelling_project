// lib/pages/vip_recharge_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
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
      nameEn: 'Monthly VIP',
      days: 30,
      price: 30.0,
      originalPrice: 45.0,
      benefits: [
        '专属行程规划',
        '酒店预订9.5折',
        '门票预订9折',
        '客服优先响应',
      ],
      benefitsEn: [
        'Exclusive itinerary planning',
        '5% off hotel booking',
        '10% off ticket booking',
        'Priority customer service',
      ],
      isPopular: false,
      color: '0xFF2E8B57',
    ),
    VipPackage(
      id: 'quarter',
      name: '季度会员',
      nameEn: 'Quarterly VIP',
      days: 90,
      price: 78.0,
      originalPrice: 135.0,
      benefits: [
        '月度会员全部权益',
        '酒店预订9折',
        '门票预订8.5折',
        '专属旅行顾问',
      ],
      benefitsEn: [
        'All Monthly VIP benefits',
        '10% off hotel booking',
        '15% off ticket booking',
        'Personal travel consultant',
      ],
      isPopular: true,
      color: '0xFF66CDAA',
    ),
    VipPackage(
      id: 'year',
      name: '年度会员',
      nameEn: 'Yearly VIP',
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
      benefitsEn: [
        'All Quarterly VIP benefits',
        '15% off hotel booking',
        '20% off ticket booking',
        'Birthday gift package',
        'Dedicated account manager',
      ],
      isPopular: false,
      color: '0xFFFFD700',
    ),
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'wechat', 'name': '微信支付', 'nameEn': 'WeChat Pay', 'icon': Icons.wechat, 'color': const Color(0xFF07C160)},
    {'id': 'alipay', 'name': '支付宝', 'nameEn': 'Alipay', 'icon': Icons.payment, 'color': const Color(0xFF1677FF)},
    {'id': 'card', 'name': '银行卡', 'nameEn': 'Bank Card', 'icon': Icons.credit_card, 'color': const Color(0xFFF44336)},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeService>(context).isDarkMode;
    final languageService = Provider.of<LanguageService>(context);
    final texts = languageService.currentLanguage;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(texts['vipRechargeTitle'] ?? 'VIP会员充值'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2E8B57),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 头部权益展示
            _buildHeader(isDark, texts),
            
            // 会员套餐
            ..._packages.map((package) => _buildPackageCard(package, isDark, texts)),
            
            const SizedBox(height: 16),
            
            // 支付方式
            _buildPaymentSection(isDark, texts),
            
            const SizedBox(height: 16),
            
            // 确认支付按钮
            _buildPayButton(isDark, texts),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Map<String, String> texts) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            texts['vipMember'] ?? 'VIP会员',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            texts['vipBenefits'] ?? '开通VIP会员，享受更多权益',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBenefitItem(Icons.hotel, texts['hotelBooking'] ?? '酒店折扣', isDark),
              _buildBenefitItem(Icons.local_activity, texts['attraction'] ?? '门票折扣', isDark),
              _buildBenefitItem(Icons.support_agent, texts['help'] ?? '专属客服', isDark),
              _buildBenefitItem(Icons.map, texts['smartMap'] ?? '专属路线', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPackageCard(VipPackage package, bool isDark, Map<String, String> texts) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final isEnglish = languageService.isEnglish;
    
    final isSelected = _selectedPackage == package.id;
    final packageName = isEnglish ? package.nameEn : package.name;
    final benefits = isEnglish ? package.benefitsEn : package.benefits;
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFFFA500)
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFFFFA500).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          if (package.isPopular)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  texts['hotRecommend'] ?? '热门推荐',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            packageName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              text: '¥${package.price}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFA500),
                              ),
                              children: [
                                TextSpan(
                                  text: ' ${texts['originalPrice'] ?? '原价'}¥${package.originalPrice}',
                                  style: TextStyle(
                                    fontSize: 14,
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
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFFFFA500), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
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

  Widget _buildPaymentSection(bool isDark, Map<String, String> texts) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final isEnglish = languageService.isEnglish;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts['paymentMethod'] ?? '支付方式',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (method['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    method['icon'] as IconData,
                    color: method['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isEnglish ? method['nameEn'] : method['name'],
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            activeColor: const Color(0xFFFFA500),
          )),
        ],
      ),
    );
  }

  Widget _buildPayButton(bool isDark, Map<String, String> texts) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final isEnglish = languageService.isEnglish;
    
    final selectedPackage = _packages.firstWhere((p) => p.id == _selectedPackage);
    final packageName = isEnglish ? selectedPackage.nameEn : selectedPackage.name;
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${texts['confirm'] ?? '确认'}：',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                '¥${selectedPackage.price}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFA500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFA500).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handlePay,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Text(
                    texts['confirmPayment'] ?? '确认支付',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${packageName} · ${selectedPackage.days}${texts['days'] ?? '天'}',
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePay() {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final isEnglish = languageService.isEnglish;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEnglish ? 'Payment Successful' : '支付成功'),
        content: Text(isEnglish 
            ? 'Congratulations! You are now a VIP member.'
            : '恭喜您成为VIP会员，开始享受专属权益吧！'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(isEnglish ? 'OK' : '确定'),
          ),
        ],
      ),
    );
  }
}

// VIP套餐模型（需要添加到这个文件）
class VipPackage {
  final String id;
  final String name;
  final String nameEn;
  final int days;
  final double price;
  final double originalPrice;
  final List<String> benefits;
  final List<String> benefitsEn;
  final bool isPopular;
  final String color;

  VipPackage({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.days,
    required this.price,
    required this.originalPrice,
    required this.benefits,
    required this.benefitsEn,
    this.isPopular = false,
    required this.color,
  });
}