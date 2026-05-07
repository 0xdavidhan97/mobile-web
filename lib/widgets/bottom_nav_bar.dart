// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// CSS body { padding-bottom: env(safe-area-inset-bottom) }의 계산값을 읽어 반환.
/// Flutter Web이 MediaQuery.padding.bottom을 0으로 반환할 때 fallback으로 사용.
double _cssSafeAreaBottom() {
  try {
    final raw = html.window
        .getComputedStyle(html.document.body!)
        .paddingBottom
        .trim(); // e.g., "34px" or "0px"
    return double.tryParse(raw.replaceAll('px', '')) ?? 0;
  } catch (_) {
    return 0;
  }
}

class BottomNavBar extends StatelessWidget {
  final int activeIndex;

  const BottomNavBar({super.key, this.activeIndex = -1});

  @override
  Widget build(BuildContext context) {
    final double flutterBottom = MediaQuery.of(context).padding.bottom;
    // Flutter가 safe area를 읽지 못하면(0) CSS env() 계산값으로 fallback
    final double bottomPadding =
        (flutterBottom > 0 || !kIsWeb) ? flutterBottom : _cssSafeAreaBottom();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

    final assets = [
      ('assets/home.png', 25.0),
      ('assets/community.png', 24.0),
      ('assets/space.png', 25.0),
      ('assets/clock.png', 25.0),
      ('assets/invest.png', 25.0),
    ];

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 52 * s,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < assets.length; i++)
                  Opacity(
                    opacity: activeIndex == i ? 1.0 : 0.4,
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        assets[i].$1,
                        width: assets[i].$2 * s,
                        height: assets[i].$2 * s,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
