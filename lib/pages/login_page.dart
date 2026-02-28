// lib/pages/login_page.dart
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

class _LoginPageState extends State<LoginPage> {
  bool _isLoginSelected = true;
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
  void dispose() {
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

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '欢迎使用',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
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
                    // Logo区域
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.travel_explore,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '九州Traveling',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2196F3),
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
                                      ? const Color(0xFF2196F3)
                                      : (isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: _isLoginSelected
                                        ? const Color(0xFF2196F3)
                                        : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                                    width: 0.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '登录',
                                    style: TextStyle(
                                      color: _isLoginSelected ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
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
                                      ? const Color(0xFF2196F3)
                                      : (isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade100),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: !_isLoginSelected
                                        ? const Color(0xFF2196F3)
                                        : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                                    width: 0.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '注册',
                                    style: TextStyle(
                                      color: !_isLoginSelected ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
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
                    _isLoginSelected ? _buildLoginForm(isDark) : _buildRegisterForm(isDark),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============ 登录表单 ============
  Widget _buildLoginForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        
        // 账号输入
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: _loginAccountController,
            decoration: InputDecoration(
              labelText: '邮箱/手机号/用户名',
              labelStyle: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF2196F3), size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
          ),
        ),
        
        // 密码输入
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: _loginPasswordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: '密码',
              labelStyle: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2196F3), size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
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
            style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
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
            child: const Text(
              '忘记密码？',
              style: TextStyle(color: Color(0xFF2196F3), fontSize: 12),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 登录按钮
        Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleLogin,
              borderRadius: BorderRadius.circular(8),
              child: const Center(
                child: Text(
                  '登录',
                  style: TextStyle(
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
        const Center(
          child: Text('其他登录方式', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ),
        const SizedBox(height: 16),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialLoginButton(
              icon: Icons.wechat,
              color: const Color(0xFF07C160),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('微信登录开发中')),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildSocialLoginButton(
              icon: Icons.chat,
              color: const Color(0xFF12B7F5),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QQ登录开发中')),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildSocialLoginButton(
              icon: Icons.email_outlined,
              color: const Color(0xFFFA5151),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('邮箱登录开发中')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // ============ 注册表单 ============
  Widget _buildRegisterForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        
        // 邮箱输入
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: _registerEmailController,
            decoration: InputDecoration(
              labelText: '邮箱',
              labelStyle: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF2196F3), size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
          ),
        ),
        
        // 手机号输入
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.phone_android, color: Color(0xFF2196F3), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '+86',
                      style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
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
                    hintStyle: TextStyle(fontSize: 12),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
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
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    width: 0.5,
                  ),
                ),
                child: TextField(
                  controller: _registerCodeController,
                  decoration: InputDecoration(
                    labelText: '验证码',
                    labelStyle: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2196F3), size: 18),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  ),
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: const Center(
                      child: Text(
                        '获取验证码',
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
            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: _registerPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: '密码',
              labelStyle: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2196F3), size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
          ),
        ),
        
        // 确认密码
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: _registerConfirmController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: '确认密码',
              labelStyle: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2196F3), size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
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
                activeColor: const Color(0xFF2196F3),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: '我已阅读并同意 ',
                  style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  children: [
                    TextSpan(
                      text: '用户协议',
                      style: const TextStyle(color: Color(0xFF2196F3), fontSize: 11),
                    ),
                    TextSpan(text: ' 和 '),
                    TextSpan(
                      text: '隐私政策',
                      style: const TextStyle(color: Color(0xFF2196F3), fontSize: 11),
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
            gradient: const LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _agreeTerms ? _handleRegister : null,
              borderRadius: BorderRadius.circular(8),
              child: Center(
                child: Text(
                  '注册',
                  style: TextStyle(
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
        const Center(
          child: Text('其他登录方式', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ),
        const SizedBox(height: 16),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialLoginButton(
              icon: Icons.wechat,
              color: const Color(0xFF07C160),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('微信登录开发中')),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildSocialLoginButton(
              icon: Icons.chat,
              color: const Color(0xFF12B7F5),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QQ登录开发中')),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildSocialLoginButton(
              icon: Icons.email_outlined,
              color: const Color(0xFFFA5151),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('邮箱登录开发中')),
                );
              },
            ),
          ],
        ),
      ],
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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  // ============ 处理登录 ============
  Future<void> _handleLogin() async {
    if (_loginAccountController.text.isEmpty || 
        _loginPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入账号和密码')),
      );
      return;
    }

    try {
      // 显示加载中
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // 调用API登录
      final response = await ApiService.login(
        account: _loginAccountController.text,
        password: _loginPasswordController.text,
      );

      if (context.mounted) Navigator.pop(context); // 关闭加载对话框

      if (response['code'] == 200) {
        // ============ 关键：更新用户状态 ============
        final userService = Provider.of<UserService>(context, listen: false);
        final userData = response['data'];
        
        // 调用UserService的登录方法保存用户信息
        await userService.login(
          _loginAccountController.text,
          _loginPasswordController.text,
        );
        // ==========================================
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('登录成功')),
          );
          Navigator.pop(context, true); // 返回主页并传递成功标志
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? '登录失败')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // 关闭加载对话框
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('网络错误：$e')),
        );
      }
    }
  }

  // ============ 处理注册 ============
  Future<void> _handleRegister() async {
    if (_registerEmailController.text.isEmpty ||
        _registerPhoneController.text.isEmpty ||
        _registerPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写完整信息')),
      );
      return;
    }

    if (_registerPasswordController.text != _registerConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('两次密码不一致')),
      );
      return;
    }

    try {
      // 显示加载中
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // 调用API注册
      final response = await ApiService.register(
        email: _registerEmailController.text,
        phone: _registerPhoneController.text,
        password: _registerPasswordController.text,
      );

      if (context.mounted) Navigator.pop(context); // 关闭加载对话框

      if (response['code'] == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('注册成功，请登录')),
          );
          setState(() {
            _isLoginSelected = true; // 切换到登录页
            // 清空注册表单
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
            SnackBar(content: Text(response['message'] ?? '注册失败')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // 关闭加载对话框
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('网络错误：$e')),
        );
      }
    }
  }
}