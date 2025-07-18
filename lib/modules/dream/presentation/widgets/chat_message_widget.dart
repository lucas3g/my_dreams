import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment = message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final backgroundColor = message.isUser
        ? context.myTheme.primaryContainer
        : context.myTheme.secondaryContainer;
    final textColor = message.isUser
        ? context.myTheme.onPrimaryContainer
        : context.myTheme.onSecondaryContainer;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppThemeConstants.mediumBorderRadius),
        ),
        child: Text(
          message.text,
          style: context.textTheme.bodyLarge?.copyWith(color: textColor),
        ),
      ),
    );
  }
}
