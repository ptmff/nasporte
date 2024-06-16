import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    @override
    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Column(
        children: [
          appBar(),
        ],
      ),
    );
  }

  Container appBar() {
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
        backgroundColor: const Color.fromARGB(255, 3, 12, 5),
        toolbarHeight: 200,
        leadingWidth: 110,
        leading: Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 30, top: 0),
          child: SvgPicture.asset('assets/icons/nasporte_icon.svg'),
        ),
        actions: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              SvgPicture.asset('assets/icons/full_lightning.svg', height: 200),
              Positioned(
                top: 40,
                right: 30,
                child: SvgPicture.asset('assets/icons/notification.svg', height: 30),
              ),
            ],
          ),
        ],
      ),
    ),
  );
} 
}