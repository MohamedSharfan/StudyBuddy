import { Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';

import { CreateContentDto } from './dto/create-content.dto';
import { UploadKnowledgeDto } from './dto/upload-knowledge.dto';

@Injectable()
export class AdminService {
  dashboard() {
    return {
      summary: {
        totalStudents: 12480,
        activeUsers: 3642,
        premiumStudents: 2180,
        quizAccuracy: 74,
        aiQuestions: 28910,
        crashFreeRate: 99.96,
      },
      liveSignals: [
        { label: 'Lessons published today', value: 18, trend: '+4' },
        { label: 'Knowledge chunks embedded', value: 1248, trend: '+86' },
        { label: 'Streaks protected', value: 902, trend: '+11%' },
        { label: 'Coins redeemed', value: 1880, trend: '+7%' },
      ],
      popularSubjects: ['Science', 'Maths', 'English', 'Tamil'],
      curriculumHealth: [
        { subject: 'Science', chapters: 18, published: 15, status: 'Ready' },
        { subject: 'Maths', chapters: 22, published: 16, status: 'Review' },
        { subject: 'English', chapters: 14, published: 14, status: 'Live' },
        { subject: 'Tamil', chapters: 16, published: 12, status: 'Embedding' },
      ],
      publicationQueue: [
        {
          title: 'Grade 10 Science - Human Body',
          owner: 'Curriculum team',
          status: 'QA pending',
        },
        {
          title: 'Tamil model paper set 04',
          owner: 'Content ops',
          status: 'Scheduled',
        },
        {
          title: 'Maths flashcard refresh',
          owner: 'AI Panda',
          status: 'Embedding',
        },
      ],
      releaseChecklist: [
        'Syllabus mapping approved',
        'Tamil proofread complete',
        'Quiz answers validated',
        'AI knowledge chunks embedded',
        'Reward economy reviewed',
      ],
    };
  }

  content() {
    return {
      subjects: [
        {
          name: 'Science',
          chapters: 18,
          lessons: 96,
          medium: 'Tamil O/L',
          status: 'Published',
        },
        {
          name: 'Maths',
          chapters: 22,
          lessons: 118,
          medium: 'Tamil O/L',
          status: 'Review',
        },
        {
          name: 'English',
          chapters: 14,
          lessons: 64,
          medium: 'Tamil O/L',
          status: 'Published',
        },
        {
          name: 'Tamil',
          chapters: 16,
          lessons: 72,
          medium: 'Tamil O/L',
          status: 'Draft',
        },
      ],
      lessons: [
        { title: 'Cell structure', subject: 'Science', state: 'Ready for app' },
        { title: 'Linear equations', subject: 'Maths', state: 'Needs QA' },
        { title: 'Letter writing', subject: 'English', state: 'Published' },
      ],
      flashcards: [
        { title: 'Science chapter 01', cards: 24, status: 'Synced' },
        { title: 'Tamil grammar set', cards: 18, status: 'Draft' },
      ],
    };
  }

  workflow() {
    return {
      queue: [
        { title: 'Science chapter publish', stage: 'QA', owner: 'Curriculum', due: 'Today' },
        { title: 'Tamil medium review', stage: 'Proofread', owner: 'Editors', due: 'Tomorrow' },
        { title: 'AI embeddings refresh', stage: 'Vector sync', owner: 'AI ops', due: 'This week' },
      ],
      checks: [
        { label: 'Syllabus mapped', complete: true },
        { label: 'Answer keys verified', complete: true },
        { label: 'Embeddings generated', complete: true },
        { label: 'Mobile app cache primed', complete: false },
      ],
    };
  }

  createContent(dto: CreateContentDto) {
    return {
      id: randomUUID(),
      status: 'draft',
      ...dto,
    };
  }

  uploadKnowledge(dto: UploadKnowledgeDto) {
    return {
      id: randomUUID(),
      title: dto.title,
      estimatedChunks: Math.ceil(dto.content.length / 900),
      status: 'uploaded',
    };
  }

  embedKnowledge(documentId: string) {
    return {
      documentId,
      status: 'embedding_queued',
    };
  }
}
