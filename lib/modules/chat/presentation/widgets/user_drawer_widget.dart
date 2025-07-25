import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/domain/entities/app_assets.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/named_routes.dart';
import 'package:my_dreams/core/domain/entities/subscription_plan.dart';
import 'package:my_dreams/shared/components/custom_button.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/translate/translate.dart';

class UserDrawerWidget extends StatelessWidget {
  const UserDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final plan = AppGlobal.instance.plan;

    Widget? buildSubscribeButton() {
      if (plan == SubscriptionPlan.annual) {
        return null;
      }

      final label =
          plan == SubscriptionPlan.weekly || plan == SubscriptionPlan.monthly
          ? translate('conversation.upgradeButton')
          : translate('conversation.subscribeButton');

      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppThemeConstants.padding,
        ),
        child: AppCustomButton(
          backgroundColor: context.myTheme.primary,
          expands: true,
          onPressed: () async {
            Navigator.pop(context);
            await Navigator.pushNamed(context, NamedRoutes.subscription.route);
          },
          label: Text(label),
          icon: Image.asset(AppAssets.crown, width: 20, height: 20),
        ),
      );
    }

    return Drawer(
      backgroundColor: context.myTheme.primaryContainer,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppThemeConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(AppGlobal.instance.user!.name.value),
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: context.myTheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(color: context.myTheme.primary),
                ],
              ),
            ),

            if (buildSubscribeButton() != null) ...[
              buildSubscribeButton()!,
              const SizedBox(height: AppThemeConstants.mediumPadding),
            ],
          ],
        ),
      ),
    );
  }
}
