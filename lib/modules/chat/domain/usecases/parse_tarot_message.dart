import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/app_language.dart';
import 'package:my_dreams/modules/chat/domain/entities/tarot_card_entity.dart';

@injectable
class ParseTarotMessageUseCase {
  List<TarotCardEntity> call(String text) {
    final language = AppLanguage.fromString(
      PlatformDispatcher.instance.locale.toString(),
    );

    RegExp regex;

    if (language == AppLanguage.english) {
      regex = RegExp(
        r'(Card\s*[1-5])\s*[:\-–—]\s*([\s\S]*?)(?=\s*Card\s*[1-5]\s*[:\-–—]|$)',
        caseSensitive: false,
        dotAll: true,
        multiLine: true,
      );
    } else {
      regex = RegExp(
        r'(Carta\s*[1-5])\s*[:\-–—]\s*([\s\S]*?)(?=\s*Carta\s*[1-5]\s*[:\-–—]|$)',
        caseSensitive: false,
        dotAll: true,
        multiLine: true,
      );
    }

    return regex.allMatches(text).map((match) {
      final title = match.group(1)!.trim();
      final description = match.group(2)!.trim();
      return TarotCardEntity(title: title, description: description);
    }).toList();
  }
}
