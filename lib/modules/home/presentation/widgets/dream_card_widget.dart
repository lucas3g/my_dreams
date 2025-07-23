import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/modules/dream/domain/entities/dream_entity.dart';
import 'package:my_dreams/modules/dream/presentation/widgets/chat_message_widget.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/utils/formatters.dart';
import 'package:my_dreams/shared/translate/translate.dart';

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
        side: BorderSide(color: context.myTheme.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (dream.createdAt != null) ...[
              Row(
                children: [
                  Text(
                    translate('dream.dateLabel'),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.myTheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dream.createdAt!.value.diaMesAnoHora(),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.myTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              Divider(color: context.myTheme.primary),
            ],
            ChatMessageWidget(
              message: ChatMessage(text: dream.message.value, isUser: true),
              showAvatar: false,
            ),
          ],
        ),
      ),
    );
  }
}
