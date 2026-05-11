import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// CSS 절대좌표 기준 (카드 left:12, top:354 기준으로 상대좌표 변환)
// 아이콘 top: 392-354=38, 라벨 top: 443-354=89, 타이틀 top: 365-354=11
class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key});

  // (이미지경로, 라벨, 아이콘 left 상대좌표, 라벨 left 상대좌표)
  static const List<(String, String, double, double)> _items = [
    ('assets/Live_main 1.png', '라이브',   7,  16),
    ('assets/realtime_main.png', '속보',   59,  70),
    ('assets/mission_main.png', '미션',   111, 122),
    ('assets/stock_main.png', '시세조회', 163, 166),
    ('assets/toolbox_main.png', '툴박스', 215, 222),
    ('assets/business_main.png', '비즈니스', 267, 270),
    ('assets/rank_main.png', '랭킹',     319, 330),
  ];

  @override
  Widget build(BuildContext context) {
    final double s = MediaQuery.of(context).size.width / 390;

    final List<Widget> children = [
      Positioned(
        top: 11 * s,
        left: 14 * s,
        child: Text(
          '주요 서비스',
          style: GoogleFonts.inter(
            fontSize: 13 * s,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    ];

    for (final (imagePath, label, iconLeft, labelLeft) in _items) {
      children.add(Positioned(
        top: 38 * s,
        left: iconLeft * s,
        child: Stack(
          children: [
            Container(
              width: 40 * s,
              height: 40 * s,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFEFEFE), Color(0xFFF0F0F0), Color(0xFFFFFBFB)],
                  stops: [0.0, 0.6298, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
                borderRadius: BorderRadius.circular(10 * s),
              ),
            ),
            Image.asset(imagePath, width: 40 * s, height: 40 * s),
          ],
        ),
      ));

      children.add(Positioned(
        top: 89 * s,
        left: labelLeft * s,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9 * s,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6D6D6D),
            decoration: TextDecoration.none,
          ),
        ),
      ));
    }

    return Container(
      width: double.infinity,
      height: 118 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * s),
      ),
      child: Stack(children: children),
    );
  }
}
