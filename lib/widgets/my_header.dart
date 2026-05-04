import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHeader extends StatelessWidget {
  const MyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double s = MediaQuery.of(context).size.width / 390;

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: topPadding),
          SizedBox(
            height: 56 * s,
            child: Stack(
              children: [
                Positioned(
                  left: 10 * s,
                  top: 15 * s,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Transform.rotate(
                      angle: math.pi,
                      child: Image.asset(
                        'assets/image2821.png',
                        width: 25 * s,
                        height: 25 * s,
                      ),
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
                Positioned(
                  left: 346 * s,
                  top: 17 * s,
                  child: Image.asset(
                    'assets/profile.png',
                    width: 22 * s,
                    height: 22 * s,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
