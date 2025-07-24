import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/shared/components/custom_button.dart';

import '../../domain/entities/tarot_card_entity.dart';

class TarotOptionsWidget extends StatelessWidget {
  final List<TarotCardEntity> cards;
  final void Function(TarotCardEntity) onSelected;

  const TarotOptionsWidget({
    super.key,
    required this.cards,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: cards
            .map(
              (card) => AppCustomButton(
                backgroundColor: context.myTheme.primaryContainer,
                onPressed: () => onSelected(card),
                label: Text(card.title),
              ),
            )
            .toList(),
      ),
    );
  }
}
