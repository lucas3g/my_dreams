import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/shared/components/app_circular_indicator_widget.dart';
import 'package:my_dreams/shared/components/app_snackbar.dart';
import 'package:my_dreams/shared/components/text_form_field.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../dream/presentation/widgets/chat_message_widget.dart';
import 'controller/chat_bloc.dart';
import 'controller/chat_events.dart';
import 'controller/chat_states.dart';

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
  bool _isLoading = false;
  String? _currentConversationId;

  @override
  void initState() {
    super.initState();
    _currentConversationId = widget.conversationId;
    if (_currentConversationId != null) {
      _bloc.add(LoadMessagesEvent(conversationId: _currentConversationId!));
    }
  }

  @override
  void dispose() {
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

  void _sendMessage() {
    context.closeKeyboard();
    final user = AppGlobal.instance.user;
    final text = _controller.text.trim();
    if (user == null || text.isEmpty) return;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: const Text('Conversa')),
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
                        title: 'Ops...',
                        message: state.message,
                        type: TypeSnack.error,
                      );
                    }
                  },
                  child: SuperListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ChatMessageWidget(message: message);
                    },
                  ),
                ),
              ),
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
                            ? 'Digite sua mensagem'
                            : 'Enviando...',
                        suffixIcon: !_isLoading
                            ? IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: _sendMessage,
                              )
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: AppCircularIndicatorWidget(size: 20),
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
