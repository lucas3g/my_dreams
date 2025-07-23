import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/modules/dream/domain/entities/dream_entity.dart';
import 'package:my_dreams/modules/dream/presentation/widgets/chat_message_widget.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/utils/formatters.dart';

class DreamChatPage extends StatelessWidget {
  final DreamEntity dream;

  const DreamChatPage({super.key, required this.dream});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sonho')),
      body: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.padding),
        child: ListView(
          children: [
            if (dream.createdAt != null) ...[
              Row(
                children: [
                  Text(
                    'Data: ',
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
