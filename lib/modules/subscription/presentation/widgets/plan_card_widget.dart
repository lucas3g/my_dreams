import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';

class PlanCardWidget extends StatelessWidget {
  final String title;
  final String price;
  final String? oldPrice;
  final List<String> benefits;
  final VoidCallback onTap;
  final bool isActive;

  const PlanCardWidget({
    super.key,
    required this.title,
    required this.price,
    required this.benefits,
    required this.onTap,
    this.oldPrice,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive
          ? context.myTheme.primary
          : context.myTheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppThemeConstants.mediumBorderRadius,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          AppThemeConstants.mediumBorderRadius,
        ),
        onTap: isActive ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(title, style: context.textTheme.titleMedium),
                  ),
                  if (oldPrice != null && oldPrice!.isNotEmpty)
                    Text.rich(
                      TextSpan(
                        text: price,
                        style: context.textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: ' de ',
                            style: context.textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: oldPrice,
                            style: context.textTheme.bodyMedium?.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Text(price, style: context.textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 8),
              ...benefits.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $b', style: context.textTheme.bodyMedium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
