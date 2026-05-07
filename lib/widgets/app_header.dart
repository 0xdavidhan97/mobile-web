import 'package:flutter/material.dart';
import 'profile_popup.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  OverlayEntry? _overlayEntry;

  void _showPopup() {
    if (_overlayEntry != null) {
      _hidePopup();
      return;
    }

    final double topPadding = MediaQuery.of(context).padding.top;
    final double s = MediaQuery.of(context).size.width / 390;

    _overlayEntry = OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          // 외부 탭 시 닫힘 배리어
          Positioned.fill(
            child: GestureDetector(
              onTap: _hidePopup,
              behavior: HitTestBehavior.opaque,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          // 팝업 — 헤더 top 기준 47px 아래, 우측 22px
          Positioned(
            top: topPadding + 47 * s,
            right: 22 * s,
            child: Material(
              color: Colors.transparent,
              child: ProfilePopup(onClose: _hidePopup),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hidePopup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // DI 영역: 흰색 단색
        Container(
          height: topPadding,
          color: Colors.white,
        ),
        Container(
          color: Colors.white,
          child: SizedBox(
            height: 56 * s,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12 * s),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/cobak_logo.png', width: 32 * s, height: 32 * s),
                  const Spacer(),
                  Image.asset('assets/search.png', width: 21 * s, height: 21 * s),
                  SizedBox(width: 19 * s),
                  Image.asset('assets/bell.png', width: 21 * s, height: 21 * s),
                  SizedBox(width: 19 * s),
                  Image.asset('assets/robot.png', width: 21 * s, height: 21 * s),
                  SizedBox(width: 19 * s),
                  GestureDetector(
                    onTap: _showPopup,
                    child: Image.asset(
                      'assets/profile.png',
                      width: 22 * s,
                      height: 22 * s,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
