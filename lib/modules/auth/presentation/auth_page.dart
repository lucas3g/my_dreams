import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/core/domain/entities/app_assets.dart';
import 'package:my_dreams/core/domain/entities/named_routes.dart';
import 'package:my_dreams/modules/auth/presentation/controller/auth_bloc.dart';
import 'package:my_dreams/modules/auth/presentation/controller/auth_events.dart';
import 'package:my_dreams/modules/auth/presentation/controller/auth_states.dart';
import 'package:my_dreams/shared/components/app_circular_indicator_widget.dart';
import 'package:my_dreams/shared/components/app_snackbar.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/translate/translate.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthBloc _authBloc = getIt<AuthBloc>();

  StreamSubscription<AuthStates>? _authSubscription;

  void _listenAuthStates() {
    _authSubscription = _authBloc.stream.listen((state) async {
      if (state is AuthSuccessState) {
        await Future.delayed(const Duration(milliseconds: 350));

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, NamedRoutes.home.route);
      }
      if (state is AuthFailureState) {
        if (state.message.contains('Cancelled by user')) {
          return; // Usuário cancelou o login, não exibe snackbar
        }

        if (!mounted) return;

        showAppSnackbar(
          context,
          title: translate('common.error'),
          message: state.message,
          type: TypeSnack.error,
        );
      }
    });
  }

  Widget _handleButtonGoogle(AuthStates states) {
    if (states is AuthLoadingState) {
      return const AppCircularIndicatorWidget(size: 20);
    }

    if (states is AuthSuccessState) {
      return const Icon(Icons.check, size: 25);
    }

    return Text(
      translate('auth.googleButton'),
      style: context.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.myTheme.surface,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light, // Para iOS
      ),
    );

    _listenAuthStates();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.padding),
          child: SizedBox(
            width: context.screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      AppAssets.logo,
                      width: context.screenWidth * .5,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      translate('auth.screen.title'),
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(translate('auth.screen.subtitle')),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    BlocBuilder<AuthBloc, AuthStates>(
                      bloc: _authBloc,
                      builder: (context, state) {
                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(10),
                            backgroundColor: context.myTheme.onPrimary,
                            textStyle: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            fixedSize: Size(context.screenWidth, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            _authBloc.add(LoginWithGoogleAccountEvent());
                          },
                          icon:
                              state is! AuthLoadingState &&
                                  state is! AuthSuccessState
                              ? Image.asset(AppAssets.google, width: 25)
                              : null,
                          label: _handleButtonGoogle(state),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      translate('auth.screen.footer'),
                      style: context.textTheme.bodyLarge?.copyWith(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
