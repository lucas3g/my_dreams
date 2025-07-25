import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/domain/entities/app_assets.dart';
import 'package:my_dreams/shared/components/custom_button.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/translate/translate.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: isActive,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    translate(
                      'purchase.current',
                      params: {'plan': ''},
                    ).replaceAll('-', ''),
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (title.contains('Weekly'))
                  Image.asset(AppAssets.crown, width: 20, height: 20),
                if (title.contains('Monthly')) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(AppAssets.crown, width: 20, height: 20),
                      Image.asset(AppAssets.crown, width: 20, height: 20),
                    ],
                  ),
                ],
                if (title.contains('Annual')) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(AppAssets.crown, width: 20, height: 20),
                      Image.asset(AppAssets.crown, width: 20, height: 20),
                      Image.asset(AppAssets.crown, width: 20, height: 20),
                    ],
                  ),
                ],
                SizedBox(
                  height: 8,
                  child: VerticalDivider(color: Colors.white),
                ),
                Text(title, style: context.textTheme.titleMedium),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (oldPrice != null && oldPrice!.isNotEmpty)
                  Text.rich(
                    TextSpan(
                      text: price,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
            Align(
              alignment: Alignment.centerRight,
              child: AppCustomButton(
                backgroundColor: context.myTheme.primary,
                label: Text('${translate('purchase.subscribeButton')} $price'),
                onPressed: isActive ? null : onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
