import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtext;
  final Color subtextColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtext,
    required this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

    return Container(
      width: 160 * s,
      height: 88 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * s),
      ),
      child: Stack(
        children: [
          // fire 아이콘 + 라벨
          Positioned(
            left: 8 * s,
            top: 12 * s,
            child: Row(
              children: [
                Image.asset('assets/fire.png', width: 15 * s, height: 15 * s),
                SizedBox(width: 4 * s),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12 * s,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF434343),
                  ),
                ),
              ],
            ),
          ),
          // 수치
          Positioned(
            left: 9 * s,
            top: 36 * s,
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 20 * s,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          // 서브텍스트
          Positioned(
            left: 11 * s,
            top: 65 * s,
            child: Text(
              subtext,
              style: GoogleFonts.inter(
                fontSize: 12 * s,
                fontWeight: FontWeight.w500,
                color: subtextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
