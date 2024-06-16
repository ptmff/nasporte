import 'package:flutter/material.dart';
import 'package:nasporte_frontend/shared/appbar_main.dart';

class TrainersPage extends StatefulWidget {
  const TrainersPage({super.key});

  @override
  State<TrainersPage> createState() => _TrainersPageState();
}

class _TrainersPageState extends State<TrainersPage> {
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
              'Тренера',
              style: TextStyle(
                color: Color(0xff6855FF),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}