import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String? imageUrl;

  ChatMessage({required this.text, required this.isUser, this.imageUrl});
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

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
          Text(
            message.text,
            style: context.textTheme.bodyLarge?.copyWith(color: textColor),
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
        const SizedBox(width: 10),
        Flexible(child: content),
        const SizedBox(width: 10),
        if (isUser) avatar,
      ],
    );
  }
}
