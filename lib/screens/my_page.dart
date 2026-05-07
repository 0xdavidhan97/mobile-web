import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/my_header.dart';
import '../widgets/bottom_nav_bar.dart';
import 'attendance_page.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double s = MediaQuery.of(context).size.width / 390;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const MyHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: 917 * s,
                child: Stack(
                  children: [
                    // top_banner.png: top 6, left 18
                    Positioned(
                      top: 6 * s,
                      left: 18 * s,
                      child: Image.asset(
                        'assets/top_banner.png',
                        width: 353 * s,
                        height: 113 * s,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 코박 툴박스 text
                    Positioned(
                      top: 34 * s,
                      left: 39 * s,
                      child: Text(
                        '코박 툴박스',
                        style: GoogleFonts.inter(
                          fontSize: 13 * s,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    // subtitle
                    Positioned(
                      top: 58 * s,
                      left: 39 * s,
                      child: SizedBox(
                        width: 97 * s,
                        child: Text(
                          '코박의 새로운 기능을 테스트 해보세요!',
                          style: GoogleFonts.inter(
                            fontSize: 11 * s,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFE0E0E0),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    // 바로가기 카드: top 137, left 18
                    Positioned(
                      top: 137 * s,
                      left: 18 * s,
                      child: _ShortcutCard(s: s),
                    ),
                    // 프로필 카드: top 245, left 18
                    Positioned(
                      top: 245 * s,
                      left: 18 * s,
                      child: _ProfileCard(s: s),
                    ),
                    // 간단정보 카드: top 462, left 18
                    Positioned(
                      top: 462 * s,
                      left: 18 * s,
                      child: _SimpleInfoCard(s: s),
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
}

class _ShortcutCard extends StatelessWidget {
  final double s;
  const _ShortcutCard({required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 353 * s,
      height: 93 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDF0F5), width: 1.5),
        borderRadius: BorderRadius.circular(20 * s),
      ),
      child: Stack(
        children: [
          // space2.png: top 21, left 47
          Positioned(
            top: 21 * s,
            left: 47 * s,
            child: Image.asset('assets/space2.png', width: 28 * s, height: 28 * s),
          ),
          // moneybag.png: top 20, left 124
          Positioned(
            top: 20 * s,
            left: 124 * s,
            child: Image.asset('assets/moneybag.png', width: 30 * s, height: 30 * s),
          ),
          // 출석체크 (stamp2 + label, tappable): top 21, left 197
          Positioned(
            top: 21 * s,
            left: 197 * s,
            child: _AttendanceButton(s: s),
          ),
          // wallet2.png: top 21, left 289
          Positioned(
            top: 21 * s,
            left: 289 * s,
            child: Image.asset('assets/wallet2.png', width: 30 * s, height: 30 * s),
          ),
          // 내 스페이스 label: top 61, left 31
          Positioned(
            top: 61 * s,
            left: 31 * s,
            child: Text(
              '내 스페이스',
              style: GoogleFonts.inter(
                fontSize: 12 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6D6D6D),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 미션 label: top 61, left 127
          Positioned(
            top: 61 * s,
            left: 127 * s,
            child: Text(
              '미션',
              style: GoogleFonts.inter(
                fontSize: 12 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6D6D6D),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 내 지갑 label: top 61, left 285
          Positioned(
            top: 61 * s,
            left: 285 * s,
            child: Text(
              '내 지갑',
              style: GoogleFonts.inter(
                fontSize: 12 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6D6D6D),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final double s;
  const _ProfileCard({required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 353 * s,
      height: 202 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDF0F5), width: 1.5),
        borderRadius: BorderRadius.circular(20 * s),
      ),
      child: Stack(
        children: [
          // profile.png: top 19, left 21
          Positioned(
            top: 19 * s,
            left: 21 * s,
            child: Image.asset('assets/profile.png', width: 34 * s, height: 34 * s),
          ),
          // 어서헤어져: top 19, left 67
          Positioned(
            top: 19 * s,
            left: 67 * s,
            child: Text(
              '어서헤어져',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF272727),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 팔로워/팔로잉: top 40, left 67
          Positioned(
            top: 40 * s,
            left: 67 * s,
            child: Text(
              '팔로워 4  팔로잉 6',
              style: GoogleFonts.inter(
                fontSize: 11 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 내 지갑 label: top 79, left 21
          Positioned(
            top: 79 * s,
            left: 21 * s,
            child: Text(
              '내 지갑',
              style: GoogleFonts.inter(
                fontSize: 12 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 지갑 연결 버튼: top 79, left 262, 77×37
          Positioned(
            top: 79 * s,
            left: 262 * s,
            child: Container(
              width: 77 * s,
              height: 37 * s,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF2C76E1),
                borderRadius: BorderRadius.circular(10 * s),
              ),
              child: Text(
                '지갑 연결',
                style: GoogleFonts.inter(
                  fontSize: 13 * s,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          // 25,500원: top 106, left 26
          Positioned(
            top: 106 * s,
            left: 26 * s,
            child: Text(
              '25,500원',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // KRW: top 109, left 88
          Positioned(
            top: 109 * s,
            left: 88 * s,
            child: Text(
              'KRW',
              style: GoogleFonts.inter(
                fontSize: 10 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // down triangle: top 110, left 113
          Positioned(
            top: 110 * s,
            left: 113 * s,
            child: SizedBox(
              width: 9 * s,
              height: 9 * s,
              child: CustomPaint(
                painter: _DownTrianglePainter(color: const Color(0xFF838383)),
              ),
            ),
          ),
          // 자세히보기: top 158, left 140
          Positioned(
            top: 158 * s,
            left: 140 * s,
            child: Text(
              '자세히보기',
              style: GoogleFonts.inter(
                fontSize: 12 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // image2824 (화살표 rotate 90deg): top 163, left 201
          Positioned(
            top: 163 * s,
            left: 201 * s,
            child: Transform.rotate(
              angle: math.pi / 2,
              child: Image.asset('assets/image2824.png', width: 12 * s, height: 12 * s),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleInfoCard extends StatelessWidget {
  final double s;
  const _SimpleInfoCard({required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 353 * s,
      height: 435 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDF0F5), width: 1.5),
        borderRadius: BorderRadius.circular(20 * s),
      ),
      child: Stack(
        children: [
          // 내 간단 정보: top 27, left 21
          Positioned(
            top: 27 * s,
            left: 21 * s,
            child: Text(
              '내 간단 정보',
              style: GoogleFonts.inter(
                fontSize: 15 * s,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF272727),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // Ellipse7 (포인트 배지): top 70, left 21, size 16
          Positioned(
            top: 70 * s,
            left: 21 * s,
            child: Container(
              width: 16 * s,
              height: 16 * s,
              decoration: const BoxDecoration(
                color: Color(0xFF155BE3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // P (italic): top 72, left 26
          Positioned(
            top: 72 * s,
            left: 26 * s,
            child: Text(
              'P',
              style: GoogleFonts.inter(
                fontSize: 10 * s,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 57,100P: top 66, left 44
          Positioned(
            top: 66 * s,
            left: 44 * s,
            child: Text(
              '57,100P',
              style: GoogleFonts.inter(
                fontSize: 20 * s,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.02 * 20 * s,
                color: const Color(0xFF272727),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 포인트 보기: top 96, left 258
          Positioned(
            top: 96 * s,
            left: 258 * s,
            child: Text(
              '포인트 보기',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C6C6C),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // Ellipse8 (blue dot): top 136, left 21, size 7
          Positioned(
            top: 136 * s,
            left: 21 * s,
            child: Container(
              width: 7 * s,
              height: 7 * s,
              decoration: const BoxDecoration(
                color: Color(0xFF2C6CEB),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Ellipse9 (green dot): top 172, left 21, size 7
          Positioned(
            top: 172 * s,
            left: 21 * s,
            child: Container(
              width: 7 * s,
              height: 7 * s,
              decoration: const BoxDecoration(
                color: Color(0xFF27A22F),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Ellipse10 (orange dot): top 206, left 21, size 7
          Positioned(
            top: 206 * s,
            left: 21 * s,
            child: Container(
              width: 7 * s,
              height: 7 * s,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6E01),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 오늘 얻은 포인트: top 132, left 35
          Positioned(
            top: 132 * s,
            left: 35 * s,
            child: Text(
              '오늘 얻은 포인트 : 50 P',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2C6CEB),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 남은 포인트: top 167, left 35
          Positioned(
            top: 167 * s,
            left: 35 * s,
            child: Text(
              '남은 포인트 : 125 P',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF27A22F),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // 추가 보상: top 202, left 35
          Positioned(
            top: 202 * s,
            left: 35 * s,
            child: Text(
              '추가 보상 : 0 P',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFFF6E01),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // Rectangle 1399 (포인트 바 배경 - green): top 247, left 28, 298×58
          Positioned(
            top: 247 * s,
            left: 28 * s,
            child: Container(
              width: 298 * s,
              height: 58 * s,
              decoration: BoxDecoration(
                color: const Color(0xFF76C976),
                borderRadius: BorderRadius.circular(10 * s),
              ),
            ),
          ),
          // Rectangle 1400 (포인트 바 채워진 - blue): top 247, left 28, 88×58
          Positioned(
            top: 247 * s,
            left: 28 * s,
            child: Container(
              width: 88 * s,
              height: 58 * s,
              decoration: BoxDecoration(
                color: const Color(0xFF1D61E6),
                borderRadius: BorderRadius.circular(10 * s),
              ),
            ),
          ),
          // 50 P: top 268, left 44
          Positioned(
            top: 268 * s,
            left: 44 * s,
            child: Text(
              '50 P',
              style: GoogleFonts.inter(
                fontSize: 13 * s,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceButton extends StatefulWidget {
  final double s;
  const _AttendanceButton({required this.s});

  @override
  State<_AttendanceButton> createState() => _AttendanceButtonState();
}

class _AttendanceButtonState extends State<_AttendanceButton> {
  bool _tapped = false;

  @override
  Widget build(BuildContext context) {
    final double s = widget.s;
    return GestureDetector(
      onTapDown: (_) => setState(() => _tapped = true),
      onTapUp: (_) => setState(() => _tapped = false),
      onTapCancel: () => setState(() => _tapped = false),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AttendancePage()),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(
            opacity: _tapped ? 0.5 : 1.0,
            child: Image.asset('assets/stamp2.png', width: 27 * s, height: 27 * s),
          ),
          SizedBox(height: 13 * s),
          Text(
            '출석체크',
            style: GoogleFonts.inter(
              fontSize: 12 * s,
              fontWeight: FontWeight.w600,
              color: _tapped ? const Color(0xFFA2A2A2) : const Color(0xFF6D6D6D),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

class _DownTrianglePainter extends CustomPainter {
  final Color color;
  const _DownTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
