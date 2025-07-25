import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/core/domain/entities/app_assets.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/named_routes.dart';
import 'package:my_dreams/modules/auth/domain/entities/user_entity.dart';
import 'package:my_dreams/modules/auth/presentation/controller/auth_bloc.dart';
import 'package:my_dreams/modules/auth/presentation/controller/auth_events.dart';
import 'package:my_dreams/modules/auth/presentation/controller/auth_states.dart';
import 'package:my_dreams/shared/components/app_circular_indicator_widget.dart';
import 'package:my_dreams/shared/components/app_snackbar.dart';
import 'package:my_dreams/shared/components/custom_button.dart';
import 'package:my_dreams/shared/components/spacer_height_widget.dart';
import 'package:my_dreams/shared/components/spacer_width.dart';
import 'package:my_dreams/shared/services/ads_service.dart';
import 'package:my_dreams/shared/services/purchase_service.dart';
import 'package:my_dreams/core/domain/entities/app_config.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/translate/translate.dart';
import 'package:my_dreams/shared/utils/formatters.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../domain/entities/conversation_entity.dart';
import 'controller/chat_bloc.dart';
import 'controller/chat_events.dart';
import 'controller/chat_states.dart';
import 'widgets/conversation_card_widget.dart';
import 'widgets/user_drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final ChatBloc _chatBloc = getIt<ChatBloc>();
  final AdsService _adsService = getIt<AdsService>();
  final PurchaseService _purchase = getIt<PurchaseService>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _update() {
    if (mounted) setState(() {});
  }

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
          title: translate('common.error'),
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
    _adsService.addListener(_update);
    _purchase.addListener(_update);
    final user = _user;
    if (user != null) {
      _chatBloc.add(LoadConversationsEvent(userId: user.id.value));
    }
  }

  @override
  void dispose() {
    _adsService.removeListener(_update);
    _purchase.removeListener(_update);
    _authSubscription?.cancel();

    super.dispose();
  }

  Future<void> _confirmLogout() async {
    final bool? logout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.myTheme.primaryContainer,
          title: Text(translate('conversation.logout.title')),
          content: Text(translate('conversation.logout.message')),
          actions: [
            AppCustomButton(
              backgroundColor: context.myTheme.primary,
              onPressed: () => Navigator.of(context).pop(false),
              label: Text(translate('conversation.logout.cancel')),
            ),
            AppCustomButton(
              backgroundColor: context.myTheme.primary,
              onPressed: () => Navigator.of(context).pop(true),
              label: Text(translate('conversation.logout.confirm')),
            ),
          ],
        );
      },
    );

    if (logout == true) {
      _authBloc.add(LogoutAccountEvent());
    }
  }

  bool _canCreateConversation(List<ConversationEntity> list) {
    final int limit =
        _purchase.isPremium ? AppConfig.premiumLimit : 1;
    final now = DateTime.now();
    final todayCount = list
        .where((conv) => conv.createdAt.value.isSameDate(now))
        .length;
    return todayCount < limit;
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
      key: _scaffoldKey,
      drawer: const UserDrawerWidget(),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.padding),
          child: Column(
            children: [
              if (!_purchase.isPremium && _adsService.topBanner != null) ...[
                SizedBox(
                  height: _adsService.topBanner!.size.height.toDouble(),
                  child: AdWidget(ad: _adsService.topBanner!),
                ),
                SizedBox(height: 10),
              ],

              if (user != null)
                InkWell(
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
                  child: Card(
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
                        return Center(
                          child: Text(translate('conversation.empty')),
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
              // if (!_purchase.isPremium && _adsService.bottomBanner != null)
              //   SizedBox(
              //     height: _adsService.bottomBanner!.size.height.toDouble(),
              //     child: AdWidget(ad: _adsService.bottomBanner!),
              //   ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: AppThemeConstants.padding + 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<ChatBloc, ChatStates>(
              bloc: _chatBloc,
              builder: (context, state) {
                final conversations = state is ChatLoadedConversationsState
                    ? state.conversationsList
                    : <ConversationEntity>[];
                final canCreate = _canCreateConversation(conversations);

                return FloatingActionButton.extended(
                  heroTag: 'new-conversation',
                  onPressed: canCreate
                      ? () async {
                          if (!_purchase.isPremium) {
                            await _adsService.showInterstitial();
                          }

                          if (!mounted) return;

                          await Navigator.pushNamed(
                            context,
                            NamedRoutes.conversationChat.route,
                          );

                          _chatBloc.add(
                            LoadConversationsEvent(userId: user!.id.value),
                          );
                        }
                      : () async {
                          showAppSnackbar(
                            context,
                            title: translate('chat.limit.title'),
                            message: translate('chat.limit.button'),
                            type: TypeSnack.help,
                          );

                          await Future.delayed(const Duration(seconds: 1));

                          await Navigator.pushNamed(
                            context,
                            NamedRoutes.subscription.route,
                          );
                        },
                  label: Text(translate('conversation.new')),
                  icon: const Icon(Icons.add),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
