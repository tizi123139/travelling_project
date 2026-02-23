import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hotel_model.dart';
import '../services/hotel_service.dart';
import '../services/user_service.dart';
import 'package:intl/intl.dart';

class HotelBookingPage extends StatefulWidget {
  final Hotel hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;

  const HotelBookingPage({
    super.key,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
  });

  @override
  State<HotelBookingPage> createState() => _HotelBookingPageState();
}

class _HotelBookingPageState extends State<HotelBookingPage> {
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  String? _selectedRoomType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 默认选中第一个房型
    if (widget.hotel.roomTypes.isNotEmpty) {
      _selectedRoomType = widget.hotel.roomTypes.keys.first;
    }
  }

  // 提交预订
  Future<void> _submitBooking() async {
    // 前端校验必填项
    if (_contactNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入联系人姓名')),
      );
      return;
    }

    if (_contactPhoneController.text.trim().isEmpty || 
        _contactPhoneController.text.trim().length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的11位手机号')),
      );
      return;
    }

    if (_selectedRoomType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择房型')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final userService = Provider.of<UserService>(context, listen: false);
    final hotelService = HotelService();

    // 校验用户已登录（获取 userId）
    if (!userService.isLoggedIn || userService.currentUser?.id.isEmpty == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先登录')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      // 调用预订接口
      final result = await hotelService.bookHotel(
        hotelId: widget.hotel.id,
        roomType: _selectedRoomType!,
        checkIn: widget.checkIn,
        checkOut: widget.checkOut,
        userId: userService.currentUser!.id,
        contactName: _contactNameController.text.trim(),
        contactPhone: _contactPhoneController.text.trim(),
        guests: widget.guests,
        rooms: widget.rooms,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('预订成功！订单号：${result['data']['orderId']}')),
        );
        Navigator.pop(context, true); // 返回酒店列表页并刷新
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('预订失败：${result['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('预订异常：$e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final days = widget.checkOut.difference(widget.checkIn).inDays;
    // 空值保护：避免房型为空时崩溃
    final totalPrice = _selectedRoomType != null 
        ? widget.hotel.roomTypes[_selectedRoomType]! * days 
        : 0;

    return Scaffold(
      appBar: AppBar(title: const Text('酒店预订')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 酒店信息摘要
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(widget.hotel.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('地址：${widget.hotel.address}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('入住：${DateFormat('yyyy-MM-dd').format(widget.checkIn)}'),
                        const SizedBox(width: 16),
                        Text('离店：${DateFormat('yyyy-MM-dd').format(widget.checkOut)}'),
                      ],
                    ),
                    // 修复：移除多余的花括号
                    Text('共 $days 晚 · ${widget.guests} 人 · ${widget.rooms} 间'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text('选择房型', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // 房型选择
            DropdownButtonFormField<String>(
              value: _selectedRoomType,
              items: widget.hotel.roomTypes.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text('${entry.key} - ¥${entry.value.toInt()}/晚'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedRoomType = value),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (value) => value == null ? '请选择房型' : null,
            ),

            const SizedBox(height: 20),
            const Text('联系人信息', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // 联系人姓名（改为TextFormField并添加校验）
            TextFormField(
              controller: _contactNameController,
              decoration: const InputDecoration(
                labelText: '姓名',
                border: OutlineInputBorder(),
                hintText: '请输入联系人姓名',
              ),
            ),
            const SizedBox(height: 16),
            // 联系人电话（修复required参数错误，添加格式校验）
            TextFormField(
              controller: _contactPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: '手机号',
                border: OutlineInputBorder(),
                hintText: '请输入11位手机号',
              ),
              maxLength: 11,
            ),

            const SizedBox(height: 20),
            // 总价
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '总价：¥${totalPrice.toInt()}',
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF2196F3),
                ),
              ),
            ),

            const SizedBox(height: 30),
            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('确认预订', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 释放控制器资源
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }
}