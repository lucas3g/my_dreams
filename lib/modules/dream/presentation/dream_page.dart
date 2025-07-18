import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import '../presentation/controller/dream_bloc.dart';
import '../presentation/controller/dream_events.dart';
import '../presentation/controller/dream_states.dart';

class DreamPage extends StatefulWidget {
  const DreamPage({super.key});

  @override
  State<DreamPage> createState() => _DreamPageState();
}

class _DreamPageState extends State<DreamPage> {
  final DreamBloc _bloc = getIt<DreamBloc>();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildResult(DreamStates state) {
    if (state is DreamLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is DreamStreamingState) {
      return Expanded(
        child: SingleChildScrollView(
          child: Text(state.answer),
        ),
      );
    }

    if (state is DreamAnalyzedState) {
      return Expanded(
        child: SingleChildScrollView(
          child: Text(state.dream.answer.value),
        ),
      );
    }

    if (state is DreamFailureState) {
      return Text(state.message);
    }

    return const SizedBox.shrink();
  }

  void _sendDream() {
    final user = AppGlobal.instance.user;
    if (user == null) return;
    _bloc.add(SendDreamEvent(dreamText: _controller.text, userId: user.id.value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Sonho')),
      body: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.padding),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Descreva seu sonho'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendDream,
              child: const Text('Enviar'),
            ),
            const SizedBox(height: 20),
            BlocBuilder<DreamBloc, DreamStates>(
              bloc: _bloc,
              builder: (context, state) => _buildResult(state),
            ),
          ],
        ),
      ),
    );
  }
}
