import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/particle_background.dart';
import '../application/ai_panda_controller.dart';
import '../domain/chat_message.dart';

class AiPandaPage extends ConsumerStatefulWidget {
  const AiPandaPage({super.key});

  @override
  ConsumerState<AiPandaPage> createState() => _AiPandaPageState();
}

class _AiPandaPageState extends ConsumerState<AiPandaPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesState = ref.watch(aiPandaControllerProvider);
    final isLoading = messagesState.isLoading;
    final messages = messagesState.valueOrNull ?? const <ChatMessage>[];

    return Scaffold(
      body: ParticleBackground(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpace.s(context, 16),
                  AppSpace.s(context, 8),
                  AppSpace.s(context, 16),
                  6,
                ),
                child: Row(
                  children: [
                    BrandLogo(size: AppSpace.s(context, 32), animated: false),
                    const SizedBox(width: 10),
                    Text(
                      'AI Panda',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Online',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: messages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= messages.length) {
                    return const _TypingBubble();
                  }

                  return _ChatBubble(message: messages[index]);
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Ask AI Panda...',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: AppColors.darkCard,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(
                              color: AppColors.brightPurple.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: isLoading
                          ? null
                          : () {
                              final text = _controller.text;
                              _controller.clear();
                              ref
                                  .read(aiPandaControllerProvider.notifier)
                                  .send(text);
                            },
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .78,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? AppColors.royalPurple : AppColors.darkCard,
          borderRadius: BorderRadius.circular(20),
          border: isUser
              ? null
              : Border.all(
                  color: AppColors.brightPurple.withValues(alpha: 0.2),
                ),
        ),
        child: Text(
          message.content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                height: 1.45,
              ),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.brightPurple.withValues(alpha: 0.2),
          ),
        ),
        child: const Text(
          'AI Panda is typing...',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
