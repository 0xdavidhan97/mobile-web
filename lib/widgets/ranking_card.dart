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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀 — card top 18px
          Padding(
            padding: EdgeInsets.fromLTRB(20 * s, 18 * s, 0, 0),
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
          // gap 7 → subtext top 42
          SizedBox(height: 7 * s),
          Padding(
            padding: EdgeInsets.only(left: 24 * s),
            child: Text(
              '일일 검색량 기준 가장 많이 검색된 코인 순위',
              style: GoogleFonts.inter(
                fontSize: 9 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6D6D6D),
              ),
            ),
          ),
          // gap 26 → item 1 top 79 (564-485=79 ✓)
          SizedBox(height: 26 * s),
          // 아이템 1~8: 각 15px, 아이템 사이 26px 간격
          // 마지막 아이템 하단 패딩 없음 → item 8 ends at 381
          for (int i = 0; i < 8; i++) ...[
            _RankingItem(rank: i + 1, s: s),
            if (i < 7) SizedBox(height: 26 * s),
          ],
          // gap 16 → 더보기 버튼 top 397 (882-485=397 ✓)
          SizedBox(height: 16 * s),
          Center(
            child: Container(
              width: 314 * s,
              height: 44 * s,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(10 * s),
              ),
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

class _RankingItem extends StatelessWidget {
  final int rank;
  final double s;

  const _RankingItem({required this.rank, required this.s});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20 * s),
      child: Text(
        '$rank',
        style: GoogleFonts.inter(
          fontSize: 12 * s,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}
