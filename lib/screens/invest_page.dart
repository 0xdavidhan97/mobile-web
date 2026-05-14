import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme_color.dart';

class InvestPage extends StatelessWidget {
  const InvestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 414px 기준 폭: 실제 < 414면 화면 폭, ≥ 414면 414로 고정
    final double refWidth =
        MediaQuery.of(context).size.width.clamp(0.0, 414.0);

    return ThemeColorScope(
      color: '#FFFFFF',
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: refWidth,
            height: double.infinity,
            child: MediaQuery(
              // 414px 기준 비율을 모든 하위 요소가 MediaQuery로 읽을 수 있게 오버라이드
              data: MediaQuery.of(context).copyWith(
                size: Size(refWidth, MediaQuery.of(context).size.height),
              ),
              child: Builder(
                builder: (context) {
                  final double s =
                      MediaQuery.of(context).size.width / 414.0;
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                      width: refWidth,
                      // 156 (Dynamic Island + Header) + 948 (콘텐츠 배경)
                      height: 1104 * s,
                      child: Stack(
                        children: [
                          // 투자정보 타이틀 (top: 61, left: 20)
                          Positioned(
                            top: 61 * s,
                            left: 20 * s,
                            child: Text(
                              '투자정보',
                              style: GoogleFonts.notoSansKr(
                                fontSize: 18 * s,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1E27),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          // 콘텐츠 배경 Rectangle 1461 (top: 156, height: 948, #F5F5F5)
                          Positioned(
                            top: 156 * s,
                            left: 0,
                            child: Container(
                              width: 414 * s,
                              height: 948 * s,
                              color: const Color(0xFFF5F5F5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
