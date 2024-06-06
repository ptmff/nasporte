import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nasporte_frontend/pages/home.dart';
import 'package:nasporte_frontend/pages/profile.dart';
import 'package:nasporte_frontend/pages/progression.dart';
import 'package:nasporte_frontend/pages/schedule.dart';
import 'package:nasporte_frontend/pages/trains.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget> [
    const HomePage(),
    const SchedulePage(),
    const TrainsPage(),
    const ProgressionPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: const Color(0xffFFFFFF),
        //elevation: 0, тень хз потом сделаю
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0 ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xffCAC5F3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SvgPicture.asset('assets/icons/home_selected.svg'),
                ),
            ) : SvgPicture.asset('assets/icons/home.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1 ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xffCAC5F3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SvgPicture.asset('assets/icons/schedule_selected.svg'),
                ),
            ) : SvgPicture.asset('assets/icons/schedule.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2 ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xffCAC5F3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SvgPicture.asset('assets/icons/trains_selected.svg'),
                ),
            ) : SvgPicture.asset('assets/icons/trains.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3 ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xffCAC5F3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SvgPicture.asset('assets/icons/home_selected.svg'), //поменять home_selected на progression_selected
                ),
            ) : SvgPicture.asset('assets/icons/progression.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 4 ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xffCAC5F3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SvgPicture.asset('assets/icons/home_selected.svg'), //поменять home_selected на profile_selected
                ),
            ) : SvgPicture.asset('assets/icons/profile.svg'),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
