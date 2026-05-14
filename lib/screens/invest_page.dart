import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/pwa_utils.dart';
import '../utils/theme_color.dart';

class InvestPage extends StatefulWidget {
  const InvestPage({super.key});

  @override
  State<InvestPage> createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> {
  int _selectedTab = 0;

  // (label, left) — 375px 디자인 기준
  static const List<(String, double)> _tabs = [
    ('검색트렌드', 17.0),
    ('소셜트렌드', 108.0),
    ('Pre-listing', 200.0),
  ];

  @override
  Widget build(BuildContext context) {
    // Safe Area: MediaQuery.padding 사용, 웹 fallback은 cssSafeAreaTop()
    final double flutterTop = MediaQuery.of(context).padding.top;
    final double topSafe =
        (flutterTop > 0 || !kIsWeb) ? flutterTop : cssSafeAreaTop();
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    // 375px 디자인 기준 scale factor
    final double s = MediaQuery.of(context).size.width / 375.0;

    return ThemeColorScope(
      color: '#FFFFFF',
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            // Top safe area
            Container(height: topSafe, color: Colors.white),
            // header1
            _buildHeader(s),
            // header2 (탭 네비게이션)
            _buildTabBar(s),
            // 콘텐츠 (스크롤)
            Expanded(child: _buildContent(s)),
            // 하단 네비게이션
            _buildBottomNav(s, context),
            // Bottom safe area
            SizedBox(height: bottomSafe),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double s) {
    return Container(
      width: double.infinity,
      height: 56 * s,
      color: Colors.white,
      child: Stack(
        children: [
          // 투자정보 타이틀 (left 17, top 17)
          Positioned(
            left: 17 * s,
            top: 17 * s,
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
        ],
      ),
    );
  }

  Widget _buildTabBar(double s) {
    return Container(
      width: double.infinity,
      height: 48 * s,
      color: const Color(0xFF2C6CEB),
      child: Stack(
        children: [
          // 탭 메뉴 (top 68 → 탭바 기준 12)
          for (int i = 0; i < _tabs.length; i++)
            Positioned(
              left: _tabs[i].$2 * s,
              top: 12 * s,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _selectedTab = i),
                child: Text(
                  _tabs[i].$1,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 15 * s,
                    fontWeight: FontWeight.w600,
                    color: _selectedTab == i
                        ? Colors.white
                        : const Color(0xFFCEE1FC),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(double s) {
    if (_selectedTab != 0) {
      return Center(
        child: Text(
          '준비 중입니다.',
          style: GoogleFonts.notoSansKr(
            fontSize: 15 * s,
            color: const Color(0xFF697483),
          ),
        ),
      );
    }

    // 콘텐츠 영역은 CSS top 104(탭바 끝) ~ 1018(네비 시작), 높이 914
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: SizedBox(
        width: double.infinity,
        height: 914 * s,
        child: Stack(
          children: [
            // 검색트렌드 섹션 타이틀 (CSS top 133 → 콘텐츠 기준 29)
            Positioned(
              top: 29 * s,
              left: 16 * s,
              child: Text(
                '검색트렌드',
                style: GoogleFonts.notoSansKr(
                  fontSize: 18 * s,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1E27),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            // 서브타이틀 (CSS top 158 → 54)
            Positioned(
              top: 54 * s,
              left: 16 * s,
              child: Text(
                '업비트·빗썸 상장코인 · 국내 포털사이트 검색 기준',
                style: GoogleFonts.notoSansKr(
                  fontSize: 14 * s,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF697483),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            // Rectangle 1470 - 인기 검색 순위 카드 (CSS top 196 → 92)
            Positioned(
              top: 92 * s,
              left: 16 * s,
              child: Container(
                width: 343 * s,
                height: 778 * s,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15 * s),
                ),
                child: Stack(
                  children: [
                    // 카드 타이틀 (CSS top 219 → 카드 기준 23, left 32 → 카드 기준 16)
                    Positioned(
                      top: 23 * s,
                      left: 16 * s,
                      child: Text(
                        '인기 검색 순위',
                        style: GoogleFonts.notoSansKr(
                          fontSize: 16 * s,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1E27),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    // 카드 서브타이틀 (CSS top 246 → 50)
                    Positioned(
                      top: 50 * s,
                      left: 16 * s,
                      child: Text(
                        '일일 검색량 기준 가장 많이 검색된 코인 순위',
                        style: GoogleFonts.notoSansKr(
                          fontSize: 13 * s,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF697483),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _navLabelStyle(double s, bool isActive) => GoogleFonts.notoSansKr(
        fontSize: 10 * s,
        fontWeight: FontWeight.w400,
        color: isActive ? const Color(0xFF124FC7) : const Color(0xFF353C49),
        decoration: TextDecoration.none,
      );

  Widget _buildBottomNav(double s, BuildContext context) {
    // 네비는 CSS top 1018, height 52
    // 요소들의 nav-기준 top = CSS abs top - 1018
    return Container(
      width: double.infinity,
      height: 52 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFDEDEDE), width: 1 * s),
        ),
      ),
      child: Stack(
        children: [
          // 홈 (CSS top 1023 → 5)
          Positioned(
            left: 17 * s,
            top: 5 * s,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/home_click.png',
                width: 24 * s,
                height: 24 * s,
              ),
            ),
          ),
          Positioned(
            left: 24 * s,
            top: 30 * s, // 1048-1018
            child: Text('홈', style: _navLabelStyle(s, false)),
          ),
          // 커뮤니티
          Positioned(
            left: 93 * s,
            top: 5 * s,
            child: Image.asset(
              'assets/community_click.png',
              width: 24 * s,
              height: 24 * s,
            ),
          ),
          Positioned(
            left: 86 * s,
            top: 30 * s,
            child: Text('커뮤니티', style: _navLabelStyle(s, false)),
          ),
          // 스페이스 (rocket)
          Positioned(
            left: 172 * s,
            top: 5 * s,
            child: Image.asset(
              'assets/rocket_click.png',
              width: 27 * s,
              height: 26 * s,
            ),
          ),
          Positioned(
            left: 165 * s,
            top: 30 * s,
            child: Text('스페이스', style: _navLabelStyle(s, false)),
          ),
          // 뉴스룸 (clock, CSS top 1026 → 8)
          Positioned(
            left: 252 * s,
            top: 8 * s,
            child: Image.asset(
              'assets/clock_click.png',
              width: 22 * s,
              height: 22 * s,
            ),
          ),
          Positioned(
            left: 249 * s,
            top: 30 * s,
            child: Text('뉴스룸', style: _navLabelStyle(s, false)),
          ),
          // 투자정보 (chart, active, CSS top 1027 → 9)
          Positioned(
            left: 327 * s,
            top: 9 * s,
            child: Image.asset(
              'assets/chart_click.png',
              width: 21 * s,
              height: 19 * s,
            ),
          ),
          Positioned(
            left: 318 * s,
            top: 30 * s,
            child: Text('투자정보', style: _navLabelStyle(s, true)),
          ),
        ],
      ),
    );
  }
}
