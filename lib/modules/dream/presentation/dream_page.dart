import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/shared/components/text_form_field.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';

import '../presentation/controller/dream_bloc.dart';
import '../presentation/controller/dream_events.dart';
import '../presentation/controller/dream_states.dart';
import 'widgets/chat_message_widget.dart';

class DreamPage extends StatefulWidget {
  const DreamPage({super.key});

  @override
  State<DreamPage> createState() => _DreamPageState();
}

class _DreamPageState extends State<DreamPage> {
  final DreamBloc _bloc = getIt<DreamBloc>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
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

  void _updateAssistantMessage(String text) {
    if (_messages.isNotEmpty && !_messages.last.isUser) {
      _messages[_messages.length - 1] = ChatMessage(text: text, isUser: false);
    } else {
      _messages.add(ChatMessage(text: text, isUser: false));
    }
    _scrollToBottom();
  }

  void _sendDream() {
    final user = AppGlobal.instance.user;
    final text = _controller.text.trim();
    if (user == null || text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();
    _bloc.add(SendDreamEvent(dreamText: text, userId: user.id.value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Sonho')),
      body: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.padding),
        child: Column(
          children: [
            Expanded(
              child: BlocListener<DreamBloc, DreamStates>(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is DreamLoadingState) {
                    setState(() => _isLoading = true);
                  } else if (state is DreamStreamingState) {
                    setState(() {
                      _isLoading = false;
                      _updateAssistantMessage(state.answer);
                    });
                  } else if (state is DreamAnalyzedState) {
                    setState(() {
                      _isLoading = false;
                      _updateAssistantMessage(state.dream.answer.value);
                    });
                  } else if (state is DreamFailureState) {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return ChatMessageWidget(message: message);
                  },
                ),
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
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
                      hint: 'Descreva seu sonho',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendDream,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
