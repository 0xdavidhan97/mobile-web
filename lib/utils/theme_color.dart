import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// 전역 RouteObserver — main.dart의 MaterialApp.navigatorObservers에 등록
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

/// PWA 상태바 theme-color 메타 태그를 동적으로 변경
void setThemeColor(String color) {
  if (!kIsWeb) return;
  try {
    final doc = globalContext['document'];
    if (doc == null) return;
    final meta = (doc as JSObject).callMethod<JSObject?>(
      'querySelector'.toJS,
      'meta[name="theme-color"]'.toJS,
    );
    meta?.callMethod<void>('setAttribute'.toJS, 'content'.toJS, color.toJS);
  } catch (_) {}
}

/// 각 페이지 Scaffold를 감싸는 wrapper
/// 마운트(didChangeDependencies) / 진입(didPush) / 복귀(didPopNext) 시
/// theme-color를 [color]로 변경
class ThemeColorScope extends StatefulWidget {
  final String color;
  final Widget child;

  const ThemeColorScope({
    super.key,
    required this.color,
    required this.child,
  });

  @override
  State<ThemeColorScope> createState() => _ThemeColorScopeState();
}

class _ThemeColorScopeState extends State<ThemeColorScope> with RouteAware {
  bool _subscribed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
      // 초기 마운트 시 바로 적용 (didPush보다 먼저 첫 프레임에 실행)
      if (!_subscribed) {
        _subscribed = true;
        setThemeColor(widget.color);
      }
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// 이 페이지가 push되어 최상단이 됐을 때
  @override
  void didPush() => setThemeColor(widget.color);

  /// 위 페이지가 pop되어 이 페이지가 다시 최상단이 됐을 때
  @override
  void didPopNext() => setThemeColor(widget.color);

  @override
  Widget build(BuildContext context) => widget.child;
}
