import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/modules/dream/domain/entities/dream_entity.dart';
import 'package:my_dreams/modules/dream/presentation/widgets/chat_message_widget.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/utils/formatters.dart';

class DreamCardWidget extends StatelessWidget {
  final DreamEntity dream;

  const DreamCardWidget({super.key, required this.dream});

  @override
  Widget build(BuildContext context) {
    final borderColor = context.myTheme.outline;

    return Card(
      color: context.myTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppThemeConstants.mediumBorderRadius,
        ),
        side: BorderSide(color: borderColor),
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
            if (dream.createdAt != null)
              Padding(
                padding:
                    const EdgeInsets.only(top: AppThemeConstants.halfPadding),
                child: Text(
                  dream.createdAt!.value.diaMesAnoHora(),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.myTheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
