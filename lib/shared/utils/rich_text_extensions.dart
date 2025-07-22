import 'package:flutter/material.dart';

extension BoldTextParser on String {
  /// Returns a list of [TextSpan] where text wrapped with `**` is styled
  /// with [boldStyle].
  List<InlineSpan> parseBold({
    required TextStyle style,
    required TextStyle boldStyle,
  }) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    var start = 0;

    for (final match in regex.allMatches(this)) {
      if (match.start > start) {
        spans.add(TextSpan(text: substring(start, match.start), style: style));
      }
      spans.add(TextSpan(text: match.group(1), style: boldStyle));
      start = match.end;
    }

    if (start < length) {
      spans.add(TextSpan(text: substring(start), style: style));
    }

    return spans;
  }
}
