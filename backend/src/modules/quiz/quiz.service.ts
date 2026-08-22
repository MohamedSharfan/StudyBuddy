import { Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';

import { SubmitAnswerDto } from './dto/submit-answer.dto';

@Injectable()
export class QuizService {
  startAttempt() {
    return {
      attemptId: randomUUID(),
      status: 'started',
    };
  }

  submitAnswer(attemptId: string, dto: SubmitAnswerDto) {
    return {
      attemptId,
      questionId: dto.questionId,
      selectedOptionId: dto.optionId,
      correct: false,
      explanation: 'Connect this endpoint to quiz_options for real scoring.',
    };
  }

  submitAttempt(attemptId: string) {
    return {
      attemptId,
      status: 'completed',
      coinsAwarded: 0,
      xpAwarded: 0,
    };
  }
}
