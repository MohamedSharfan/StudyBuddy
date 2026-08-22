import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';

@Injectable()
export class AiService {
  private readonly openai?: OpenAI;

  constructor(private readonly config: ConfigService) {
    const apiKey = this.config.get<string>('OPENAI_API_KEY');
    this.openai = apiKey ? new OpenAI({ apiKey }) : undefined;
  }

  async answer(conversationId: string, message: string) {
    const context = await this.retrieveContext(message);

    if (!this.openai) {
      return {
        conversationId,
        answer: this.fallbackAnswer(context),
        sources: context,
      };
    }

    const completion = await this.openai.chat.completions.create({
      model: this.config.get<string>('OPENAI_MODEL') ?? 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content:
            'You are AI Panda, a friendly Sri Lankan exam coach. Answer from the provided syllabus context. Keep explanations simple and include exam tips.',
        },
        {
          role: 'user',
          content: `Context:\n${context.join('\n')}\n\nQuestion:\n${message}`,
        },
      ],
      temperature: 0.3,
    });

    return {
      conversationId,
      answer: completion.choices[0]?.message.content ?? this.fallbackAnswer(context),
      sources: context,
    };
  }

  private async retrieveContext(message: string): Promise<string[]> {
    void message;
    // Replace with pgvector similarity search over knowledge_chunks.
    return [
      'Photosynthesis uses sunlight, chlorophyll, carbon dioxide, and water to produce glucose and oxygen.',
      'Exam answers should include key terms, a clear process, and one example.',
    ];
  }

  private fallbackAnswer(context: string[]) {
    return `Based on your syllabus notes: ${context.join(' ')} Exam tip: write the key terms first, then explain in short steps.`;
  }
}
