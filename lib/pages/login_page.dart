// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/user_service.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isPasswordVisible = false;
  bool _agreeTerms = false;
  
  // 登录表单
  final TextEditingController _loginAccountController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  
  // 注册表单
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPhoneController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _registerConfirmController = TextEditingController();
  final TextEditingController _registerCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginAccountController.dispose();
    _loginPasswordController.dispose();
    _registerEmailController.dispose();
    _registerPhoneController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmController.dispose();
    _registerCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeService>(context).isDarkMode;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '欢迎使用九州Traveling',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Logo区域
            Container(
              height: screenHeight * 0.15,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.travel_explore,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '九州Traveling',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab切换
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                tabs: const [
                  Tab(text: '登录'),
                  Tab(text: '注册'),
                ],
              ),
            ),
            
            // Tab内容
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLoginTab(isDark),
                  _buildRegisterTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 登录Tab
  Widget _buildLoginTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '欢迎回来',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '请登录您的账号继续旅程',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 30),
          
          // 账号输入
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            child: TextField(
              controller: _loginAccountController,
              decoration: InputDecoration(
                labelText: '邮箱/手机号/用户名',
                prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF2196F3)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          ),
          const SizedBox(height: 16),
          
          // 密码输入
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            child: TextField(
              controller: _loginPasswordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: '密码',
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2196F3)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          ),
          
          // 忘记密码
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                '忘记密码？',
                style: TextStyle(color: Color(0xFF2196F3)),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 登录按钮
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2196F3).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleLogin,
                borderRadius: BorderRadius.circular(16),
                child: const Center(
                  child: Text(
                    '登录',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // 第三方登录
          const Center(
            child: Text('其他登录方式', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialLoginButton(
                icon: Icons.wechat,
                color: const Color(0xFF07C160),
                onTap: () {},
              ),
              const SizedBox(width: 20),
              _buildSocialLoginButton(
                icon: Icons.wechat,
                color: const Color(0xFF12B7F5),
                onTap: () {},
              ),
              const SizedBox(width: 20),
              _buildSocialLoginButton(
                icon: Icons.wechat,
                color: const Color(0xFFFA5151),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 注册Tab
  Widget _buildRegisterTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '创建账号',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '加入九州Traveling，开启智能旅程',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 30),
          
          // 邮箱输入
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            child: TextField(
              controller: _registerEmailController,
              decoration: const InputDecoration(
                labelText: '邮箱',
                prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF2196F3)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          ),
          const SizedBox(height: 16),
          
          // 手机号输入
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.phone_android, color: Color(0xFF2196F3)),
                      const SizedBox(width: 4),
                      Text(
                        '+86',
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _registerPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: '手机号',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // 验证码
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    ),
                  ),
                  child: TextField(
                    controller: _registerCodeController,
                    decoration: const InputDecoration(
                      labelText: '验证码',
                      prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF2196F3)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(12),
                      child: const Center(
                        child: Text(
                          '获取验证码',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 密码
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            child: TextField(
              controller: _registerPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '密码',
                prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF2196F3)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          ),
          const SizedBox(height: 16),
          
          // 确认密码
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            child: TextField(
              controller: _registerConfirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '确认密码',
                prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF2196F3)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 同意条款
          Row(
            children: [
              Checkbox(
                value: _agreeTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeTerms = value ?? false;
                  });
                },
                activeColor: const Color(0xFF2196F3),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: '我已阅读并同意 ',
                    style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    children: [
                      TextSpan(
                        text: '用户协议',
                        style: const TextStyle(color: Color(0xFF2196F3)),
                      ),
                      TextSpan(text: ' 和 '),
                      TextSpan(
                        text: '隐私政策',
                        style: const TextStyle(color: Color(0xFF2196F3)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 注册按钮
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2196F3).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _agreeTerms ? _handleRegister : null,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Text(
                    '注册',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
    );
  }

  void _handleLogin() async {
  // 1. 输入校验
  final username = _loginAccountController.text.trim();
  final password = _loginPasswordController.text.trim();
  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('请输入账号和密码')),
    );
    return;
  }

  // 2. 调用登录服务
  final userService = Provider.of<UserService>(context, listen: false);
  final loginSuccess = await userService.login(username, password);

  // 3. 处理登录结果
  if (loginSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('登录成功，欢迎回来！')),
    );
    // 核心修复：跳转到主界面，且清空之前的路由（无法返回登录页）
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/', // 主界面路由名称
      (Route<dynamic> route) => false, // 清空所有之前的路由
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(userService.errorMessage)),
    );
  }
}

  void _handleRegister() {
    // TODO: 调用注册API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('注册成功')),
    );
    _tabController.animateTo(0); // 切换到登录页
  }
}