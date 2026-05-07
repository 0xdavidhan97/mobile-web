import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHeader extends StatelessWidget {
  const MyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double s = MediaQuery.of(context).size.width / 390;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // DI 영역: 상태바(#CFE1FF)와 자연스럽게 연결되는 그라데이션
        Container(
          height: topPadding,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFCFE1FF), Colors.white],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: SizedBox(
            height: 56 * s,
            child: Stack(
              children: [
                Positioned(
                  left: 10 * s,
                  top: 15 * s,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/arrow_back.png',
                      width: 25 * s,
                      height: 25 * s,
                    ),
                  ),
                ),
                Positioned(
                  left: 44 * s,
                  top: 17 * s,
                  child: Text(
                    '마이',
                    style: GoogleFonts.inter(
                      fontSize: 17 * s,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
