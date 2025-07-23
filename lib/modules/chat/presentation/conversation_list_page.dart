import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/named_routes.dart';
import 'package:my_dreams/modules/auth/domain/entities/user_entity.dart';
import 'package:my_dreams/modules/auth/presentation/controller/auth_bloc.dart';
import 'package:my_dreams/modules/auth/presentation/controller/auth_events.dart';
import 'package:my_dreams/modules/auth/presentation/controller/auth_states.dart';
import 'package:my_dreams/shared/components/app_circular_indicator_widget.dart';
import 'package:my_dreams/shared/components/app_snackbar.dart';
import 'package:my_dreams/shared/components/spacer_height_widget.dart';
import 'package:my_dreams/shared/components/spacer_width.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../home/presentation/widgets/conversation_card_widget.dart';
import 'controller/chat_bloc.dart';
import 'controller/chat_events.dart';
import 'controller/chat_states.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final ChatBloc _chatBloc = getIt<ChatBloc>();

  StreamSubscription<AuthStates>? _authSubscription;

  UserEntity? get _user => AppGlobal.instance.user;

  void _listenAuthStates() {
    _authSubscription = _authBloc.stream.listen((state) async {
      if (state is LogoutAccountState) {
        AppGlobal.instance.setUser(null);

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, NamedRoutes.auth.route);
      }
      if (state is AuthFailureState) {
        if (!mounted) return;

        showAppSnackbar(
          context,
          title: 'Erro',
          message: state.message,
          type: TypeSnack.error,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _listenAuthStates();
    final user = _user;
    if (user != null) {
      _chatBloc.add(LoadConversationsEvent(userId: user.id.value));
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();

    super.dispose();
  }

  Future<void> _confirmLogout() async {
    final bool? logout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.myTheme.primaryContainer,
          title: const Text('Sair'),
          content: const Text('Deseja realmente sair do aplicativo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (logout == true) {
      _authBloc.add(LogoutAccountEvent());
    }
  }

  Widget _handleLogoutIcon(AuthStates state) {
    if (state is AuthLoadingState) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: AppCircularIndicatorWidget(size: 16),
      );
    }

    return const Icon(Icons.logout);
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.padding),
          child: Column(
            children: [
              if (user != null)
                Card(
                  color: context.myTheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppThemeConstants.mediumBorderRadius,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      AppThemeConstants.mediumPadding,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: user.imageUrl.value.isNotEmpty
                              ? NetworkImage(user.imageUrl.value)
                                    as ImageProvider
                              : null,
                          radius: 22,
                          child: user.imageUrl.value.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SpacerWidth(),
                        Expanded(
                          child: Text(
                            user.name.value,
                            style: context.textTheme.bodyLarge,
                          ),
                        ),
                        BlocBuilder<AuthBloc, AuthStates>(
                          bloc: _authBloc,
                          builder: (context, state) {
                            return IconButton(
                              icon: _handleLogoutIcon(state),
                              onPressed: state is AuthLoadingState
                                  ? null
                                  : _confirmLogout,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SpacerHeight(),
              Expanded(
                child: BlocBuilder<ChatBloc, ChatStates>(
                  bloc: _chatBloc,
                  builder: (context, state) {
                    if (state is ChatLoadingState) {
                      return const Center(child: AppCircularIndicatorWidget());
                    }
                    if (state is ChatLoadedConversationsState) {
                      if (state.conversationsList.isEmpty) {
                        return const Center(
                          child: Text('Nenhum significado encontrado'),
                        );
                      }
                      return SuperListView.separated(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: state.conversationsList.length,
                        separatorBuilder: (_, __) => const SpacerHeight(),
                        itemBuilder: (context, index) {
                          final conv = state.conversationsList[index];

                          return InkWell(
                            onTap: () async {
                              await Navigator.pushNamed(
                                context,
                                NamedRoutes.conversationChat.route,
                                arguments: conv.id.value,
                              );

                              _chatBloc.add(
                                LoadConversationsEvent(userId: user!.id.value),
                              );
                            },
                            child: ConversationCardWidget(conversation: conv),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            NamedRoutes.conversationChat.route,
          );

          _chatBloc.add(LoadConversationsEvent(userId: user!.id.value));
        },
        label: const Text('Novo Significado'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
