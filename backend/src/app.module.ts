import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule } from '@nestjs/throttler';

import { AdminModule } from './modules/admin/admin.module';
import { AiModule } from './modules/ai/ai.module';
import { GamificationModule } from './modules/gamification/gamification.module';
import { ProgressModule } from './modules/progress/progress.module';
import { QuizModule } from './modules/quiz/quiz.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    ThrottlerModule.forRoot([
      {
        ttl: 60000,
        limit: 60,
      },
    ]),
    QuizModule,
    ProgressModule,
    GamificationModule,
    AiModule,
    AdminModule,
  ],
})
export class AppModule {}
