import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nasporte_frontend/pages/trains.dart';
import 'package:nasporte_frontend/shared/appbar_main.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Column(
        children: [
          appBar(),
          const SizedBox(height: 20),
          _schedule(context),
        ],
      ),
    );
  }
}

Row _schedule (context) {
  return  Row(
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          'Расписание',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const TrainsPage(),
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
  );
}