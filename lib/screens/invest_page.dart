import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/pwa_utils.dart';
import '../utils/theme_color.dart';

class InvestPage extends StatefulWidget {
  /// 바로가기로 진입한 경우에만 카운트다운 노출
  final bool fromShortcut;
  const InvestPage({super.key, this.fromShortcut = true});

  @override
  State<InvestPage> createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage>
    with TickerProviderStateMixin {
  int _selectedTab = 0;

  // ── 카운트다운 상태 ─────────────────────────────────────────────────────
  int _countdownSeconds = 10;
  bool _hasScrolled = false; // 진입 후 한 번이라도 스크롤했는지
  bool _isScrolling = false;
  bool _isAchieved = false;
  bool _isSuccessVisible = false; // 미션 성공 UI 표시 중

  Timer? _countdownTimer;
  Timer? _scrollStopTimer;

  late final ScrollController _scrollController;
  late final AnimationController _floatController;
  late final Animation<double> _floatAnim;

  // 폭죽 애니메이션
  late final AnimationController _celebrationController;
  List<_Particle> _particles = const [];

  // (label, left) — 375px 디자인 기준
  static const List<(String, double)> _tabs = [
    ('검색트렌드', 17.0),
    ('소셜트렌드', 108.0),
    ('Pre-listing', 200.0),
  ];

  // (rank, korName, symbol, engName) — mock 데이터
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
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _floatController.dispose();
    _celebrationController.dispose();
    _countdownTimer?.cancel();
    _scrollStopTimer?.cancel();
    super.dispose();
  }

  List<_Particle> _generateParticles() {
    final rng = Random();
    const colors = [
      Color(0xFFFF6B6B), // red
      Color(0xFFFFD93D), // yellow
      Color(0xFF6BCF7F), // green
      Color(0xFF4D96FF), // blue
      Color(0xFFFF8FB1), // pink
      Color(0xFFB983FF), // purple
      Color(0xFFFFA94D), // orange
    ];
    return List.generate(40, (_) {
      return _Particle(
        angle: rng.nextDouble() * 2 * pi,
        speed: 90 + rng.nextDouble() * 180,
        gravity: 250 + rng.nextDouble() * 180,
        color: colors[rng.nextInt(colors.length)],
        radius: 3 + rng.nextDouble() * 4,
      );
    });
  }

  void _onScroll() {
    if (_isAchieved || !widget.fromShortcut) return;
    if (!_hasScrolled || !_isScrolling) {
      setState(() {
        _hasScrolled = true;
        _isScrolling = true;
      });
      _startCountdownTimer();
    }
    _scrollStopTimer?.cancel();
    // 스크롤 멈춤 감지: 1초 딜레이 후 일시정지(노란색) 전환
    _scrollStopTimer = Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isScrolling = false);
      _countdownTimer?.cancel();
    });
  }

  void _triggerCelebration() {
    HapticFeedback.lightImpact();
    _particles = _generateParticles();
    _celebrationController.reset();
    _celebrationController.forward().then((_) {
      if (!mounted) return;
      setState(() => _isSuccessVisible = false);
    });
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_countdownSeconds > 0) _countdownSeconds--;
        if (_countdownSeconds == 0) {
          _isAchieved = true;
          _isScrolling = false;
          _isSuccessVisible = true;
          t.cancel();
          _scrollStopTimer?.cancel();
        }
      });
      if (_isAchieved) {
        _triggerCelebration();
      }
    });
  }

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
        body: Stack(
          children: [
            Column(
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
            // 카운트다운 오버레이 (하단 네비 바로 위) — 달성 전까지만
            if (widget.fromShortcut && !_isAchieved)
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomSafe + (52 * s) + (16 * s),
                child: Center(child: _buildCountdownBar(s)),
              ),
            // 미션 완료 폭죽 오버레이 (전체 화면 중앙)
            if (_isSuccessVisible) _buildCelebrationOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _celebrationController,
          builder: (context, _) {
            final t = _celebrationController.value;
            // 텍스트 스케일: 초반에 팝업, 끝에 약간 페이드
            final scale = t < 0.25
                ? Curves.elasticOut.transform(t / 0.25)
                : 1.0;
            final textOpacity = t < 0.85 ? 1.0 : (1.0 - (t - 0.85) / 0.15);
            return Stack(
              alignment: Alignment.center,
              children: [
                // 폭죽 파티클
                CustomPaint(
                  painter: _FireworkPainter(
                    progress: t,
                    particles: _particles,
                  ),
                  size: Size.infinite,
                ),
                // "미션 완료!" 텍스트
                Opacity(
                  opacity: textOpacity.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: scale.clamp(0.0, 1.2),
                    child: Text(
                      '미션 완료!',
                      style: GoogleFonts.notoSansKr(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1A1E27),
                        decoration: TextDecoration.none,
                        shadows: [
                          Shadow(
                            color: Colors.white.withValues(alpha: 0.9),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
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
                fontSize: 18,
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
                    fontSize: 15,
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
            fontSize: 15,
            color: const Color(0xFF697483),
          ),
        ),
      );
    }

    // 오늘 날짜 (날짜 필터 버튼 텍스트)
    final now = DateTime.now();
    final dateStr =
        '${now.year}. ${now.month.toString().padLeft(2, '0')}. ${now.day.toString().padLeft(2, '0')}';

    // 콘텐츠 영역은 CSS top 104(탭바 끝) ~ 1018(네비 시작), 높이 914
    return SingleChildScrollView(
      controller: _scrollController,
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
                  fontSize: 18,
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
                  fontSize: 14,
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
                          fontSize: 16,
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
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF697483),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    // 날짜 필터 버튼 Rectangle 1472 (CSS top 277 → 81, left 32 → 16)
                    Positioned(
                      top: 81 * s,
                      left: 16 * s,
                      child: Container(
                        width: 119 * s,
                        height: 36 * s,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(10 * s),
                        ),
                        child: Stack(
                          children: [
                            // 날짜 텍스트 (CSS left 52 → 버튼 기준 20, top 284 → 7)
                            Positioned(
                              left: 20 * s,
                              top: 7 * s,
                              child: Text(
                                dateStr,
                                style: GoogleFonts.notoSansKr(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF353C49),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 코인 제외 필터 버튼 Rectangle 1471 (CSS top 277 → 81, left 165 → 149)
                    Positioned(
                      top: 81 * s,
                      left: 149 * s,
                      child: Container(
                        width: 147 * s,
                        height: 36 * s,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F9FE),
                          borderRadius: BorderRadius.circular(10 * s),
                        ),
                        child: Stack(
                          children: [
                            // 체크 아이콘 원형 Ellipse 40 (CSS left 171 → 버튼 기준 6, top 287 → 10, 15×15)
                            Positioned(
                              left: 6 * s,
                              top: 10 * s,
                              child: Container(
                                width: 15 * s,
                                height: 15 * s,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2C6CEB),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.check,
                                  size: 10 * s,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // 필터 텍스트 (CSS left 190 → 버튼 기준 25, top 284 → 7)
                            Positioned(
                              left: 25 * s,
                              top: 7 * s,
                              child: Text(
                                '인기 검색 코인 제외',
                                style: GoogleFonts.notoSansKr(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2C6CEB),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 순위 리스트 1~10위 (1위 CSS top 330 → 카드 기준 134부터 Column으로 적층)
                    Positioned(
                      top: 134 * s,
                      left: 11 * s, // CSS left 27 → 카드 기준 11
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < _rankData.length; i++)
                            _RankItem(
                              rank: _rankData[i].$1,
                              name: _rankData[i].$2,
                              symbol: _rankData[i].$3,
                              english: _rankData[i].$4,
                              s: s,
                            ),
                        ],
                      ),
                    ),
                    // 이전 버튼 (CSS top 909 → 713, left 23 → 7)
                    Positioned(
                      top: 713 * s,
                      left: 7 * s,
                      child: _PaginationButton(label: '<', s: s),
                    ),
                    // 현재 페이지 "1/5" (CSS top 902 → 706, left 172 → 156)
                    Positioned(
                      top: 706 * s,
                      left: 156 * s,
                      child: Text(
                        '1/5',
                        style: GoogleFonts.notoSansKr(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1E27),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    // 페이지 범위 "1위 ~ 10위" (CSS top 930 → 734, left 156 → 140)
                    Positioned(
                      top: 734 * s,
                      left: 140 * s,
                      child: Text(
                        '1위 ~ 10위',
                        style: GoogleFonts.notoSansKr(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF697483),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    // 다음 버튼 (CSS top 909 → 713, left 313 → 297)
                    Positioned(
                      top: 713 * s,
                      left: 297 * s,
                      child: _PaginationButton(label: '>', s: s),
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
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: isActive ? const Color(0xFF124FC7) : const Color(0xFF353C49),
        decoration: TextDecoration.none,
      );

  Widget _buildCountdownBar(double s) {
    // 진입 직후(스크롤 전)는 active 상태 유지 (하늘색 + "10초" 고정)
    final bool active = !_hasScrolled || _isScrolling;

    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: child,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: (active ? 81 : 206) * s,
        height: 32 * s,
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFE0ECFF)
              : const Color(0xFFFFF7E2).withValues(alpha: 0.8),
          border: Border.all(
            color: active
                ? const Color(0xFF69B7FF)
                : const Color(0xFFFFD971),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20 * s),
        ),
        alignment: Alignment.center,
        child: ClipRect(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Row(
              key: ValueKey(active ? 'active' : 'pause'),
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$_countdownSeconds초',
                  style: GoogleFonts.notoSansKr(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: active
                        ? const Color(0xFF4A85F9)
                        : const Color(0xFFE99C1F),
                    decoration: TextDecoration.none,
                  ),
                ),
                if (!active) ...[
                  SizedBox(width: 6 * s),
                  Text(
                    '멈추지 말고 더 둘러보세요!',
                    style: GoogleFonts.notoSansKr(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF707070),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

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
    // 아이템 width 326, height 52. 내부 좌표는 CSS 절대값에서 아이템 left(27) 차감.
    return Container(
      width: 326 * s,
      height: 52 * s,
      color: const Color(0xFFFFFEFE),
      child: Stack(
        children: [
          // 순위 번호 (CSS left 41 → 아이템 기준 14)
          Positioned(
            left: 14 * s,
            top: 19 * s, // (52-14)/2 = 19 세로 중앙
            child: Text(
              '$rank',
              style: GoogleFonts.notoSansKr(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // cobak_logo.png (CSS left 67 → 40, 32×32 세로 중앙)
          Positioned(
            left: 40 * s,
            top: 10 * s, // (52-32)/2 = 10
            child: Image.asset(
              'assets/cobak_logo.png',
              width: 32 * s,
              height: 32 * s,
            ),
          ),
          // 코인명 + 심볼 (코인명 우측에 심볼이 자동으로 붙도록 Row 처리)
          Positioned(
            left: 84 * s,
            top: 10 * s,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  name,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF353C49),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 4 * s),
                Text(
                  symbol,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF697483),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          // 영문명 (CSS left 111 → 84, 코인명 아래)
          Positioned(
            left: 84 * s,
            top: 29 * s,
            child: Text(
              english,
              style: GoogleFonts.notoSansKr(
                fontSize: 12,
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
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF7B7B7B),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

// ── 폭죽 파티클 ────────────────────────────────────────────────────────────

class _Particle {
  final double angle;   // 발사 각도 (rad)
  final double speed;   // 발사 속도 (px)
  final double gravity; // 중력 (px, t² 적용)
  final Color color;
  final double radius;

  const _Particle({
    required this.angle,
    required this.speed,
    required this.gravity,
    required this.color,
    required this.radius,
  });
}

class _FireworkPainter extends CustomPainter {
  final double progress; // 0.0 ~ 1.0
  final List<_Particle> particles;

  _FireworkPainter({required this.progress, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    final t = progress.clamp(0.0, 1.0);
    // 70% 까지는 풀 알파 유지, 이후 페이드
    final alpha = t < 0.7 ? 1.0 : (1.0 - (t - 0.7) / 0.3).clamp(0.0, 1.0);

    for (final p in particles) {
      final dx = cos(p.angle) * p.speed * t;
      final dy = sin(p.angle) * p.speed * t + p.gravity * t * t;
      final pos = center + Offset(dx, dy);
      final paint = Paint()
        ..color = p.color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pos, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_FireworkPainter old) =>
      old.progress != progress || old.particles != particles;
}
