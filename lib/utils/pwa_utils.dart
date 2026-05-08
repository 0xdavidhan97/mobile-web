import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart' show kIsWeb;

/// CSS body { padding-top: env(safe-area-inset-top) }의 계산값을 읽어 반환.
/// Flutter Web이 MediaQuery.padding.top을 0으로 반환할 때 fallback으로 사용.
double cssSafeAreaTop() {
  if (!kIsWeb) return 0;
  try {
    final doc = globalContext['document'];
    if (doc == null) return 0;
    final body = (doc as JSObject)['body'];
    if (body == null) return 0;
    final style = globalContext.callMethod<JSObject>('getComputedStyle'.toJS, body);
    final pt = style['paddingTop'];
    if (pt == null) return 0;
    final raw = (pt as JSString).toDart.trim();
    return double.tryParse(raw.replaceAll('px', '')) ?? 0;
  } catch (_) {
    return 0;
  }
}

/// PWA 환경(display-mode: standalone 또는 iOS Safari standalone) 여부 반환.
bool isPwa() {
  if (!kIsWeb) return false;
  try {
    final mq = globalContext.callMethod<JSObject>(
      'matchMedia'.toJS,
      '(display-mode: standalone)'.toJS,
    );
    final mqMatches = mq['matches'];
    if (mqMatches is JSBoolean && (mqMatches as JSBoolean).toDart) return true;
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
