import { Injectable } from '@nestjs/common';

@Injectable()
export class GamificationService {
  coins() {
    return {
      balance: 1240,
      ledger: [],
    };
  }

  achievements() {
    return {
      items: [
        { code: 'first_quiz', title: 'First Quiz Completed', unlocked: false },
        { code: 'seven_day_streak', title: '7 Day Streak', unlocked: true },
      ],
    };
  }

  leaderboards() {
    return {
      type: 'overall',
      entries: [],
    };
  }

  ranks() {
    return {
      items: [
        { code: 'bronze', minXp: 0 },
        { code: 'silver', minXp: 1500 },
        { code: 'gold', minXp: 4000 },
        { code: 'platinum', minXp: 7000 },
        { code: 'champion', minXp: 10000 },
      ],
    };
  }

  rewards() {
    return {
      items: [
        { code: 'scholar_panda', title: 'Scholar Panda Outfit', coinPrice: 450 },
      ],
    };
  }

  unlockReward(rewardId: string) {
    return {
      rewardId,
      unlocked: true,
    };
  }
}
