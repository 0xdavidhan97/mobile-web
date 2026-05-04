import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RankingCard extends StatelessWidget {
  const RankingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

    return Container(
      width: double.infinity,
      height: 463 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * s),
      ),
      child: Stack(
        children: [
          // 타이틀 — left:20, top:18
          Positioned(
            left: 20 * s,
            top: 18 * s,
            child: Text(
              '인기 검색 순위',
              style: GoogleFonts.inter(
                fontSize: 14 * s,
                fontWeight: FontWeight.w700,
                height: 17 / 14,
                color: Colors.black,
              ),
            ),
          ),
          // 서브텍스트 — left:24, top:42
          Positioned(
            left: 24 * s,
            top: 42 * s,
            child: Text(
              '일일 검색량 기준 가장 많이 검색된 코인 순위',
              style: GoogleFonts.inter(
                fontSize: 9 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6D6D6D),
              ),
            ),
          ),
          // 순위 1~8 — left:20, top: 79 + i*41
          for (int i = 0; i < 8; i++)
            Positioned(
              left: 20 * s,
              top: (79 + i * 41) * s,
              child: Text(
                '${i + 1}',
                style: GoogleFonts.inter(
                  fontSize: 12 * s,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          // 더보기 버튼 — top:397, left:26, right:26, height:44 (bottom:22)
          Positioned(
            top: 397 * s,
            left: 26 * s,
            right: 26 * s,
            child: Container(
              height: 44 * s,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(10 * s),
              ),
              // 더보기 텍스트: 버튼 기준 top:14, left:140 → 중앙 정렬과 일치
              alignment: Alignment.center,
              child: Text(
                '더보기',
                style: GoogleFonts.inter(
                  fontSize: 12 * s,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF575757),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
