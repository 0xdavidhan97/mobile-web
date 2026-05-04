import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePopup extends StatelessWidget {
  const ProfilePopup({super.key});

  @override
  Widget build(BuildContext context) {
    final double s = MediaQuery.of(context).size.width / 390;

    return Container(
      width: 141 * s,
      height: 202 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * s),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16 * s, 18 * s, 16 * s, 18 * s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/profile.png', width: 25 * s, height: 25 * s),
              SizedBox(width: 8 * s),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 프로필',
                    style: GoogleFonts.inter(
                      fontSize: 9 * s,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF096BFF),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 2 * s),
                  Text(
                    '어서헤어져',
                    style: GoogleFonts.inter(
                      fontSize: 11 * s,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF272727),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12 * s),
          Divider(height: 1, thickness: 1 * s, color: const Color(0xFFEEEEEE)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MenuItem(label: '마이페이지 이동', color: const Color(0xFF4E4E4E), s: s),
                _MenuItem(label: '내 스페이스 이동', color: const Color(0xFF4E4E4E), s: s),
                _MenuItem(label: '계정 및 보안', color: const Color(0xFF4E4E4E), s: s),
                _MenuItem(label: '로그아웃', color: const Color(0xFFFF4E4E), s: s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final Color color;
  final double s;

  const _MenuItem({
    required this.label,
    required this.color,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12 * s,
          fontWeight: FontWeight.w600,
          color: color,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
