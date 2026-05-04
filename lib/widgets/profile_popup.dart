import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/my_page.dart';

class ProfilePopup extends StatelessWidget {
  final VoidCallback? onClose;

  const ProfilePopup({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    final double s = MediaQuery.of(context).size.width / 390;

    return Container(
      width: 141 * s,
      height: 202 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * s),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20 * s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16 * s, 18 * s, 16 * s, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/profile.png', width: 25 * s, height: 25 * s),
                  SizedBox(width: 8 * s),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '내 프로필',
                        style: GoogleFonts.inter(
                          fontSize: 9 * s,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF096BFF),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 2 * s),
                      Text(
                        '어서헤어져',
                        style: GoogleFonts.inter(
                          fontSize: 11 * s,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF272727),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12 * s),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * s),
              child: Divider(height: 1, thickness: 1 * s, color: const Color(0xFFEEEEEE)),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MenuItem(
                    label: '마이페이지 이동',
                    color: const Color(0xFF4E4E4E),
                    s: s,
                    highlightWidth: 141 * s,
                    onTap: () {
                      onClose?.call();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyPage()),
                      );
                    },
                  ),
                  _MenuItem(label: '내 스페이스 이동', color: const Color(0xFF4E4E4E), s: s),
                  _MenuItem(label: '계정 및 보안', color: const Color(0xFF4E4E4E), s: s),
                  _MenuItem(label: '로그아웃', color: const Color(0xFFFF4E4E), s: s),
                ],
              ),
            ),
            SizedBox(height: 18 * s),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  final String label;
  final Color color;
  final double s;
  final double? highlightWidth;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.label,
    required this.color,
    required this.s,
    this.highlightWidth,
    this.onTap,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final bool highlightable = widget.highlightWidth != null;

    return MouseRegion(
      onEnter: highlightable ? (_) => setState(() => _active = true) : null,
      onExit: highlightable ? (_) => setState(() => _active = false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: highlightable ? (_) => setState(() => _active = true) : null,
        onTapUp: highlightable ? (_) => setState(() => _active = false) : null,
        onTapCancel: highlightable ? () => setState(() => _active = false) : null,
        child: Container(
          width: highlightable ? widget.highlightWidth : null,
          height: highlightable ? 26 * widget.s : null,
          color: highlightable && _active ? const Color(0xFFEBEBEB) : Colors.transparent,
          alignment: highlightable ? Alignment.centerLeft : null,
          padding: EdgeInsets.only(left: 16 * widget.s),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 12 * widget.s,
              fontWeight: FontWeight.w600,
              color: widget.color,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
