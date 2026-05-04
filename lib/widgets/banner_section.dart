import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

    return Container(
      width: screenWidth,
      height: 138 * s,
      color: const Color(0xFFF5F5F5),
      child: Stack(
        children: [
          Positioned(
            left: 35 * s,
            top: 55 * s,
            child: Text(
              '코박을\n안전하게',
              style: GoogleFonts.inter(
                fontSize: 14 * s,
                fontWeight: FontWeight.w500,
                height: 17 / 14,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            right: 16 * s,
            top: 12 * s,
            child: Image.asset(
              'assets/banner.png',
              width: 148 * s,
              height: 113 * s,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
