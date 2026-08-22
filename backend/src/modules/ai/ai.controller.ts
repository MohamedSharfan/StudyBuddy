import { Body, Controller, Param, Post } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { randomUUID } from 'crypto';

import { AiService } from './ai.service';
import { SendAiMessageDto } from './dto/send-ai-message.dto';

@Controller('ai')
export class AiController {
  constructor(private readonly aiService: AiService) {}

  @Post('conversations')
  createConversation() {
    return {
      id: randomUUID(),
      title: 'AI Panda chat',
    };
  }

  @Throttle({ default: { limit: 12, ttl: 60000 } })
  @Post('conversations/:id/messages')
  sendMessage(
    @Param('id') conversationId: string,
    @Body() dto: SendAiMessageDto,
  ) {
    return this.aiService.answer(conversationId, dto.message);
  }
}
