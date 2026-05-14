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

  // (label, textLeft, underlineLeft, underlineWidth) — 414px base
  static const List<(String, double, double, double)> _tabs = [
    ('검색트렌드', 35.0, 32.0, 75.0),
    ('소셜트렌드', 126.0, 123.0, 75.0),
    ('Pre-listing', 218.0, 215.0, 80.0),
  ];

  // (rank, korName, symbol, engName)
  static const List<(int, String, String, String)> _rankData = [
    (1,  '코박',    'CBK',  'COBAK'),
    (2,  '비트코인', 'BTC',  'BITCOIN'),
    (3,  '이더리움', 'ETH',  'ETHEREUM'),
    (4,  '리플',    'XRP',  'RIPPLE'),
    (5,  '도지코인', 'DOGE', 'DOGECOIN'),
    (6,  '솔라나',  'SOL',  'SOLANA'),
    (7,  '에이다',  'ADA',  'CARDANO'),
    (8,  '폴리곤',  'MATIC','POLYGON'),
    (9,  '체인링크', 'LINK', 'CHAINLINK'),
    (10, '아발란체', 'AVAX', 'AVALANCHE'),
  ];

  @override
  Widget build(BuildContext context) {
    final double flutterTop = MediaQuery.of(context).padding.top;
    final double topPadding =
        (flutterTop > 0 || !kIsWeb) ? flutterTop : cssSafeAreaTop();

    // 기준 사이즈 414 × 896px 고정: 실제 폭이 414px 초과하면 s=1.0으로 클램프
    final double refWidth =
        MediaQuery.of(context).size.width.clamp(0.0, 414.0);
    final double s = refWidth / 414.0;

    return ThemeColorScope(
      color: '#FFFFFF',
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          size: Size(refWidth, MediaQuery.of(context).size.height),
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Column(
          children: [
            Container(height: topPadding, color: Colors.white),
            _buildHeader(s),
            _buildTabBar(s),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: _buildContent(s),
              ),
            ),
            _buildBottomNav(s, context),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildHeader(double s) {
    return Container(
      width: double.infinity,
      height: 56 * s,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20 * s),
      child: Text(
        '투자정보',
        style: GoogleFonts.notoSansKr(
          fontSize: 18 * s,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1E27),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildTabBar(double s) {
    return SizedBox(
      width: double.infinity,
      height: 56 * s,
      child: ColoredBox(
        color: const Color(0xFF2C6CEB),
        child: Stack(
          children: [
            for (int i = 0; i < _tabs.length; i++)
              Positioned(
                left: _tabs[i].$2 * s,
                top: 13 * s,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _selectedTab = i),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10 * s),
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
              ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: _tabs[_selectedTab].$3 * s,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _tabs[_selectedTab].$4 * s,
                height: 2 * s,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(double s) {
    if (_selectedTab != 0) {
      return SizedBox(
        height: 948 * s,
        child: Center(
          child: Text(
            '준비 중입니다.',
            style: GoogleFonts.notoSansKr(
              fontSize: 15 * s,
              color: const Color(0xFF697483),
            ),
          ),
        ),
      );
    }

    final now = DateTime.now();
    final dateStr =
        '${now.year}. ${now.month.toString().padLeft(2, '0')}. ${now.day.toString().padLeft(2, '0')}';

    return SizedBox(
      height: 948 * s,
      child: Stack(
        children: [
          // 섹션 타이틀 (top: 190-156=34)
          Positioned(
            top: 34 * s,
            left: 20 * s,
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
          // 서브타이틀 (top: 215-156=59)
          Positioned(
            top: 59 * s,
            left: 20 * s,
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
          // 인기 검색 순위 카드 (top: 255-156=99, left: 16)
          Positioned(
            top: 99 * s,
            left: 16 * s,
            child: Container(
              width: 382 * s,
              height: 778 * s,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15 * s),
              ),
              child: Stack(
                children: [
                  // 카드 타이틀 (top: 276-255=21, left: 35-16=19)
                  Positioned(
                    top: 21 * s,
                    left: 19 * s,
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
                  // 카드 서브타이틀 (top: 304-255=49)
                  Positioned(
                    top: 49 * s,
                    left: 19 * s,
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
                  // 날짜 필터 버튼 (top: 340-255=85, left: 40-16=24)
                  Positioned(
                    top: 85 * s,
                    left: 24 * s,
                    child: Container(
                      width: 119 * s,
                      height: 36 * s,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(10 * s),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        dateStr,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 14 * s,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF353C49),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  // 인기 검색 코인 제외 필터 (top: 340-255=85, left: 173-16=157)
                  Positioned(
                    top: 85 * s,
                    left: 157 * s,
                    child: Container(
                      width: 147 * s,
                      height: 36 * s,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F9FE),
                        borderRadius: BorderRadius.circular(10 * s),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 15 * s,
                            height: 15 * s,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2C6CEB),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4 * s),
                          Text(
                            '인기 검색 코인 제외',
                            style: GoogleFonts.notoSansKr(
                              fontSize: 12 * s,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2C6CEB),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 순위 리스트 1~10위 (1위 top: 394-255=139, 간격 52)
                  for (int i = 0; i < _rankData.length; i++)
                    Positioned(
                      top: (139 + i * 52) * s,
                      left: 0,
                      right: 0,
                      child: _RankItem(
                        rank: _rankData[i].$1,
                        name: _rankData[i].$2,
                        symbol: _rankData[i].$3,
                        english: _rankData[i].$4,
                        s: s,
                      ),
                    ),
                  // 이전 버튼 (top: 969-255=714, left: 44-16=28)
                  Positioned(
                    top: 714 * s,
                    left: 28 * s,
                    child: _PaginationButton(label: '<', s: s),
                  ),
                  // 현재 페이지 (top: 962-255=707, left: 193-16=177)
                  Positioned(
                    top: 707 * s,
                    left: 177 * s,
                    child: Text(
                      '1/5',
                      style: GoogleFonts.notoSansKr(
                        fontSize: 17 * s,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1E27),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  // 페이지 범위 (top: 990-255=735, left: 177-16=161)
                  Positioned(
                    top: 735 * s,
                    left: 161 * s,
                    child: Text(
                      '1위 ~ 10위',
                      style: GoogleFonts.notoSansKr(
                        fontSize: 13 * s,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF697483),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  // 다음 버튼 (top: 969-255=714, left: 334-16=318)
                  Positioned(
                    top: 714 * s,
                    left: 318 * s,
                    child: _PaginationButton(label: '>', s: s),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 1, color: const Color(0xFFDEDEDE)),
          SizedBox(
            width: double.infinity,
            height: 52 * s,
            child: Stack(
              children: [
                // 홈 (left: 38, top: 1112-1104=8)
                Positioned(
                  left: 38 * s,
                  top: 8 * s,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset('assets/home.png',
                        width: 24 * s, height: 24 * s),
                  ),
                ),
                Positioned(
                  left: 45 * s,
                  top: 33 * s,
                  child: Text('홈', style: _navLabelStyle(s, false)),
                ),
                // 커뮤니티 (left: 114)
                Positioned(
                  left: 114 * s,
                  top: 8 * s,
                  child: Image.asset('assets/community.png',
                      width: 24 * s, height: 24 * s),
                ),
                Positioned(
                  left: 107 * s,
                  top: 33 * s,
                  child: Text('커뮤니티', style: _navLabelStyle(s, false)),
                ),
                // 스페이스 (left: 193, top: 8, 27×26)
                Positioned(
                  left: 193 * s,
                  top: 8 * s,
                  child: Image.asset('assets/rcket_click.png',
                      width: 27 * s, height: 26 * s),
                ),
                Positioned(
                  left: 186 * s,
                  top: 33 * s,
                  child: Text('스페이스', style: _navLabelStyle(s, false)),
                ),
                // 뉴스룸 (left: 273, top: 1115-1104=11, 22×22)
                Positioned(
                  left: 273 * s,
                  top: 11 * s,
                  child: Image.asset('assets/clock.png',
                      width: 22 * s, height: 22 * s),
                ),
                Positioned(
                  left: 270 * s,
                  top: 33 * s,
                  child: Text('뉴스룸', style: _navLabelStyle(s, false)),
                ),
                // 투자정보 (active, left: 348, top: 1116-1104=12, 21×19)
                Positioned(
                  left: 348 * s,
                  top: 12 * s,
                  child: Image.asset(
                    'assets/invest.png',
                    width: 21 * s,
                    height: 19 * s,
                    color: const Color(0xFF124FC7),
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
                Positioned(
                  left: 339 * s,
                  top: 33 * s,
                  child: Text('투자정보', style: _navLabelStyle(s, true)),
                ),
              ],
            ),
          ),
          // 스와이프바 (34px)
          Container(height: 34 * s, color: Colors.white),
        ],
      ),
    );
  }
}

// ── 순위 리스트 아이템 ─────────────────────────────────────────────────────

class _RankItem extends StatelessWidget {
  final int rank;
  final String name;
  final String symbol;
  final String english;
  final double s;

  const _RankItem({
    required this.rank,
    required this.name,
    required this.symbol,
    required this.english,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    // 좌표는 카드 기준 (카드 left=16, 화면-절대 left에서 16 차감)
    return SizedBox(
      height: 52 * s,
      child: Stack(
        children: [
          // 순위 번호 (화면58 → 카드42, 세로 중앙)
          Positioned(
            left: 42 * s,
            top: 19 * s,
            child: Text(
              '$rank',
              style: GoogleFonts.notoSansKr(
                fontSize: 14 * s,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 코인 로고 (화면84 → 카드68, 32×32 세로 중앙)
          Positioned(
            left: 68 * s,
            top: 10 * s,
            child: Image.asset(
              'assets/cobak_logo.png',
              width: 32 * s,
              height: 32 * s,
            ),
          ),
          // 코인명 (화면128 → 카드112)
          Positioned(
            left: 112 * s,
            top: 10 * s,
            child: Text(
              name,
              style: GoogleFonts.notoSansKr(
                fontSize: 15 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF353C49),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 심볼 (화면163 → 카드147)
          Positioned(
            left: 147 * s,
            top: 11 * s,
            child: Text(
              symbol,
              style: GoogleFonts.notoSansKr(
                fontSize: 14 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF697483),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 영문명 (화면128 → 카드112, 코인명 아래)
          Positioned(
            left: 112 * s,
            top: 29 * s,
            child: Text(
              english,
              style: GoogleFonts.notoSansKr(
                fontSize: 12 * s,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF697483),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 페이지네이션 버튼 ───────────────────────────────────────────────────────

class _PaginationButton extends StatelessWidget {
  final String label;
  final double s;

  const _PaginationButton({required this.label, required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36 * s,
      height: 36 * s,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10 * s),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: GoogleFonts.notoSansKr(
          fontSize: 16 * s,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF353C49),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
