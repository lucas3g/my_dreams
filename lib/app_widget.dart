import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_dreams/core/domain/entities/app_language.dart';
import 'package:my_dreams/core/domain/entities/named_routes.dart';
import 'package:my_dreams/core/routes/app_routes.dart';
import 'package:my_dreams/core/routes/domain/entities/custom_transition.dart';
import 'package:my_dreams/core/routes/domain/entities/custom_transition_type.dart';
import 'package:my_dreams/shared/themes/theme.dart';
import 'package:my_dreams/shared/utils/global_context.dart';
import 'package:my_dreams/shared/translate/translate.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: translate('app.name'),
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalContext.navigatorKey,
      darkTheme: darkThemeApp,
      themeMode: ThemeMode.dark,
      initialRoute: NamedRoutes.initialSplash.route,
      supportedLocales: <Locale>[
        AppLanguage.portuguese.locale,
        AppLanguage.english.locale,
      ],
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: CustomNavigator(
        generateAnimation: _generateAnimation,
      ).onGenerateRoute,
    );
  }

  CustomTransition _generateAnimation(RouteSettings settings) {
    return CustomTransition(
      transitionType: CustomTransitionType.fade,
      duration: const Duration(milliseconds: 200),
    );
  }
}
