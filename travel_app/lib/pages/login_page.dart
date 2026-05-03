// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/user_service.dart';
import '../services/api_service.dart';
import 'dart:async';
import '../services/language_service.dart'; // 导入语言服务

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  bool _isLoginSelected = true;
  bool _isPasswordVisible = false;
  bool _agreeTerms = false;
  
  // 动画控制器
  late AnimationController _cloudController;
  
  // 登录表单
  final TextEditingController _loginAccountController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  
  // 注册表单
  final TextEditingController _registerUsernameController = TextEditingController();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPhoneController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _registerConfirmController = TextEditingController();
  final TextEditingController _registerCodeController = TextEditingController();
    int _countdown = 0;
  Timer? _countdownTimer;

  // ============ 青绿色系定义（与主页保持一致）============
  static const Color _primaryColor = Color(0xFF2E8B57); // 海松绿
  static const Color _secondaryColor = Color(0xFF66CDAA); // 中碧绿
  static const Color _accentColor = Color(0xFF40E0D0); // 青绿
  static const Color _darkGreen = Color(0xFF1B4D3E); // 深墨绿
  static const Color _lightGreen = Color(0xFF98FB98); // 淡绿
  static const Color _cloudWhite = Color(0xFFF0F8FF); // 云白
  static const Color _inkBlack = Color(0xFF2F4F4F); // 墨色

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cloudController.dispose();
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
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final isDark = themeService.isDarkMode;
    final texts = languageService.currentLanguage;

    return Scaffold(
      backgroundColor: _cloudWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: _darkGreen,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          texts['appTitle'] ?? '逍遥游', // 使用翻译
          style: TextStyle(
            color: _darkGreen,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 背景 - 水墨云海
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _cloudWhite,
                  _lightGreen.withOpacity(0.2),
                  _primaryColor.withOpacity(0.1),
                ],
              ),
            ),
            child: Stack(
              children: [
                // 云海浮动
                AnimatedBuilder(
                  animation: _cloudController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_cloudController.value * 30, 0),
                      child: Opacity(
                        opacity: 0.1,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage('assets/images/cloud_pattern.png'),
                              repeat: ImageRepeat.repeat,
                              colorFilter: ColorFilter.mode(
                                _primaryColor.withOpacity(0.1),
                                BlendMode.overlay,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // 鲲鹏剪影 - 左上
                Positioned(
                  top: 20,
                  left: 10,
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 80,
                      color: _primaryColor,
                    ),
                  ),
                ),
                // 鲲鹏剪影 - 右下
                Positioned(
                  bottom: 30,
                  right: 10,
                  child: Opacity(
                    opacity: 0.1,
                    child: Transform.rotate(
                      angle: 3.14,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 60,
                        color: _secondaryColor,
                      ),
                    ),
                  ),
                ),
                // 远山
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          _darkGreen.withOpacity(0.15),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 主要内容
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Container(
                    width: 280,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo区域 - 鲲鹏图标
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [_primaryColor, _darkGreen],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                texts['appTitle'] ?? '逍遥游', // 使用翻译
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _darkGreen,
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                texts['isEnglish'] == true 
                                    ? 'In the northern darkness...' 
                                    : '北冥有鱼 · 其名为鲲',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _primaryColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // 登录/注册双按钮
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isLoginSelected = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _isLoginSelected 
                                          ? _primaryColor
                                          : Colors.white.withOpacity(0.9),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      border: Border.all(
                                        color: _isLoginSelected
                                            ? _primaryColor
                                            : _primaryColor.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        texts['login'] ?? '登录', // 使用翻译
                                        style: TextStyle(
                                          color: _isLoginSelected ? Colors.white : _darkGreen,
                                          fontSize: 14,
                                          fontWeight: _isLoginSelected ? FontWeight.w600 : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isLoginSelected = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: !_isLoginSelected 
                                          ? _primaryColor
                                          : Colors.white.withOpacity(0.9),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      border: Border.all(
                                        color: !_isLoginSelected
                                            ? _primaryColor
                                            : _primaryColor.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        texts['register'] ?? '注册', // 使用翻译
                                        style: TextStyle(
                                          color: !_isLoginSelected ? Colors.white : _darkGreen,
                                          fontSize: 14,
                                          fontWeight: !_isLoginSelected ? FontWeight.w600 : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // 内容区域
                        _isLoginSelected ? _buildLoginForm(texts, isDark) : _buildRegisterForm(texts, isDark),
                      ],
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

  // ============ 登录表单 ============
  Widget _buildLoginForm(Map<String, String> texts, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        
        // 账号输入
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _loginAccountController,
            decoration: InputDecoration(
              labelText: texts['username'] ?? '邮箱/手机号/用户名', // 使用翻译
              labelStyle: TextStyle(fontSize: 12, color: _primaryColor),
              prefixIcon: Icon(Icons.person_outline, color: _primaryColor, size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: const TextStyle(fontSize: 13, color: _darkGreen),
          ),
        ),
        
        // 密码输入
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _loginPasswordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: texts['password'] ?? '密码', // 使用翻译
              labelStyle: TextStyle(fontSize: 12, color: _primaryColor),
              prefixIcon: Icon(Icons.lock_outline, color: _primaryColor, size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: _primaryColor,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: const TextStyle(fontSize: 13, color: _darkGreen),
          ),
        ),
        
        // 忘记密码
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              texts['forgotPassword'] ?? '忘记密码？', // 使用翻译
              style: TextStyle(color: _primaryColor, fontSize: 12),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 登录按钮
        Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _darkGreen],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleLogin,
              borderRadius: BorderRadius.circular(8),
              child: Center(
                child: Text(
                  texts['login'] ?? '登录', // 使用翻译
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // 第三方登录
        Center(
          child: Text(
            texts['otherLoginMethods'] ?? '其他登录方式', // 使用翻译
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialLoginButton(
              icon: Icons.wechat,
              color: const Color(0xFF07C160),
              tooltip: texts['wechatLogin'] ?? '微信登录',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(texts['wechatLogin'] ?? '微信登录开发中')),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildSocialLoginButton(
              icon: Icons.chat,
              color: const Color(0xFF12B7F5),
              tooltip: texts['qqLogin'] ?? 'QQ登录',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(texts['qqLogin'] ?? 'QQ登录开发中')),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildSocialLoginButton(
              icon: Icons.email_outlined,
              color: _primaryColor,
              tooltip: texts['emailLogin'] ?? '邮箱登录',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(texts['emailLogin'] ?? '邮箱登录开发中')),
                );
              },
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // 底部鲲鹏点缀
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: _primaryColor.withOpacity(0.2), size: 4),
            const SizedBox(width: 4),
            Icon(Icons.circle, color: _primaryColor.withOpacity(0.4), size: 6),
            const SizedBox(width: 4),
            Icon(Icons.auto_awesome, color: _primaryColor.withOpacity(0.3), size: 12),
            const SizedBox(width: 4),
            Icon(Icons.circle, color: _primaryColor.withOpacity(0.4), size: 6),
            const SizedBox(width: 4),
            Icon(Icons.circle, color: _primaryColor.withOpacity(0.2), size: 4),
          ],
        ),
      ],
    );
  }

  // ============ 注册表单 ============
  Widget _buildRegisterForm(Map<String, String> texts, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: TextField(
          controller: _registerUsernameController,
          decoration: InputDecoration(
            labelText: '用户名',
            labelStyle: TextStyle(fontSize: 12, color: _primaryColor),
            prefixIcon: Icon(Icons.person_outline, color: _primaryColor, size: 18),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
          style: const TextStyle(fontSize: 13, color: _darkGreen),
        ),
      ),
        // 邮箱输入
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _registerEmailController,
            decoration: InputDecoration(
              labelText: texts['email'] ?? '邮箱', // 使用翻译
              labelStyle: TextStyle(fontSize: 12, color: _primaryColor),
              prefixIcon: Icon(Icons.email_outlined, color: _primaryColor, size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: const TextStyle(fontSize: 13, color: _darkGreen),
          ),
        ),
        
        // 手机号输入
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.phone_android, color: _primaryColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '+86',
                      style: TextStyle(fontSize: 13, color: _darkGreen),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _registerPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: texts['phone'] ?? '手机号', // 使用翻译
                    hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 13, color: _darkGreen),
                ),
              ),
            ],
          ),
        ),
        
        // 验证码
        Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _registerCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '验证码',
                  labelStyle: TextStyle(fontSize: 12, color: _primaryColor),
                  prefixIcon: Icon(Icons.lock_outline, color: _primaryColor, size: 18),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                ),
                style: const TextStyle(fontSize: 13, color: _darkGreen),
                maxLength: 6, // 限制6位
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Container(
              height: 44,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _darkGreen],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _countdown > 0 ? null : _getSmsCode, // 倒计时中禁用
                  borderRadius: BorderRadius.circular(8),
                  child: Center(
                    child: Text(
                      _countdown > 0 ? '${_countdown}s后重新获取' : '获取验证码',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
        
        // 密码
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _registerPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: texts['password'] ?? '密码', // 使用翻译
              labelStyle: TextStyle(fontSize: 12, color: _primaryColor),
              prefixIcon: Icon(Icons.lock_outline, color: _primaryColor, size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: const TextStyle(fontSize: 13, color: _darkGreen),
          ),
        ),
        
        // 确认密码
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _registerConfirmController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: texts['confirmPassword'] ?? '确认密码', // 使用翻译
              labelStyle: TextStyle(fontSize: 12, color: _primaryColor),
              prefixIcon: Icon(Icons.lock_outline, color: _primaryColor, size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: const TextStyle(fontSize: 13, color: _darkGreen),
          ),
        ),
        
        // 同意条款
        Row(
          children: [
            Transform.scale(
              scale: 0.8,
              child: Checkbox(
                value: _agreeTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeTerms = value ?? false;
                  });
                },
                activeColor: _primaryColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: texts['agreeTerms'] ?? '我已阅读并同意 ', // 使用翻译
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  children: [
                    TextSpan(
                      text: texts['userAgreement'] ?? '用户协议', // 使用翻译
                      style: TextStyle(color: _primaryColor, fontSize: 11),
                    ),
                    TextSpan(text: ' ${texts['and'] ?? '和'} '),
                    TextSpan(
                      text: texts['privacyPolicy'] ?? '隐私政策', // 使用翻译
                      style: TextStyle(color: _primaryColor, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 注册按钮
        Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _darkGreen],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _agreeTerms ? _handleRegister : null,
              borderRadius: BorderRadius.circular(8),
              child: Center(
                child: Text(
                  texts['register'] ?? '注册', // 使用翻译
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // 注册页面的第三方登录
        Center(
          child: Text(
            texts['otherLoginMethods'] ?? '其他登录方式', // 使用翻译
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialLoginButton(
              icon: Icons.wechat,
              color: const Color(0xFF07C160),
              tooltip: texts['wechatLogin'] ?? '微信登录',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(texts['wechatLogin'] ?? '微信登录开发中')),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildSocialLoginButton(
              icon: Icons.chat,
              color: const Color(0xFF12B7F5),
              tooltip: texts['qqLogin'] ?? 'QQ登录',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(texts['qqLogin'] ?? 'QQ登录开发中')),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildSocialLoginButton(
              icon: Icons.email_outlined,
              color: _primaryColor,
              tooltip: texts['emailLogin'] ?? '邮箱登录',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(texts['emailLogin'] ?? '邮箱登录开发中')),
                );
              },
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // 底部鲲鹏点缀
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: _primaryColor.withOpacity(0.2), size: 4),
            const SizedBox(width: 4),
            Icon(Icons.circle, color: _primaryColor.withOpacity(0.4), size: 6),
            const SizedBox(width: 4),
            Icon(Icons.auto_awesome, color: _primaryColor.withOpacity(0.3), size: 12),
            const SizedBox(width: 4),
            Icon(Icons.circle, color: _primaryColor.withOpacity(0.4), size: 6),
            const SizedBox(width: 4),
            Icon(Icons.circle, color: _primaryColor.withOpacity(0.2), size: 4),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialLoginButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  // ============ 处理登录 ============
  Future<void> _handleLogin() async {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    
    if (_loginAccountController.text.isEmpty || 
        _loginPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(texts['fillAllFields'] ?? '请输入账号和密码'),
          backgroundColor: _darkGreen,
        ),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: _primaryColor),
                const SizedBox(height: 16),
                Text(
                  texts['aiGenerating'] ?? '鲲鹏展翅，登录中...',
                  style: TextStyle(color: _primaryColor),
                ),
              ],
            ),
          ),
        ),
      );

      final response = await ApiService.login(
        username: _loginAccountController.text,
        password: _loginPasswordController.text,
      );

      if (context.mounted) Navigator.pop(context);

      if (response['code'] == 200) {
        final userService = Provider.of<UserService>(context, listen: false);
        final data = response['data'] ?? {};
        await userService.login(
          _loginAccountController.text,
          _loginPasswordController.text,
          tokenData: data,
        );
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(texts['loginSuccess'] ?? '登录成功'),
              backgroundColor: _primaryColor,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? texts['loginFailed'] ?? '登录失败'),
              backgroundColor: _darkGreen,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${texts['networkError'] ?? '网络错误'}: $e'),
            backgroundColor: _darkGreen,
          ),
        );
      }
    }
  }

  // ============ 处理注册 ============
  void _getSmsCode() async {
  String phone = _registerPhoneController.text.trim();
  // 校验手机号
  if (phone.isEmpty || !RegExp(r"^1[3-9]\d{9}$").hasMatch(phone)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('请输入正确的手机号'), backgroundColor: _darkGreen),
    );
    return;
  }

  // 发送验证码
  final response = await ApiService.sendSmsCode(phone: phone);
  if (response['code'] == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('验证码已发送'), backgroundColor: _primaryColor),
    );
    // 开始倒计时
    setState(() {
      _countdown = 60;
    });
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        if (_countdown <= 0) {
          timer.cancel();
          _countdown = 0;
        }
      });
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['message'] ?? '发送失败'), backgroundColor: _darkGreen),
    );
  }
}

  Future<void> _handleRegister() async {
    final texts = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    
    if (_registerEmailController.text.isEmpty ||
        _registerPhoneController.text.isEmpty ||
        _registerPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(texts['fillAllFields'] ?? '请填写完整信息'),
          backgroundColor: _darkGreen,
        ),
      );
      return;
    }

    if (_registerPasswordController.text != _registerConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(texts['passwordMismatch'] ?? '两次密码不一致'),
          backgroundColor: _darkGreen,
        ),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: _primaryColor),
                const SizedBox(height: 16),
                Text(
                  texts['aiGenerating'] ?? '鲲鹏展翅，注册中...',
                  style: TextStyle(color: _primaryColor),
                ),
              ],
            ),
          ),
        ),
      );

      final response = await ApiService.register(
        username: _registerUsernameController.text,
        email: _registerEmailController.text,
        phone: _registerPhoneController.text,
        password: _registerPasswordController.text,
        verifyCode: _registerCodeController.text,
      );

      if (context.mounted) Navigator.pop(context);

      if (response['code'] == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(texts['registerSuccess'] ?? '注册成功，请登录'),
              backgroundColor: _primaryColor,
            ),
          );
          setState(() {
            _isLoginSelected = true;
            _registerUsernameController.clear();
            _registerEmailController.clear();
            _registerPhoneController.clear();
            _registerPasswordController.clear();
            _registerConfirmController.clear();
            _registerCodeController.clear();
          });
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? texts['registerFailed'] ?? '注册失败'),
              backgroundColor: _darkGreen,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${texts['networkError'] ?? '网络错误'}: $e'),
            backgroundColor: _darkGreen,
          ),
        );
      }
    }
  }
}