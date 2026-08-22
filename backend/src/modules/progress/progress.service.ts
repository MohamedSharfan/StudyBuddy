import { Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';

import { CreateStudySessionDto } from './dto/create-study-session.dto';

@Injectable()
export class ProgressService {
  summary() {
    return {
      overallProgress: 45,
      subjectProgress: [],
      streakDays: 7,
    };
  }

  createSession(dto: CreateStudySessionDto) {
    return {
      id: randomUUID(),
      ...dto,
      recorded: true,
    };
  }
}
