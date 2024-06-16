import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardioPage extends StatefulWidget {
  const CardioPage({super.key});

  @override
  State<CardioPage> createState() => _CardioPageState();
}

class _CardioPageState extends State<CardioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Column(
        children: [
          _appBar(context),
          const SizedBox(height: 15),
          _types(),
        ],
      ),
    );
  }
}

Row _types() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
        width: 120,
        height: 32,
        decoration: const BoxDecoration(
          color: Color(0xffF1F5F9),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset('assets/icons/idk.svg'),
              const Text(
                'Тренажёры',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff94A3B8),
                ),
              ),
            ],
          ),
        ),
      ), 
      Container(
        width: 120,
        height: 32,
        decoration: const BoxDecoration(
          color: Color(0xffF1F5F9),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset('assets/icons/gantelya.svg'),
              const Text(
                'Свободные',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff94A3B8),
                ),
              ),
            ],
          ),
        ),
      ), 
      Container(
        width: 120,
        height: 32,
        decoration: const BoxDecoration(
          color: Color(0xffF1F5F9),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset('assets/icons/man.svg'),
              const Text(
                'Собственный',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff94A3B8),
                ),
              ),
            ],
          ),
        ),
      ), 
    ],
  );
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
                  'Кардио',
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
          SvgPicture.asset('assets/icons/lightning.svg', height: 100),   
        ],
      ),
    ),
  );
}