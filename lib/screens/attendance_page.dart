import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme_color.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool _notificationOn = true;
  bool _checkedIn = false;

  bool _isExpanded = true;

  late final ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (mounted) setState(() => _scrollOffset = _scrollController.offset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 달력 컬럼 positions (card-relative, card left=10)
  // 기준: row2 절대값 [38,88,140,187,238,287,338] - 10
  static const List<double> _colPositions = [28, 78, 130, 177, 228, 277, 328];
  static const List<String> _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  static const List<int> _itemLefts = [
    36, 105, 174, 243, 312, 381, 450, 519, 588, 657,
    726, 795, 864, 933, 1002, 1071, 1140, 1209, 1278, 1347,
    1416, 1485, 1554, 1623, 1692, 1761, 1830, 1899, 1968, 2037,
  ];
  static const Map<int, String> _bonusPoints = {
    3: '50P', 7: '100P', 10: '150P', 14: '200P',
    17: '220P', 20: '250P', 25: '350P',
  };
  static const Set<int> _starDays = {3, 7, 10, 14, 17, 20, 25};

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double s = MediaQuery.of(context).size.width / 390;

    final now = DateTime.now();
    final int year = now.year;
    final int month = now.month;
    final int daysInMonth = DateTime(year, month + 1, 0).day;
    final int startCol = DateTime(year, month, 1).weekday % 7;
    final int numRows = (startCol + daysInMonth + 6) ~/ 7;

    // 달력 카드 높이: 5행 기준 376, 행 추가 시 47씩
    final double calCardHeight = 124.0 + numRows * 47.0 + 16.0;

    // scroll-relative 좌표
    // 순서: my_header2(69) →[5px]→ 보너스카드(226) →[15px]→ 달력카드 →[24px]→ 채굴카드
    const double headerH = 69.0;
    const double bonusCardTop = headerH + 5.0;          // 74
    final double calCardTop = bonusCardTop + 226.0 + 15.0; // 315
    final double miningCardTop = calCardTop + calCardHeight + 24.0;
    final double contentHeight = miningCardTop + 234.0 + 20.0;

    // ── sticky my_header2 계산 ──────────────────────────────────────
    // my_header2 하단(69)에 달력 카드 하단이 닿는 순간부터 함께 슬라이드 아웃
    final double pinnedUntil = calCardTop + calCardHeight - headerH;
    final double scrollDesign = s > 0 ? _scrollOffset / s : 0;
    final double overlapAmount = scrollDesign - pinnedUntil; // 0 = 겹치기 시작, headerH = 완전히 사라짐
    final bool showPinnedHeader = _scrollOffset > 0 && overlapAmount < headerH;
    // slideOffset: 0 → 완전히 보임, -(headerH*s) → 완전히 사라짐
    final double slideOffset = overlapAmount > 0 ? (-overlapAmount * s) : 0.0;

    return ThemeColorScope(
      color: '#F4F8FF',
      child: Scaffold(
        backgroundColor: const Color(0xFFFEFEFF),
        body: Column(
          children: [
            _buildHeader(context, topPadding, s),
          Expanded(
            child: ClipRect(
              child: Stack(
                children: [
                  // 스크롤 콘텐츠
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: SizedBox(
                      height: contentHeight * s,
                      child: Stack(
                        children: [
                          // 상단 #FFFFFF 배경: 보너스카드 + 달력카드까지 커버
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(height: (calCardTop + calCardHeight) * s, color: Colors.white),
                          ),
                          // my_header2: 고정 중엔 spacer, 최상단일 땐 실제 위젯
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: showPinnedHeader
                                ? SizedBox(height: headerH * s)
                                : _buildMyHeader2(s),
                          ),
                          // 출석 보너스 달성 현황: my_header2 하단 5px 아래
                          Positioned(
                            top: bonusCardTop * s,
                            left: 10 * s,
                            child: _buildBonusCard(s),
                          ),
                          // 달력 카드: 보너스카드 하단 15px 아래
                          Positioned(
                            top: calCardTop * s,
                            left: 10 * s,
                            child: _buildCalendarCard(s, year, month, daysInMonth, startCol, calCardHeight),
                          ),
                          // 포인트 채굴
                          Positioned(
                            top: miningCardTop * s,
                            left: 10 * s,
                            child: _buildMiningCard(s),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 고정 오버레이: 달력 카드 하단이 my_header2 하단에 닿으면 함께 슬라이드 아웃
                  if (showPinnedHeader)
                    Positioned(
                      top: slideOffset,
                      left: 0,
                      right: 0,
                      child: _buildMyHeader2(s),
                    ),
                ],
              ),
            ),
          ),
          _buildFixedPointsSection(s, month),
        ],
        ),
      ),
    );
  }

  // ── 헤더 (DI 그라데이션 + 헤더바) ────────────────────────────────

  Widget _buildHeader(BuildContext context, double topPadding, double s) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // DI 영역: linear-gradient(180deg, #CFE1FF -17.8%, #F4F8FF 100%)
        Container(
          height: topPadding,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFCFE1FF), Color(0xFFF4F8FF)],
            ),
          ),
        ),
        // 헤더바: #F4F8FF
        Container(
          height: 56 * s,
          color: const Color(0xFFF4F8FF),
          child: Stack(
            children: [
              Positioned(
                left: 15 * s,
                top: 16 * s,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset('assets/arrow_back.png', width: 25 * s, height: 25 * s),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 18 * s,
                child: Text(
                  '출석체크',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16 * s,
                    fontWeight: FontWeight.w700,
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

  // ── my_header2 (신규) ─────────────────────────────────────────────
  // absolute top 115, height 69 → scroll-relative top 0

  Widget _buildMyHeader2(double s) {
    return Container(
      height: 69 * s,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF4F8FF), Colors.white],
          stops: [0.0, 0.7115],
        ),
      ),
      child: Stack(
        children: [
          // "매일 출석하고 보너스 포인트 받으세요!": top 122-115=7, left 15
          Positioned(
            top: 7 * s,
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
          // "0" 출석 일수: top 144-115=29, left 19
          Positioned(
            top: 29 * s,
            left: 19 * s,
            child: Text(
              '0',
              style: GoogleFonts.inter(
                fontSize: 25 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF272727),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // "일째 출석중": top 155-115=40, left 39
          Positioned(
            top: 40 * s,
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
          // "출석체크 알림받기": top 158-115=43, left 255
          Positioned(
            top: 43 * s,
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
          // 토글: top 156-115=41, left 344, width 36, height 18
          Positioned(
            top: 41 * s,
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

  // ── 달력 카드 ─────────────────────────────────────────────────────
  // absolute: left 10, top 187, width 370

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

    return Container(
      width: 370 * s,
      height: cardHeight * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30 * s),
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
          // 요일 헤더: top 278-187=91
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

  // ── 출석 보너스 달성 현황 ──────────────────────────────────────────
  // absolute: left 10, top 575, width 370, height 226

  Widget _buildBonusCard(double s) {
    return Container(
      width: 370 * s,
      height: 226 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30 * s),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(87, 87, 87, 0.25),
            blurRadius: 3,
            spreadRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30 * s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(17 * s, 22 * s, 17 * s, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '출석 보너스 달성 현황',
                    style: GoogleFonts.inter(
                      fontSize: 15 * s,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF272727),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 5 * s),
                  Text(
                    '출석 횟수가 쌓일수록 더 큰 보너스를 받아요',
                    style: GoogleFonts.inter(
                      fontSize: 11 * s,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6C6C6C),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10 * s),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: SizedBox(
                  width: 2102 * s,
                  child: Stack(children: _buildBonusStackChildren(s)),
                ),
              ),
            ),
            SizedBox(height: 10 * s),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBonusStackChildren(double s) {
    const double speechTop = 4;
    const double circTop = 46;
    const double connY = 66;
    const double lblTop = 91;
    const double latePtTop = 111;

    final List<Widget> children = [];

    for (int i = 0; i < 30; i++) {
      final int day = i + 1;
      final double left = _itemLefts[i].toDouble();
      final bool isStar = _starDays.contains(day);
      final String? point = _bonusPoints[day];
      final bool isLate = day >= 26;

      if (point != null) {
        children.add(Positioned(
          left: left * s,
          top: speechTop * s,
          child: _buildSpeechBubble(s, point),
        ));
      }

      children.add(Positioned(
        left: left * s,
        top: circTop * s,
        child: Container(
          width: 41 * s,
          height: 41 * s,
          decoration: const BoxDecoration(
            color: Color(0xFFE6E6E6),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: isStar
              ? Icon(Icons.star, size: 20 * s, color: Colors.white)
              : Icon(Icons.check, size: 14 * s, color: Colors.white),
        ),
      ));

      if (i < 29) {
        children.add(Positioned(
          left: (left + 42) * s,
          top: connY * s,
          child: Container(width: 26 * s, height: 2, color: const Color(0xFFE6E6E6)),
        ));
      }

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

      if (isLate) {
        children.add(Positioned(
          left: left * s,
          top: latePtTop * s,
          width: 41 * s,
          child: Text(
            '100P',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12 * s,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF2D6CEB),
              decoration: TextDecoration.none,
            ),
          ),
        ));
      }
    }

    return children;
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

  // ── 포인트 채굴 ───────────────────────────────────────────────────
  // absolute: left 10, top 825, width 370, height 226
  // card-internal = absolute - 825 (top), absolute_left - 10 (left)

  Widget _buildMiningCard(double s) {
    return Container(
      width: 370 * s,
      height: 234 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * s),
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
          // 포인트 채굴하기: 846-825=21, left 27-10=17
          Positioned(
            top: 21 * s,
            left: 17 * s,
            child: Text(
              '포인트 채굴하기',
              style: GoogleFonts.inter(
                fontSize: 15 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF272727),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // Mission 1: write.png (877-825=52), 게시글 (880-825=55), 50P (305-10=295)
          Positioned(
            top: 52 * s,
            left: 27 * s,
            child: Image.asset('assets/write.png', width: 22 * s, height: 22 * s),
          ),
          Positioned(
            top: 55 * s,
            left: 57 * s,
            child: Text(
              '게시글 1회 작성하기',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
            top: 55 * s,
            left: 295 * s,
            child: Text(
              '50P',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D6CEB),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // Mission 2: comment.png (916-825=91), 댓글 (919-825=94), 50P
          Positioned(
            top: 91 * s,
            left: 27 * s,
            child: Image.asset('assets/comment.png', width: 22 * s, height: 22 * s),
          ),
          Positioned(
            top: 94 * s,
            left: 57 * s,
            child: Text(
              '댓글 5회 작성하기',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
            top: 94 * s,
            left: 295 * s,
            child: Text(
              '50P',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D6CEB),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // Mission 3: chart.png (955-825=130), 투자정보 (958-825=133), 100P
          Positioned(
            top: 130 * s,
            left: 27 * s,
            child: Image.asset('assets/chart.png', width: 22 * s, height: 22 * s),
          ),
          Positioned(
            top: 133 * s,
            left: 57 * s,
            child: Text(
              '투자정보 페이지 방문하기',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
            top: 133 * s,
            left: 295 * s,
            child: Text(
              '100P',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D6CEB),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 전체보기 버튼: 1000-825=175, left 37-10=27, width 315, height 40
          Positioned(
            top: 175 * s,
            left: 27 * s,
            child: Container(
              width: 315 * s,
              height: 40 * s,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(10 * s),
              ),
              alignment: Alignment.center,
              child: Text(
                '전체보기',
                style: GoogleFonts.inter(
                  fontSize: 12 * s,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4D4D4D),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 출석포인트 하단 고정 ──────────────────────────────────────────

  Widget _buildFixedPointsSection(double s, int month) {
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

        // ② 패널: AnimatedAlign(heightFactor)로 클립 애니메이션, 내부는 개별 요소 Column
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
                // ③ 포인트 현황 행 (top 13 기준)
                SizedBox(height: 13 * s),
                SizedBox(
                  height: 32 * s,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 타이틀: left 22, top 19 (→ 행 기준 top 6)
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
                      // "0": left 248, top 13 (→ 행 기준 top 0)
                      Text(
                        '0',
                        style: GoogleFonts.inter(
                          fontSize: 27 * s,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D6CEB),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      // "/ 2,000P": left 275, top 16 (→ 행 기준 top 3)
                      Padding(
                        padding: EdgeInsets.only(top: 3 * s),
                        child: Text(
                          '/ 2,000P',
                          style: GoogleFonts.inter(
                            fontSize: 21 * s,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4B4B4B),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ④ 진행 바: top 52 → 간격 (52 - 13 - 32) = 7
                SizedBox(height: 7 * s),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 19 * s),
                  child: Container(
                    height: 9 * s,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20 * s),
                        topRight: Radius.circular(20 * s),
                        bottomLeft: Radius.circular(10 * s),
                        bottomRight: Radius.circular(10 * s),
                      ),
                    ),
                  ),
                ),

                // ⑤ 출석하고 포인트 받기 버튼: top 82 → 간격 (82 - 52 - 9) = 21
                SizedBox(height: 21 * s),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15 * s),
                  child: GestureDetector(
                    onTap: _checkedIn ? null : () => setState(() => _checkedIn = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: 41 * s,
                      decoration: BoxDecoration(
                        color: _checkedIn
                            ? const Color(0xFF838383)
                            : const Color(0xFF2D6CEB),
                        borderRadius: BorderRadius.circular(10 * s),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _checkedIn ? '출석완료' : '출석하고 포인트 받기',
                        style: GoogleFonts.inter(
                          fontSize: 13 * s,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),

                // 하단 여백: 133 - (13+32+7+9+21+41) = 10
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
  const _ChevronPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFA6A6A6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    // Arrow 3: 상단 ∨
    final double h1 = size.height * 4 / 9;
    canvas.drawLine(Offset(0, 0), Offset(cx, h1), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(cx, h1), paint);
    // Arrow 4: 하단 ∨ (Arrow 3 기준 5px 아래)
    final double y2 = size.height * 5 / 9;
    canvas.drawLine(Offset(0, y2), Offset(cx, size.height), paint);
    canvas.drawLine(Offset(size.width, y2), Offset(cx, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
