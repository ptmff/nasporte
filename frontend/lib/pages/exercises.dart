import 'package:flutter/material.dart';
import 'package:nasporte_frontend/pages/exercises/arms.dart';
import 'package:nasporte_frontend/pages/exercises/back.dart';
import 'package:nasporte_frontend/pages/exercises/cardio.dart';
import 'package:nasporte_frontend/pages/exercises/chest.dart';
import 'package:nasporte_frontend/pages/exercises/legs.dart';
import 'package:nasporte_frontend/pages/exercises/shoulders.dart';
import 'package:nasporte_frontend/shared/appbar_main.dart';


class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();  
}

class _ExercisesPageState extends State<ExercisesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Column(
        children: [
          appBar(),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Упражнения',
              style: TextStyle(
                color: Color(0xff6855FF),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 15),
          _execises(context),
        ],
      ),
    );
  }
}

Padding _execises (context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const ChestPage(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.asset('assets/images/chest.png'),
                  Container(
                    width: 173,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [const Color(0xff6855FF).withOpacity(1), const Color(0xff6855FF).withOpacity(0)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 15,
                    left: 15,
                    child:  Text(
                     'Грудь',
                     style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFFFFFF),
                     ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const ArmsPage(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.asset('assets/images/arms.png'),
                  Container(
                    width: 173,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [const Color(0xff6855FF).withOpacity(1), const Color(0xff6855FF).withOpacity(0)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 15,
                    left: 15,
                    child:  Text(
                     'Руки',
                     style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFFFFFF),
                     ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LegsPage(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.asset('assets/images/legs.png'),
                  Container(
                    width: 173,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [const Color(0xff6855FF).withOpacity(1), const Color(0xff6855FF).withOpacity(0)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 15,
                    left: 15,
                    child:  Text(
                     'Ноги',
                     style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFFFFFF),
                     ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const BackPage(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.asset('assets/images/back.png'),
                  Container(
                    width: 173,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [const Color(0xff6855FF).withOpacity(1), const Color(0xff6855FF).withOpacity(0)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 15,
                    left: 15,
                    child:  Text(
                     'Спина',
                     style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFFFFFF),
                     ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const ShouldersPage(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.asset('assets/images/shoulders.png'),
                  Container(
                    width: 173,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [const Color(0xff6855FF).withOpacity(1), const Color(0xff6855FF).withOpacity(0)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 15,
                    left: 15,
                    child:  Text(
                     'Плечи',
                     style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFFFFFF),
                     ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const CardioPage(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.asset('assets/images/cardio.png'),
                  Container(
                    width: 173,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [const Color(0xff6855FF).withOpacity(1), const Color(0xff6855FF).withOpacity(0)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 15,
                    left: 15,
                    child:  Text(
                     'Кардио',
                     style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFFFFFF),
                     ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}