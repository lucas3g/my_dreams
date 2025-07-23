import 'package:flutter/material.dart';
import 'package:my_dreams/modules/auth/presentation/auth_page.dart';
import 'package:my_dreams/modules/chat/presentation/chat_page.dart';
import 'package:my_dreams/modules/home/presentation/home_page.dart';
import 'package:my_dreams/modules/splash/presentation/splash_page.dart';

import '../domain/entities/named_routes.dart';
import 'domain/entities/custom_transition.dart';
import 'presenter/custom_page_builder.dart';

class CustomNavigator {
  CustomNavigator({required this.generateAnimation});

  final CustomTransition Function(RouteSettings) generateAnimation;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Map<String, WidgetBuilder> appRoutes = <String, WidgetBuilder>{
      NamedRoutes.splash.route: (BuildContext context) => const SplashPage(),
      NamedRoutes.auth.route: (BuildContext context) => const AuthPage(),
      NamedRoutes.home.route: (BuildContext context) => const HomePage(),
      NamedRoutes.chat.route: (BuildContext context) => const ChatPage(),
    };

    WidgetBuilder? builder = appRoutes[settings.name];

    if (settings.name == NamedRoutes.conversationChat.route) {
      final convId = settings.arguments as String?;
      builder = (BuildContext context) => ChatPage(conversationId: convId);
    }

    if (builder != null) {
      final CustomTransition customTransition = generateAnimation(settings);

      return CustomPageRouteBuilder(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return builder!(context);
            },
        customTransition: customTransition,
        settings: settings,
      );
    }

    return null;
  }
}
