import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// CSS body { padding-bottom: env(safe-area-inset-bottom) }의 계산값을 읽어 반환.
/// Flutter Web이 MediaQuery.padding.bottom을 0으로 반환할 때 fallback으로 사용.
double _cssSafeAreaBottom() {
  try {
    final doc = globalContext['document'];
    if (doc == null) return 0;
    final body = (doc as JSObject)['body'];
    if (body == null) return 0;
    final style = globalContext.callMethod<JSObject>('getComputedStyle'.toJS, body);
    final pb = style['paddingBottom'];
    if (pb == null) return 0;
    final raw = (pb as JSString).toDart.trim();
    return double.tryParse(raw.replaceAll('px', '')) ?? 0;
  } catch (_) {
    return 0;
  }
}

/// PWA 환경(display-mode: standalone 또는 iOS Safari standalone) 여부 반환.
bool _isPwa() {
  if (!kIsWeb) return false;
  try {
    // Android PWA / 크롬 등 display-mode: standalone
    final mq = globalContext.callMethod<JSObject>(
      'matchMedia'.toJS,
      '(display-mode: standalone)'.toJS,
    );
    final mqMatches = mq['matches'];
    if (mqMatches is JSBoolean && (mqMatches as JSBoolean).toDart) return true;
    // iOS Safari 홈 화면 추가 (navigator.standalone)
    final nav = globalContext['navigator'];
    if (nav != null) {
      final standalone = (nav as JSObject)['standalone'];
      if (standalone is JSBoolean && (standalone as JSBoolean).toDart) return true;
    }
    return false;
  } catch (_) {
    return false;
  }
}

class BottomNavBar extends StatelessWidget {
  final int activeIndex;
  final bool showSwipeBar;

  const BottomNavBar({super.key, this.activeIndex = -1, this.showSwipeBar = false});

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
          // PWA 환경에서만 하단 스와이프바 표시
          if (showSwipeBar && _isPwa())
            SizedBox(
              width: 390 * s,
              height: 34 * s,
            ),
        ],
      ),
    );
  }
}
