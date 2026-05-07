import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_nav_bar.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool _notificationOn = true;
  bool _checkedIn = false;

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double s = MediaQuery.of(context).size.width / 390;

    final now = DateTime.now();
    final int year = now.year;
    final int month = now.month;
    final int daysInMonth = DateTime(year, month + 1, 0).day;
    // weekday: 1=Mon..6=Sat,7=Sun → col: 0=일,1=월..6=토
    final int startCol = DateTime(year, month, 1).weekday % 7;
    final int totalCells = startCol + daysInMonth;
    final int numRows = (totalCells + 6) ~/ 7;
    final bool sixRows = numRows >= 6;
    final double calCardHeight = sixRows ? 484.0 : 437.0;
    final double buttonTopInCard = sixRows ? 407.0 : 360.0;
    final double bonusCardTop = 231.0 + calCardHeight + 15.0;
    final double contentHeight = bonusCardTop + 226.0 + 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(context, topPadding, s),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: contentHeight * s,
                child: Stack(
                  children: [
                    // 매일 출석체크 알림받기 텍스트: rel top 15, left 208
                    Positioned(
                      top: 15 * s,
                      left: 208 * s,
                      child: Text(
                        '매일 출석체크 알림받기',
                        style: GoogleFonts.inter(
                          fontSize: 12 * s,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6C6C6C),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    // 토글: rel top 12, left 331
                    Positioned(
                      top: 12 * s,
                      left: 331 * s,
                      child: GestureDetector(
                        onTap: () => setState(() => _notificationOn = !_notificationOn),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 40 * s,
                          height: 22 * s,
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
                              padding: EdgeInsets.all(2 * s),
                              child: Container(
                                width: 18 * s,
                                height: 18 * s,
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
                    // 출석포인트 카드: rel top 46, left 6
                    Positioned(
                      top: 46 * s,
                      left: 6 * s,
                      child: _buildPointsCard(s, month),
                    ),
                    // 달력 카드: rel top 231, left 6
                    Positioned(
                      top: 231 * s,
                      left: 6 * s,
                      child: _buildCalendarCard(
                        s, year, month, daysInMonth, startCol,
                        calCardHeight, buttonTopInCard,
                      ),
                    ),
                    // 출석 보너스 달성 현황 카드
                    Positioned(
                      top: bonusCardTop * s,
                      left: 6 * s,
                      child: _buildBonusCard(s),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomNavBar(activeIndex: 4),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double topPadding, double s) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: topPadding),
          SizedBox(
            height: 56 * s,
            child: Stack(
              children: [
                // 뒤로가기 버튼: left 15, top 16
                Positioned(
                  left: 15 * s,
                  top: 16 * s,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/arrow_back.png',
                      width: 25 * s,
                      height: 25 * s,
                    ),
                  ),
                ),
                // 헤더 타이틀 "출석체크" 가운데 정렬
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
      ),
    );
  }

  Widget _buildPointsCard(double s, int month) {
    return Container(
      width: 378 * s,
      height: 170 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDF0F5), width: 1.5),
        borderRadius: BorderRadius.circular(30 * s),
      ),
      child: Stack(
        children: [
          // "$month월 출석 포인트": top 25, left 17
          Positioned(
            top: 25 * s,
            left: 17 * s,
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
          // "0" 현재 포인트: top 51, left 17
          Positioned(
            top: 51 * s,
            left: 17 * s,
            child: Text(
              '0',
              style: GoogleFonts.inter(
                fontSize: 25 * s,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D6CEB),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // "/ 2,000P": top 56, left 40
          Positioned(
            top: 56 * s,
            left: 40 * s,
            child: Text(
              '/ 2,000P',
              style: GoogleFonts.inter(
                fontSize: 17 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4B4B4B),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 진행 바 배경: top 88, left 11, 356×9
          Positioned(
            top: 88 * s,
            left: 11 * s,
            child: Container(
              width: 356 * s,
              height: 9 * s,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(10 * s),
              ),
            ),
          ),
          // 구분선: top 109, left 11
          Positioned(
            top: 109 * s,
            left: 11 * s,
            child: Container(
              width: 356 * s,
              height: 1.5,
              color: const Color(0xFFD9D9D9),
            ),
          ),
          // info 아이콘: top 121, left 15
          Positioned(
            top: 121 * s,
            left: 15 * s,
            child: Icon(
              Icons.info_outline,
              size: 11 * s,
              color: const Color(0xFF6C6C6C),
            ),
          ),
          // "멤버십 등급에 따라...": top 120, left 29
          Positioned(
            top: 120 * s,
            left: 29 * s,
            child: Text(
              '멤버십 등급에 따라 최대 포인트가 달라져요',
              style: GoogleFonts.inter(
                fontSize: 10 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // bolt 아이콘: top 139, left 15
          Positioned(
            top: 139 * s,
            left: 15 * s,
            child: Icon(
              Icons.bolt,
              size: 11 * s,
              color: const Color(0xFF6C6C6C),
            ),
          ),
          // "매일 출석하면...": top 138, left 29
          Positioned(
            top: 138 * s,
            left: 29 * s,
            child: Text(
              '매일 출석하면 이번 달 2,000P를 모두 받을 수 있어요',
              style: GoogleFonts.inter(
                fontSize: 10 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(
    double s,
    int year,
    int month,
    int daysInMonth,
    int startCol,
    double cardHeight,
    double buttonTop,
  ) {
    const List<String> weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    const List<double> colPositions = [32, 82, 133, 183, 234, 284, 335];

    final List<Widget> dateWidgets = [];
    for (int day = 1; day <= daysInMonth; day++) {
      final int idx = startCol + day - 1;
      final int col = idx % 7;
      final int row = idx ~/ 7;
      dateWidgets.add(
        Positioned(
          left: colPositions[col] * s,
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
      width: 378 * s,
      height: cardHeight * s,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDF0F5), width: 1.5),
        borderRadius: BorderRadius.circular(30 * s),
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
              left: colPositions[i] * s,
              child: Text(
                weekdays[i],
                style: GoogleFonts.inter(
                  fontSize: 12 * s,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9D9D9D),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          // 날짜 (동적 렌더링)
          ...dateWidgets,
          // 출석체크 버튼: left 86, width 206×48
          Positioned(
            top: buttonTop * s,
            left: 86 * s,
            child: GestureDetector(
              onTap: _checkedIn ? null : () => setState(() => _checkedIn = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 206 * s,
                height: 48 * s,
                decoration: BoxDecoration(
                  color: _checkedIn
                      ? const Color(0xFF838383)
                      : const Color(0xFF2D6CEB),
                  borderRadius: BorderRadius.circular(15 * s),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/cobak_logo.png',
                      width: 16 * s,
                      height: 16 * s,
                    ),
                    SizedBox(width: 3 * s),
                    Text(
                      _checkedIn ? '출석완료' : '출석체크',
                      style: GoogleFonts.inter(
                        fontSize: 13 * s,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 출석 보너스 달성 현황 카드 ──────────────────────────────────

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

  Widget _buildBonusCard(double s) {
    return Container(
      width: 378 * s,
      height: 226 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDF0F5), width: 1.5),
        borderRadius: BorderRadius.circular(30 * s),
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
                  child: Stack(
                    children: _buildBonusStackChildren(s),
                  ),
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
    const double speechTop = 4;   // 말풍선 top (circTop - 42)
    const double circTop = 46;    // 원 top
    const double connY = 66;      // 연결선 center Y (circTop + 20)
    const double lblTop = 91;     // 라벨 top (circTop + 41 + 4)
    const double latePtTop = 111; // 26~30일차 100P top (lblTop + 13 + 7)

    final List<Widget> children = [];

    for (int i = 0; i < 30; i++) {
      final int day = i + 1;
      final double left = _itemLefts[i].toDouble();
      final bool isStar = _starDays.contains(day);
      final String? point = _bonusPoints[day];
      final bool isLate = day >= 26;

      // 말풍선 (보너스 일차만)
      if (point != null) {
        children.add(Positioned(
          left: left * s,
          top: speechTop * s,
          child: _buildSpeechBubble(s, point),
        ));
      }

      // 원형 아이콘 (모두 #E6E6E6)
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
              ? Icon(
                  Icons.star,
                  size: 20 * s,
                  color: Colors.white,
                )
              : Icon(
                  Icons.check,
                  size: 14 * s,
                  color: Colors.white,
                ),
        ),
      ));

      // 연결선 (마지막 아이템 제외)
      if (i < 29) {
        children.add(Positioned(
          left: (left + 42) * s,
          top: connY * s,
          child: Container(
            width: 26 * s,
            height: 2,
            color: const Color(0xFFE6E6E6),
          ),
        ));
      }

      // 일차 라벨
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

      // 26~30일차 100P 텍스트
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
