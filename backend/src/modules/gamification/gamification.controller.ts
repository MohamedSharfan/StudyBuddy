import { Controller, Get, Param, Post } from '@nestjs/common';

import { GamificationService } from './gamification.service';

@Controller()
export class GamificationController {
  constructor(private readonly gamificationService: GamificationService) {}

  @Get('coins')
  coins() {
    return this.gamificationService.coins();
  }

  @Get('achievements')
  achievements() {
    return this.gamificationService.achievements();
  }

  @Get('leaderboards')
  leaderboards() {
    return this.gamificationService.leaderboards();
  }

  @Get('ranks')
  ranks() {
    return this.gamificationService.ranks();
  }

  @Get('rewards')
  rewards() {
    return this.gamificationService.rewards();
  }

  @Post('rewards/:id/unlock')
  unlockReward(@Param('id') rewardId: string) {
    return this.gamificationService.unlockReward(rewardId);
  }
}
