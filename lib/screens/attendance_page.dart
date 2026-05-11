import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme_color.dart';
import '../utils/pwa_utils.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool _notificationOn = true;
  bool _checkedIn = false;
  int _attendanceDays = 1;
  int _earnedPoints = 10;

  bool _isExpanded = true;
  bool _noticeExpanded = false;
  bool _headerWhite = false;

  late final ScrollController _scrollController;
  final GlobalKey _noticeSectionKey = GlobalKey();
  double _scrollTriggerY = 0;

  // 달력 컬럼 positions (card-relative, card left=0, width=390)
  static const List<double> _colPositions = [38, 88, 139, 189, 240, 290, 341];
  static const List<String> _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  static const List<String> _noticeItems = [
    '출석체크는 매일 1회 참여 가능하며, 한국시간(UTC+9) 기준 자정(00:00)에 초기화됩니다.',
    '출석 횟수는 매월 1일 오전 12시에 리셋됩니다.',
    '출석 회차에 따라 보너스 포인트가 지급되며, 연속 출석 여부와 관계없이 누적 횟수 기준으로 산정됩니다.',
    '이용 중인 멤버십 등급에 따라 출석 포인트가 다르게 지급됩니다.',
    '보너스 포인트는 해당 회차 출석 당일 자동 지급됩니다.',
    '출석 보상은 내부 정책에 의해 변경될 수 있습니다.',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final bool shouldBeWhite = _scrollController.offset >= _scrollTriggerY;
    if (shouldBeWhite != _headerWhite) {
      setState(() => _headerWhite = shouldBeWhite);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Flutter Web이 safe area top을 0으로 반환하면 CSS env(safe-area-inset-top) fallback 사용
    final double flutterTop = MediaQuery.of(context).padding.top;
    final double topPadding =
        (flutterTop > 0 || !kIsWeb) ? flutterTop : cssSafeAreaTop();
    final double s = MediaQuery.of(context).size.width / 390;

    final now = DateTime.now();
    final int year = now.year;
    final int month = now.month;
    final int daysInMonth = DateTime(year, month + 1, 0).day;
    final int startCol = DateTime(year, month, 1).weekday % 7;
    final int numRows = (startCol + daysInMonth + 6) ~/ 7;

    final double calCardHeight = 124.0 + numRows * 47.0 + 16.0;

    // calendar_card top이 my_header 하단에 닿는 스크롤 오프셋
    _scrollTriggerY = 250.0 * s;

    // scroll-relative 좌표
    // my_header2(70) →[20px]→ 보너스카드(135) →[25px]→ 달력카드 →[1px]→ 구분선 →[15px]→ 미션영역
    const double bonusCardTop = 90.0;
    const double calCardTop = 250.0;
    final double missionDivTop = calCardTop + calCardHeight + 1;  // 상단 구분선
    final double missionBgTop  = missionDivTop + 15;              // 미션 카드 배경
    final double contentHeight = missionBgTop + 133 + 15;   // 배경+하단구분선

    return ThemeColorScope(
      color: '#F4F8FF',
      child: Scaffold(
        backgroundColor: const Color(0xFFFEFEFF),
        body: Column(
          children: [
            _buildHeader(context, topPadding, s),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: contentHeight * s,
                  child: Stack(
                    children: [
                      // 626px 그라데이션 배경 (#F4F8FF → #EBF3FF)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 626 * s,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFF4F8FF), Color(0xFFEBF3FF)],
                            ),
                          ),
                        ),
                      ),
                      // my_header2: 스크롤 콘텐츠와 함께 이동
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: _buildMyHeader2(s),
                      ),
                      // 출석 보너스 달성 현황: my_header2 하단 20px 아래
                      Positioned(
                        top: bonusCardTop * s,
                        left: 15 * s,
                        child: _buildBonusCard(s),
                      ),
                      // 달력 카드: 보너스카드 하단 25px 아래, 전체 너비
                      Positioned(
                        top: calCardTop * s,
                        left: 0,
                        child: _buildCalendarCard(
                            s, year, month, daysInMonth, startCol, calCardHeight),
                      ),
                      // 상단 구분선 (15px #F5F5F5)
                      Positioned(
                        top: missionDivTop * s,
                        left: 0,
                        child: Container(
                          width: 390 * s,
                          height: 15 * s,
                          color: const Color(0xFFF5F5F5),
                        ),
                      ),
                      // 미션 카드 배경 (390×133 흰색)
                      Positioned(
                        top: missionBgTop * s,
                        left: 0,
                        child: Container(
                          width: 390 * s,
                          height: 133 * s,
                          color: Colors.white,
                        ),
                      ),
                      // 타이틀 텍스트
                      Positioned(
                        top: (missionBgTop + 30) * s,
                        left: 19 * s,
                        child: Text(
                          '간단한 미션으로 포인트 획득!',
                          style: GoogleFonts.inter(
                            fontSize: 15 * s,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF272727),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      // 미션 보러가기 터치 영역
                      Positioned(
                        top: (missionBgTop + 66) * s,
                        left: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: SizedBox(
                            width: 390 * s,
                            height: 52 * s,
                            child: Stack(
                              children: [
                                // 머니백 아이콘
                                Positioned(
                                  top: 10 * s,
                                  left: 25 * s,
                                  child: Image.asset(
                                    'assets/moneybag.png',
                                    width: 32 * s,
                                    height: 32 * s,
                                  ),
                                ),
                                // "미션 보러가기"
                                Positioned(
                                  top: 7 * s,
                                  left: 65 * s,
                                  child: Text(
                                    '미션 보러가기',
                                    style: GoogleFonts.inter(
                                      fontSize: 15 * s,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF272727),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                                // 서브텍스트
                                Positioned(
                                  top: 29 * s,
                                  left: 65 * s,
                                  child: Text(
                                    '매일 새로운 미션이 업데이트됩니다',
                                    style: GoogleFonts.inter(
                                      fontSize: 12 * s,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF868686),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                                // 우측 화살표
                                Positioned(
                                  right: 23 * s,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: Icon(
                                      Icons.chevron_right,
                                      size: 20 * s,
                                      color: const Color(0xFF868686),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 하단 구분선 (15px #F5F5F5)
                      Positioned(
                        top: (missionBgTop + 133) * s,
                        left: 0,
                        child: Container(
                          width: 390 * s,
                          height: 15 * s,
                          color: const Color(0xFFF5F5F5),
                        ),
                      ),
                    ],
                  ),
                    ),
                    _buildNoticeSection(s),
                    SizedBox(height: 20 * s),
                  ],
                ),
              ),
            ),
            _buildFixedPointsSection(context, s, month),
          ],
        ),
      ),
    );
  }

  // ── 헤더 (DI + 헤더바 46px) ────────────────────────────────────────

  Widget _buildHeader(BuildContext context, double topPadding, double s) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // DI 영역: 항상 #F4F8FF
        Container(
          height: topPadding,
          color: const Color(0xFFF4F8FF),
        ),
        // 헤더바: 46px, 스크롤에 따라 #F4F8FF ↔ #FFFFFF 전환
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: 46 * s,
          color: _headerWhite ? Colors.white : const Color(0xFFF4F8FF),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15 * s),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset('assets/arrow_back.png', width: 25 * s, height: 25 * s),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 14 * s,
                child: Text(
                  '출석체크',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14 * s,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── my_header2 (70px) ───────────────────────────────────────────────

  Widget _buildMyHeader2(double s) {
    return Container(
      height: 70 * s,
      color: Colors.transparent,
      child: Stack(
        children: [
          // "매일 출석하고 보너스 포인트 받으세요!"
          Positioned(
            top: 17 * s,
            left: 15 * s,
            child: Text(
              '매일 출석하고 보너스 포인트 받으세요!',
              style: GoogleFonts.inter(
                fontSize: 11 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 출석 일수
          Positioned(
            top: 39 * s,
            left: 19 * s,
            child: Text(
              '$_attendanceDays',
              style: GoogleFonts.inter(
                fontSize: 25 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF272727),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // "일째 출석중"
          Positioned(
            top: 50 * s,
            left: 39 * s,
            child: Text(
              '일째 출석중',
              style: GoogleFonts.inter(
                fontSize: 12 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // "출석체크 알림받기"
          Positioned(
            top: 53 * s,
            left: 255 * s,
            child: Text(
              '출석체크 알림받기',
              style: GoogleFonts.inter(
                fontSize: 11 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8B8B8B),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 토글: top 51, width 36, height 18 → bottom at 69
          Positioned(
            top: 51 * s,
            left: 344 * s,
            child: GestureDetector(
              onTap: () => setState(() => _notificationOn = !_notificationOn),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36 * s,
                height: 18 * s,
                decoration: BoxDecoration(
                  color: _notificationOn
                      ? const Color(0xFF3B79F5)
                      : const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(50 * s),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: _notificationOn
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(1 * s),
                    child: Container(
                      width: 16 * s,
                      height: 16 * s,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 출석 보너스 달성 현황 (360×135, 5-day layout) ─────────────────

  Widget _buildBonusCard(double s) {
    const List<double> itemLefts = [
      45,  114, 183, 252, 321, 390, 459, 528, 597, 666,
      735, 804, 873, 942, 1011, 1080, 1149, 1218, 1287, 1356,
      1425, 1494, 1563, 1632, 1701, 1770, 1839, 1908, 1977, 2046,
    ];
    const Map<int, String> bonusPoints = {
      3: '50P', 7: '100P', 10: '150P', 14: '200P',
      17: '220P', 20: '250P', 25: '350P',
      26: '100P', 27: '100P', 28: '100P', 29: '100P', 30: '100P',
    };
    const Set<int> starDays = {3, 7, 10, 14, 17, 20, 25};

    // 카드 내부 수직 레이아웃 (card height 135px 기준)
    const double speechTop = 4;   // 말풍선 top (36px container + 6px tail → bottom 46)
    const double circTop   = 50;  // 원 top (height 41 → bottom 91, center 70.5)
    const double connY     = 70;  // 연결선 top (원 수직 중앙)
    const double lblTop    = 96;  // 일차 레이블 top

    final List<Widget> children = [];

    for (int i = 0; i < 30; i++) {
      final int day = i + 1;
      final double left = itemLefts[i];
      final bool isStar = starDays.contains(day);
      final String? point = bonusPoints[day];

      // 말풍선 (보너스 일차)
      if (point != null) {
        children.add(Positioned(
          left: left * s,
          top: speechTop * s,
          child: _buildSpeechBubble(s, point),
        ));
      }

      // 원형 아이콘
      children.add(Positioned(
        left: left * s,
        top: circTop * s,
        child: Container(
          width: 41 * s,
          height: 41 * s,
          decoration: BoxDecoration(
            color: day <= _attendanceDays
                ? const Color(0xFF277FFF)
                : const Color(0xFFE6E6E6),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: isStar
              ? Icon(Icons.star, size: 20 * s, color: Colors.white)
              : Icon(Icons.check, size: 14 * s, color: Colors.white),
        ),
      ));

      // 연결선 (마지막 아이템 제외)
      if (i < 29) {
        children.add(Positioned(
          left: (left + 42) * s,
          top: connY * s,
          child: Container(width: 26 * s, height: 2, color: const Color(0xFFE6E6E6)),
        ));
      }

      // 일차 레이블
      children.add(Positioned(
        left: left * s,
        top: lblTop * s,
        width: 41 * s,
        child: Text(
          '$day일차',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 11 * s,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6C6C6C),
            decoration: TextDecoration.none,
          ),
        ),
      ));

    }

    return Container(
      width: 360 * s,
      height: 135 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30 * s),
        border: Border.all(color: const Color(0xFFEDF0F5), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30 * s),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: SizedBox(
            width: 2102 * s,
            child: Stack(children: children),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeechBubble(double s, String point) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 41 * s,
          height: 36 * s,
          decoration: BoxDecoration(
            color: const Color(0xFFD4EAFF),
            borderRadius: BorderRadius.circular(6 * s),
          ),
          alignment: Alignment.center,
          child: Text(
            point,
            style: GoogleFonts.inter(
              fontSize: 12 * s,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF2D6CEB),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        CustomPaint(
          size: Size(8 * s, 6 * s),
          painter: const _TailPainter(Color(0xFFD4EAFF)),
        ),
      ],
    );
  }

  // ── 달력 카드 (390px full-width, left 0, radius tl/tr 30) ──────────

  Widget _buildCalendarCard(
    double s,
    int year,
    int month,
    int daysInMonth,
    int startCol,
    double cardHeight,
  ) {
    final List<Widget> dateWidgets = [];
    for (int day = 1; day <= daysInMonth; day++) {
      final int idx = startCol + day - 1;
      final int col = idx % 7;
      final int row = idx ~/ 7;

      // 목업 상태: 1일 출석완료, 2일 미출석, 3일 버튼 탭 시 완료
      Color? bgColor;
      bool showPoints = false;
      if (day == 1) {
        bgColor = const Color(0xFFE4EFFF);
        showPoints = true;
      } else if (day == 2) {
        bgColor = const Color(0xFFD8DBE0);
      } else if (day == 3 && _checkedIn) {
        bgColor = const Color(0xFFE4EFFF);
        showPoints = true;
      }

      if (bgColor != null) {
        // 배경 + 날짜 + 선택적 10P 텍스트
        dateWidgets.add(
          Positioned(
            left: (_colPositions[col] - 8) * s,
            top: (124 + row * 47 - 7) * s,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 25 * s,
                  height: 32 * s,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(5 * s),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: GoogleFonts.inter(
                      fontSize: 15 * s,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF272727),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                if (showPoints)
                  Text(
                    '10P',
                    style: GoogleFonts.inter(
                      fontSize: 11 * s,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF2D6CEB),
                      decoration: TextDecoration.none,
                    ),
                  ),
              ],
            ),
          ),
        );
      } else {
        dateWidgets.add(
          Positioned(
            left: _colPositions[col] * s,
            top: (124 + row * 47) * s,
            child: Text(
              '$day',
              style: GoogleFonts.inter(
                fontSize: 15 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF272727),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );
      }
    }

    return Container(
      width: 390 * s,
      height: cardHeight * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30 * s),
          topRight: Radius.circular(30 * s),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(87, 87, 87, 0.25),
            blurRadius: 3,
            spreadRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 연도: top 22, left 17
          Positioned(
            top: 22 * s,
            left: 17 * s,
            child: Text(
              '$year',
              style: GoogleFonts.inter(
                fontSize: 15 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF272727),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 월: top 44, left 17
          Positioned(
            top: 44 * s,
            left: 17 * s,
            child: Text(
              '$month월',
              style: GoogleFonts.inter(
                fontSize: 20 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF272727),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 요일 헤더: top 91
          for (int i = 0; i < 7; i++)
            Positioned(
              top: 91 * s,
              left: _colPositions[i] * s,
              child: Text(
                _weekdays[i],
                style: GoogleFonts.inter(
                  fontSize: 12 * s,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9D9D9D),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          // 날짜 (동적)
          ...dateWidgets,
        ],
      ),
    );
  }

  // ── 안내사항 토글 섹션 ──────────────────────────────────────────────

  Widget _buildNoticeSection(double s) {
    return Column(
      key: _noticeSectionKey,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 터치 영역 (58px)
        GestureDetector(
          onTap: () {
            final bool expanding = !_noticeExpanded;
            setState(() => _noticeExpanded = expanding);
            if (expanding) {
              // 애니메이션(300ms) 완료 후 안내사항 영역이 보이도록 스크롤
              Future.delayed(const Duration(milliseconds: 350), () {
                if (_noticeSectionKey.currentContext != null && mounted) {
                  Scrollable.ensureVisible(
                    _noticeSectionKey.currentContext!,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignmentPolicy:
                        ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
                  );
                }
              });
            }
          },
          child: Container(
            width: 390 * s,
            height: 58 * s,
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  top: 20 * s,
                  left: 19 * s,
                  child: Text(
                    '출석체크 안내사항',
                    style: GoogleFonts.inter(
                      fontSize: 15 * s,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF272727),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Positioned(
                  top: 25 * s,
                  left: 353 * s,
                  child: AnimatedRotation(
                    turns: _noticeExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: CustomPaint(
                      size: Size(9 * s, 7 * s),
                      painter: const _ChevronPainter(Color(0xFF8B8B8B)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 상세 내용 (애니메이션으로 펼침/닫힘, 높이 가변)
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _noticeExpanded
                ? Container(
                    width: 390 * s,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(17 * s, 13 * s, 17 * s, 20 * s),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < _noticeItems.length; i++) ...[
                          if (i > 0) SizedBox(height: 8 * s),
                          _buildBulletItem(s, _noticeItems[i]),
                        ],
                      ],
                    ),
                  )
                : SizedBox(width: 390 * s, height: 0),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletItem(double s, String text) {
    final style = GoogleFonts.inter(
      fontSize: 11 * s,
      fontWeight: FontWeight.w500,
      height: 13 / 11,
      color: const Color(0xFF6C6C6C),
      decoration: TextDecoration.none,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1 * s, right: 5 * s),
          child: Text('•', style: style),
        ),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }

  // ── 출석포인트 하단 고정 (기존 유지) ─────────────────────────────────

  Widget _buildFixedPointsSection(BuildContext context, double s, int month) {
    const double panelH = 133.0;
    const double collapsedH = 23.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ① 토글 버튼
        Center(
          child: GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              width: 54 * s,
              height: 18 * s,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10 * s),
                  topRight: Radius.circular(10 * s),
                ),
                border: const Border(
                  top: BorderSide(color: Color(0xFFD9D9D9), width: 1),
                  left: BorderSide(color: Color(0xFFD9D9D9), width: 1),
                  right: BorderSide(color: Color(0xFFD9D9D9), width: 1),
                ),
              ),
              alignment: Alignment.center,
              child: AnimatedRotation(
                turns: _isExpanded ? 0.0 : 0.5,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: CustomPaint(
                  size: Size(10 * s, 9 * s),
                  painter: const _ChevronPainter(),
                ),
              ),
            ),
          ),
        ),

        // ② 패널
        Container(
          width: 390 * s,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8FF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20 * s),
              topRight: Radius.circular(20 * s),
            ),
            border: const Border(
              top: BorderSide(color: Color(0xFFD9D9D9), width: 1),
            ),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            heightFactor: _isExpanded ? 1.0 : collapsedH / panelH,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 13 * s),
                SizedBox(
                  height: 32 * s,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 248 * s,
                        child: Padding(
                          padding: EdgeInsets.only(left: 22 * s, top: 6 * s),
                          child: Text(
                            '$month월 출석 포인트',
                            style: GoogleFonts.inter(
                              fontSize: 15 * s,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF272727),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '$_earnedPoints',
                        style: GoogleFonts.inter(
                          fontSize: 21 * s,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D6CEB),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        '/ 2,000P',
                        style: GoogleFonts.inter(
                          fontSize: 21 * s,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4B4B4B),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7 * s),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 19 * s),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double totalWidth = constraints.maxWidth;
                      final double ratio = (_attendanceDays / 30).clamp(0.0, 1.0);
                      return Stack(
                        children: [
                          // 배경 바
                          Container(
                            height: 9 * s,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(10 * s),
                            ),
                          ),
                          // 채워진 바
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: 9 * s,
                            width: totalWidth * ratio,
                            decoration: BoxDecoration(
                              color: const Color(0xFF277FFF),
                              borderRadius: BorderRadius.circular(10 * s),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 21 * s),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15 * s),
                  child: GestureDetector(
                    onTap: _checkedIn
                        ? null
                        : () {
                            setState(() {
                              _checkedIn = true;
                              _attendanceDays += 1;
                              _earnedPoints += 10;
                            });
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.black.withValues(alpha: 0.4),
                              builder: (_) => _AttendancePopup(day: _attendanceDays),
                            );
                          },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: 41 * s,
                      decoration: BoxDecoration(
                        color: _checkedIn
                            ? const Color(0xFFE4EFFF)
                            : const Color(0xFF2D6CEB),
                        borderRadius: BorderRadius.circular(10 * s),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _checkedIn ? '출석완료' : '출석하고 포인트 받기',
                        style: GoogleFonts.inter(
                          fontSize: 13 * s,
                          fontWeight: FontWeight.w600,
                          color: _checkedIn
                              ? const Color(0xFF85B7FF)
                              : Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10 * s),
              ],
            ),
          ),
        ),

        // ⑥ 스와이프바
        Container(
          width: 390 * s,
          height: 34 * s,
          color: const Color(0xFFF4F8FF),
        ),
      ],
    );
  }
}

class _TailPainter extends CustomPainter {
  final Color color;
  const _TailPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// "∨" 모양 화살표. AnimatedRotation(turns: 0.5)으로 "∧" 방향 전환
class _ChevronPainter extends CustomPainter {
  final Color color;
  const _ChevronPainter([this.color = const Color(0xFFA6A6A6)]);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final double h1 = size.height * 4 / 9;
    canvas.drawLine(Offset(0, 0), Offset(cx, h1), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(cx, h1), paint);
    final double y2 = size.height * 5 / 9;
    canvas.drawLine(Offset(0, y2), Offset(cx, size.height), paint);
    canvas.drawLine(Offset(size.width, y2), Offset(cx, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── 출석 완료 팝업 ────────────────────────────────────────────────────

class _AttendancePopup extends StatefulWidget {
  final int day;
  const _AttendancePopup({required this.day});

  @override
  State<_AttendancePopup> createState() => _AttendancePopupState();
}

class _AttendancePopupState extends State<_AttendancePopup>
    with TickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final AnimationController _floatCtrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _dxAnim;
  late final Animation<double> _dyAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );
    _dxAnim = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
    _dyAnim = Tween<double>(begin: 6.0, end: -6.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double s = MediaQuery.of(context).size.width / 390;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: 265 * s,
        height: 307 * s,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 팝업 컨테이너
            Container(
              width: 265 * s,
              height: 307 * s,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15 * s),
              ),
              child: Column(
                children: [
                  // 주요 콘텐츠: 세로 균등 배치
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 1일차 + 출석 완료!
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${widget.day}일차',
                              style: GoogleFonts.inter(
                                fontSize: 20 * s,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF272727),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 3 * s),
                            Text(
                              '출석 완료!',
                              style: GoogleFonts.inter(
                                fontSize: 20 * s,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF272727),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        // 로켓 애니메이션: scale 0.85↔1.0 + 대각선 float ±6px
                        AnimatedBuilder(
                          animation: Listenable.merge([_scaleCtrl, _floatCtrl]),
                          builder: (context, child) => Transform.translate(
                            offset: Offset(_dxAnim.value * s, _dyAnim.value * s),
                            child: Transform.scale(
                              scale: _scaleAnim.value,
                              child: child,
                            ),
                          ),
                          child: Image.asset(
                            'assets/출석 rocket.png',
                            width: 74 * s,
                            height: 97 * s,
                          ),
                        ),
                        // 10P 획득! + 서브텍스트
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '10P 획득!',
                              style: GoogleFonts.inter(
                                fontSize: 15 * s,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF272727),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 5 * s),
                            Text(
                              '간단한 미션하고 추가 포인트 받아가세요!',
                              style: GoogleFonts.inter(
                                fontSize: 11 * s,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF868686),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 미션 보러가기 버튼: 하단 20px 위 고정
                  Padding(
                    padding: EdgeInsets.only(bottom: 20 * s),
                    child: Container(
                      width: 209 * s,
                      height: 41 * s,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D6CEB),
                        borderRadius: BorderRadius.circular(10 * s),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '미션 보러가기',
                        style: GoogleFonts.inter(
                          fontSize: 13 * s,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // X 버튼 (우측 상단)
            Positioned(
              top: 10 * s,
              right: 10 * s,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 24 * s,
                  height: 24 * s,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(5 * s),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'X',
                    style: GoogleFonts.inter(
                      fontSize: 13 * s,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF515050),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
