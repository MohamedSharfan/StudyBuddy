import { Body, Controller, Get, Post } from '@nestjs/common';

import { CreateStudySessionDto } from './dto/create-study-session.dto';
import { ProgressService } from './progress.service';

@Controller()
export class ProgressController {
  constructor(private readonly progressService: ProgressService) {}

  @Get('progress/summary')
  summary() {
    return this.progressService.summary();
  }

  @Post('study-sessions')
  createSession(@Body() dto: CreateStudySessionDto) {
    return this.progressService.createSession(dto);
  }
}
