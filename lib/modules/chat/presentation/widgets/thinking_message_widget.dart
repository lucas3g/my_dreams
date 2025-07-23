import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_dreams/core/constants/constants.dart';

class ThinkingMessageWidget extends StatelessWidget {
  const ThinkingMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = context.myTheme.onSecondaryContainer;

    final text = Text(
      'Pensando...',
      style: context.textTheme.bodyLarge?.copyWith(color: textColor),
    );

    final bubble = text
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: const Duration(seconds: 2),
          color: context.myTheme.primaryContainer,
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
