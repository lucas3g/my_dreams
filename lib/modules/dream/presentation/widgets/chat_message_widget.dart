// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/utils/rich_text_extensions.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String? imageUrl;

  ChatMessage({required this.text, required this.isUser, this.imageUrl});
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final backgroundColor = isUser
        ? context.myTheme.primaryContainer
        : context.myTheme.secondaryContainer;
    final textColor = isUser
        ? context.myTheme.onPrimaryContainer
        : context.myTheme.onSecondaryContainer;

    final avatar = isUser
        ? Padding(
            padding: const EdgeInsets.only(top: 5),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                AppGlobal.instance.user?.imageUrl.value ?? '',
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 5),
            child: const CircleAvatar(child: Icon(Icons.android)),
          );

    final baseStyle =
        context.textTheme.bodyLarge?.copyWith(color: textColor) ??
        TextStyle(color: textColor);
    final boldStyle = baseStyle.copyWith(fontWeight: FontWeight.bold);

    final content = Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          AppThemeConstants.mediumBorderRadius,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: message.text.parseBold(
                style: baseStyle,
                boldStyle: boldStyle,
              ),
            ),
          ),
          if (message.imageUrl != null && message.imageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.network(
                message.imageUrl!,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );

    return Row(
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser) avatar,
        if (showAvatar) const SizedBox(width: 10),
        Flexible(child: content),
        if (showAvatar) const SizedBox(width: 10),
        if (isUser && showAvatar) avatar,
      ],
    );
  }
}
