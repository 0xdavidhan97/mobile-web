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

  bool _isExpanded = true;

  // 달력 컬럼 positions (card-relative, card left=0, width=390)
  static const List<double> _colPositions = [38, 88, 139, 189, 240, 290, 341];
  static const List<String> _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

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

    // scroll-relative 좌표
    // my_header2(70) →[20px]→ 보너스카드(135) →[25px]→ 달력카드
    const double bonusCardTop = 90.0;
    const double calCardTop = 250.0;
    final double contentHeight = calCardTop + calCardHeight + 20.0;

    return ThemeColorScope(
      color: '#F4F8FF',
      child: Scaffold(
        backgroundColor: const Color(0xFFFEFEFF),
        body: Column(
          children: [
            _buildHeader(context, topPadding, s),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
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
                    ],
                  ),
                ),
              ),
            ),
            _buildFixedPointsSection(s, month),
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
        // 헤더바: 46px, #F4F8FF
        Container(
          height: 46 * s,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF4F8FF), Color(0xFFF4F8FF)],
            ),
          ),
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
              '0',
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
    };
    const Set<int> starDays = {3, 7, 10, 14, 17, 20, 25};

    // 카드 내부 수직 레이아웃 (card height 135px 기준)
    const double speechTop = 4;   // 말풍선 top (36px container + 6px tail → bottom 46)
    const double circTop   = 50;  // 원 top (height 41 → bottom 91, center 70.5)
    const double connY     = 70;  // 연결선 top (원 수직 중앙)
    const double lblTop    = 96;  // 일차 레이블 top
    const double latePtTop = 111; // 26~30일차 포인트 top

    final List<Widget> children = [];

    for (int i = 0; i < 30; i++) {
      final int day = i + 1;
      final double left = itemLefts[i];
      final bool isStar = starDays.contains(day);
      final String? point = bonusPoints[day];
      final bool isLate = day >= 26;

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

      // 26~30일차 100P 포인트
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

  // ── 출석포인트 하단 고정 (기존 유지) ─────────────────────────────────

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
                        '0',
                        style: GoogleFonts.inter(
                          fontSize: 27 * s,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D6CEB),
                          decoration: TextDecoration.none,
                        ),
                      ),
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
