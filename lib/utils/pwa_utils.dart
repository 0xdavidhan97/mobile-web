import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart' show kIsWeb;

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
