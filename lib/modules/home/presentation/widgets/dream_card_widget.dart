import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/modules/dream/domain/entities/dream_entity.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';

class DreamCardWidget extends StatelessWidget {
  final DreamEntity dream;

  const DreamCardWidget({super.key, required this.dream});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.myTheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppThemeConstants.mediumBorderRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dream.message.value,
              style: context.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(dream.answer.value),
            if (dream.imageUrl.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.network(
                  dream.imageUrl.value,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
