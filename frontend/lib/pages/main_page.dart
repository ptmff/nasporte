import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nasporte_frontend/pages/home.dart';
import 'package:nasporte_frontend/pages/profile.dart';
import 'package:nasporte_frontend/pages/progression.dart';
import 'package:nasporte_frontend/pages/schedule.dart';
import 'package:nasporte_frontend/pages/trainers.dart';

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
    const TrainersPage(),
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: const Color(0xffFFFFFF),
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
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 11),
                    child: SvgPicture.asset('assets/icons/progression_selected.svg'),
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
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7.5),
                    child: SvgPicture.asset('assets/icons/profile_selected.svg'),
                    ),
                ) : SvgPicture.asset('assets/icons/profile.svg'),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
