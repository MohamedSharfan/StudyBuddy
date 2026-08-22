import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../learning/application/learning_providers.dart';
import '../data/ai_panda_repository.dart';
import '../domain/chat_message.dart';

final aiPandaRepositoryProvider = Provider<AiPandaRepository>(
  (ref) => AiPandaRepository(
    learningRepository: ref.watch(learningRepositoryProvider),
  ),
);

final aiPandaControllerProvider =
    AsyncNotifierProvider<AiPandaController, List<ChatMessage>>(
  AiPandaController.new,
);

class AiPandaController extends AsyncNotifier<List<ChatMessage>> {
  @override
  Future<List<ChatMessage>> build() async {
    return const [
      ChatMessage(
        role: ChatRole.panda,
        content:
            'Hi, I am AI Panda. Ask me about notes, quizzes, or exam preparation.',
      ),
    ];
  }

  Future<void> send(String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final current = state.valueOrNull ?? const <ChatMessage>[];
    state = AsyncData([
      ...current,
      ChatMessage(role: ChatRole.user, content: trimmed),
    ]);

    final answer = await ref.read(aiPandaRepositoryProvider).ask(trimmed);
    final latest = state.valueOrNull ?? [
      ...current,
      ChatMessage(role: ChatRole.user, content: trimmed),
    ];

    state = AsyncData([
      ...latest,
      ChatMessage(role: ChatRole.panda, content: answer),
    ]);
  }
}
