import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/modules/chat/domain/entities/conversation_entity.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/utils/formatters.dart';

class ConversationCardWidget extends StatelessWidget {
  final ConversationEntity conversation;

  const ConversationCardWidget({super.key, required this.conversation});

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
            Text(
              conversation.title.value,
              style: context.textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              conversation.updatedAt.value.diaMesAnoHora(),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.myTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
