import { Body, Controller, Param, Post } from '@nestjs/common';

import { SubmitAnswerDto } from './dto/submit-answer.dto';
import { QuizService } from './quiz.service';

@Controller('quiz-attempts')
export class QuizController {
  constructor(private readonly quizService: QuizService) {}

  @Post()
  startAttempt() {
    return this.quizService.startAttempt();
  }

  @Post(':id/answers')
  submitAnswer(@Param('id') attemptId: string, @Body() dto: SubmitAnswerDto) {
    return this.quizService.submitAnswer(attemptId, dto);
  }

  @Post(':id/submit')
  submitAttempt(@Param('id') attemptId: string) {
    return this.quizService.submitAttempt(attemptId);
  }
}
