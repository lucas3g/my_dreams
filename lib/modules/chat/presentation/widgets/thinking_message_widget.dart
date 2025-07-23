import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';

class ThinkingMessageWidget extends StatelessWidget {
  const ThinkingMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.myTheme.secondaryContainer;
    final textColor = context.myTheme.onSecondaryContainer;

    final text = Text(
      'Pensando...',
      style: context.textTheme.bodyLarge?.copyWith(color: textColor),
    );

    final bubble = Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          AppThemeConstants.mediumBorderRadius,
        ),
      ),
      child: text,
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fade(duration: const Duration(milliseconds: 800))
        .scale(begin: 0.95, end: 1.05, duration: const Duration(milliseconds: 800));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 5),
          child: CircleAvatar(child: Icon(Icons.android)),
        ),
        const SizedBox(width: 10),
        Flexible(child: bubble),
      ],
    );
  }
}
