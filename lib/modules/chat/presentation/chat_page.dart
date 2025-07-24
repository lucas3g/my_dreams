import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/shared/components/app_circular_indicator_widget.dart';
import 'package:my_dreams/shared/components/app_snackbar.dart';
import 'package:my_dreams/shared/components/custom_button.dart';
import 'package:my_dreams/shared/components/text_form_field.dart';
import 'package:my_dreams/shared/services/ads_service.dart';
import 'package:my_dreams/shared/services/purchase_service.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/translate/translate.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../subscription/presentation/subscription_bottom_sheet.dart';
import '../domain/entities/tarot_card_entity.dart';
import '../domain/usecases/parse_tarot_message.dart';
import 'controller/chat_bloc.dart';
import 'controller/chat_events.dart';
import 'controller/chat_states.dart';
import 'widgets/chat_message_widget.dart';
import 'widgets/tarot_options_widget.dart';
import 'widgets/thinking_message_widget.dart';

class ChatPage extends StatefulWidget {
  final String? conversationId;

  const ChatPage({super.key, this.conversationId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatBloc _bloc = getIt<ChatBloc>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final ParseTarotMessageUseCase _parseTarot =
      getIt<ParseTarotMessageUseCase>();
  final AdsService _adsService = getIt<AdsService>();
  final PurchaseService _purchase = getIt<PurchaseService>();
  void _update() {
    if (mounted) setState(() {});
  }

  bool _isLoading = false;
  bool get _limitReached =>
      !_purchase.isPremium && _messages.where((m) => m.isUser).isNotEmpty;
  String? _currentConversationId;

  @override
  void initState() {
    super.initState();
    _adsService.addListener(_update);
    _purchase.addListener(_update);
    _currentConversationId = widget.conversationId;
    if (_currentConversationId != null) {
      _bloc.add(LoadMessagesEvent(conversationId: _currentConversationId!));
    }
  }

  @override
  void dispose() {
    _adsService.removeListener(_update);
    _purchase.removeListener(_update);
    _controller.dispose();
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    context.closeKeyboard();
    final user = AppGlobal.instance.user;
    final text = _controller.text.trim();
    if (user == null || text.isEmpty) return;

    final int limit = _purchase.isPremium ? 5 : 1;
    final int sent = _messages.where((m) => m.isUser).length;
    if (sent >= limit) {
      return;
    }

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();
    _bloc.add(
      SendMessageEvent(
        content: text,
        conversationId: _currentConversationId,
        userId: user.id.value,
      ),
    );
  }

  void _sendTarotMessage() {
    final user = AppGlobal.instance.user;
    if (user == null) return;
    final tarotText = translate('chat.generateTarot');
    setState(() {
      _messages.add(ChatMessage(text: tarotText, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();
    _bloc.add(
      SendMessageEvent(
        content: tarotText,
        conversationId: _currentConversationId,
        userId: user.id.value,
      ),
    );
  }

  void _sendTarotCard(TarotCardEntity card) {
    final user = AppGlobal.instance.user;
    if (user == null) return;
    setState(() {
      _messages.add(ChatMessage(text: card.description, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();
    _bloc.add(
      SendMessageEvent(
        content: card.description,
        conversationId: _currentConversationId,
        userId: user.id.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: Text(translate('chat.screen.title'))),
        body: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.padding),
          child: Column(
            children: [
              Expanded(
                child: BlocListener<ChatBloc, ChatStates>(
                  bloc: _bloc,
                  listener: (context, state) {
                    if (state is ChatLoadingState) {
                      setState(() => _isLoading = true);
                      _scrollToBottom();
                    } else if (state is ChatLoadedMessagesState) {
                      setState(() => _isLoading = false);
                      _messages
                        ..clear()
                        ..addAll(
                          state.messagesList.map(
                            (e) => ChatMessage(
                              text: e.content.value,
                              isUser: e.sender.value == 'user',
                            ),
                          ),
                        );
                      if (state.messagesList.isNotEmpty) {
                        _currentConversationId =
                            state.messagesList.first.conversationId.value;
                      }
                      _scrollToBottom();
                    } else if (state is ChatFailureState) {
                      setState(() => _isLoading = false);
                      showAppSnackbar(
                        context,
                        title: translate('common.oops'),
                        message: state.message,
                        type: TypeSnack.error,
                      );
                    }
                  },
                  child: SuperListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: AppThemeConstants.padding,
                    ),
                    controller: _scrollController,
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= _messages.length) {
                        return const ThinkingMessageWidget();
                      }
                      final message = _messages[index];
                      final widget = ChatMessageWidget(message: message);

                      if (!message.isUser) {
                        final cards = _parseTarot(message.text);
                        if (cards.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget,
                              const SizedBox(height: 8),
                              TarotOptionsWidget(
                                cards: cards,
                                onSelected: _sendTarotCard,
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        }

                        final hasTaro = _messages.any(
                          (msg) => msg.text.contains(
                            translate('chat.generateTarot'),
                          ),
                        );

                        if (!hasTaro && !_limitReached) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget,
                              AppCustomButton(
                                backgroundColor:
                                    context.myTheme.primaryContainer,
                                onPressed: _sendTarotMessage,
                                label: Text(translate('chat.generateTarot')),
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        }
                      }

                      return widget;
                    },
                  ),
                ),
              ),

              if (_limitReached)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: AppCustomButton(
                    expands: true,
                    onPressed: () => SubscriptionBottomSheet.show(context),
                    label: Text(translate('chat.limit.button')),
                  ),
                ),
              if (!_limitReached)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.myTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(
                            AppThemeConstants.mediumBorderRadius,
                          ),
                        ),
                        child: AppTextFormField(
                          controller: _controller,
                          readOnly: _isLoading,
                          textArea: true,
                          hint: !_isLoading
                              ? translate('chat.input.hint')
                              : translate('chat.input.sending'),
                          suffixIcon: !_isLoading
                              ? IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: _sendMessage,
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: AppCircularIndicatorWidget(size: 10),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
