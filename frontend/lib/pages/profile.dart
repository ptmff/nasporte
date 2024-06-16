import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profilePic = '';
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Обработка случая, если токен отсутствует
      print('No token found');
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5038/Auth/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      final data = json.decode(response.body);
      setState(() {
        profilePic = data['profilePic'] ?? '';
        username = data['username'] ?? '';
        email = data['email'] ?? '';
      });
    } else {
      // Обработка ошибки
      print('Error: ${response.statusCode}');
    }
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage()),
    );
  }

  void _logout() {
    // нада сделат
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xffFFFFFF),
        title: const Text('Профиль', style: TextStyle(fontFamily: 'Inner', fontWeight: FontWeight.w500, color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (profilePic.isNotEmpty)
              CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(profilePic),
              )
            else
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[200],
                child: SvgPicture.asset(
                  'assets/icons/no_avatar.svg',
                  width: 50,
                  height: 50,
                ),
              ),
            const SizedBox(height: 10),
            Text(
              username,
              style: const TextStyle(fontFamily: 'Inner', fontWeight: FontWeight.w600, fontSize: 27, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              email,
              style: TextStyle(fontFamily: 'Inner', fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _navigateToSettings(context),
              icon: SvgPicture.asset('assets/icons/settings.svg', width: 24, height: 24, color: Colors.black),
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Настройки',
                    style: TextStyle(fontFamily: 'Inner', fontWeight: FontWeight.w500, color: Colors.black, fontSize: 19),
                  ),
                  SvgPicture.asset('assets/icons/arrow.svg', width: 24, height: 24),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/logout.svg', width: 24, height: 24, color: Colors.black),
                      const SizedBox(width: 10),
                      const Text(
                        'Выйти',
                        style: TextStyle(fontFamily: 'Inner', fontWeight: FontWeight.w500, color: Colors.black, fontSize: 19),
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

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки', style: TextStyle(fontFamily: 'Inner', fontWeight: FontWeight.w500)),
      ),
      body: const Center(
        child: Text('Здесь настройки профиля', style: TextStyle(fontFamily: 'Inner', fontWeight: FontWeight.w600)),
      ),
    );
  }
}
