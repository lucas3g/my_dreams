import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/modules/dream/domain/entities/dream_entity.dart';
import 'package:my_dreams/modules/dream/presentation/widgets/chat_message_widget.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';

class DreamCardWidget extends StatelessWidget {
  final DreamEntity dream;

  const DreamCardWidget({super.key, required this.dream});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.myTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppThemeConstants.mediumBorderRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChatMessageWidget(
              message: ChatMessage(text: dream.message.value, isUser: true),
            ),
            const SizedBox(height: 8),
            ChatMessageWidget(
              message: ChatMessage(
                text: dream.answer.value,
                isUser: false,
                imageUrl: dream.imageUrl.value.isNotEmpty
                    ? dream.imageUrl.value
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
