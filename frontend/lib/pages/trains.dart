import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nasporte_frontend/pages/exercises.dart';

class TrainsPage extends StatefulWidget {
  const TrainsPage({super.key});

  @override
  State<TrainsPage> createState() => _TrainsPageState();
}

class _TrainsPageState extends State<TrainsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Column(
        children: [
          _appBar(context),
        ],
      ),
    );
  }
}

Container _appBar (context) {
  return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black38,
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      child: AppBar(
        title: Container(),
        flexibleSpace: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 57),
                child: Text(
                  'Тренировка',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffFFFFFF),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 3, 12, 5),
        toolbarHeight: 100,
        leading: Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.only(left: 24, bottom: 18),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset('assets/icons/arrow_white.svg')
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              SvgPicture.asset('assets/icons/lightning.svg', height: 100),
              Positioned(
                top: 50,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const ExercisesPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffCAC5F3),
                    ),
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: SvgPicture.asset('assets/icons/plus.svg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}