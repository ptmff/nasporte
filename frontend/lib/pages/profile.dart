import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chat.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String avatarUrl = '';
  String userName = 'jojjiik';
  String userId = '@id123456';
  String email = 'bugagaha@gmail.com';

  @override
  // void initState() {
  //   super.initState();
  //   _fetchProfileData();
  // }

  // Future<void> _fetchProfileData() async {
  //   final response = await http.get(Uri.parse('https://example.com/api/profile'));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     setState(() {
  //       avatarUrl = data['avatarUrl'];
  //       userName = data['userName'];
  //       userId = data['userId'];
  //       email = data['email'];
  //     });
  //   } else {
  //     // Обработка ошибки
  //   }
  // }

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
            if (avatarUrl.isNotEmpty)
              CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(avatarUrl),
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
              userName,
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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