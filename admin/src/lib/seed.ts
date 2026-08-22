export const metrics = [
  { label: 'Total Students', value: '12,480', trend: '+18%' },
  { label: 'Active Today', value: '3,642', trend: '+9%' },
  { label: 'Quiz Accuracy', value: '74%', trend: '+6%' },
  { label: 'AI Questions', value: '28,910', trend: '+31%' },
];

export const launchSignals = [
  { label: 'Lessons published today', value: '18', trend: '+4' },
  { label: 'Knowledge chunks embedded', value: '1,248', trend: '+86' },
  { label: 'Streaks protected', value: '902', trend: '+11%' },
  { label: 'Coins redeemed', value: '1,880', trend: '+7%' },
];

export const subjects = [
  { name: 'Science', chapters: 18, lessons: 96, medium: 'Tamil O/L', status: 'Published' },
  { name: 'Maths', chapters: 22, lessons: 118, medium: 'Tamil O/L', status: 'Review' },
  { name: 'English', chapters: 14, lessons: 64, medium: 'Tamil O/L', status: 'Published' },
  { name: 'Tamil', chapters: 16, lessons: 72, medium: 'Tamil O/L', status: 'Draft' },
];

export const curriculumHealth = [
  { subject: 'Science', chapters: 18, published: 15, status: 'Ready' },
  { subject: 'Maths', chapters: 22, published: 16, status: 'Review' },
  { subject: 'English', chapters: 14, published: 14, status: 'Live' },
  { subject: 'Tamil', chapters: 16, published: 12, status: 'Embedding' },
];

export const publicationQueue = [
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
];

export const knowledgeJobs = [
  { title: 'O/L Science syllabus 2026', chunks: 1248, status: 'Embedded' },
  { title: 'Maths model paper set', chunks: 418, status: 'Processing' },
  { title: 'English grammar notes', chunks: 302, status: 'Ready' },
  { title: 'Tamil medium study guide', chunks: 226, status: 'Review' },
];

export const releaseChecklist = [
  'Syllabus mapping approved',
  'Tamil proofread complete',
  'Quiz answers validated',
  'AI knowledge chunks embedded',
  'Reward economy reviewed',
];

export const workflowQueue = [
  { title: 'Science chapter publish', stage: 'QA', owner: 'Curriculum', due: 'Today' },
  { title: 'Tamil medium review', stage: 'Proofread', owner: 'Editors', due: 'Tomorrow' },
  { title: 'AI embeddings refresh', stage: 'Vector sync', owner: 'AI ops', due: 'This week' },
];
