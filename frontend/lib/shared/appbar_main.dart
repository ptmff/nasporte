import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        toolbarHeight: 100,
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
              SvgPicture.asset('assets/icons/lightning.svg', height: 100),
              Positioned(
                top: 40,
                right: 15,
                child: SvgPicture.asset('assets/icons/notification.svg', height: 30),
              ),
            ],
          ),
        ],
      ),
    ),
  );
} 