// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

/// 전역 RouteObserver — main.dart의 MaterialApp.navigatorObservers에 등록
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

/// PWA 상태바 theme-color 메타 태그를 동적으로 변경
void setThemeColor(String color) {
  final meta = html.document.querySelector('meta[name="theme-color"]');
  meta?.setAttribute('content', color);
}

/// 각 페이지 Scaffold를 감싸는 wrapper
/// 진입(didPush) / 복귀(didPopNext) 시 theme-color를 [color]로 변경
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
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
