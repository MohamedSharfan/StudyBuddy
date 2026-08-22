import { AdminService } from './admin.service';

describe('AdminService', () => {
  const service = new AdminService();

  it('returns structured dashboard metrics', () => {
    const dashboard = service.dashboard();

    expect(dashboard.summary.totalStudents).toBe(12480);
    expect(dashboard.liveSignals).toHaveLength(4);
    expect(dashboard.curriculumHealth.some((item) => item.status === 'Ready')).toBe(true);
    expect(dashboard.releaseChecklist).toContain('Reward economy reviewed');
  });

  it('creates content with a draft status and identifier', () => {
    const content = service.createContent({
      type: 'lesson',
      title: 'Human body systems',
      body: 'Short lesson body',
    });

    expect(content.id).toEqual(expect.any(String));
    expect(content.status).toBe('draft');
    expect(content.title).toBe('Human body systems');
  });

  it('queues knowledge uploads for embedding', () => {
    const upload = service.uploadKnowledge({
      title: 'Science syllabus',
      content: 'Approved content for knowledge ingestion and retrieval.',
    });

    expect(upload.estimatedChunks).toBeGreaterThan(0);
    expect(upload.status).toBe('uploaded');
  });

  it('marks knowledge documents for embedding', () => {
    const embedding = service.embedKnowledge('doc-123');

    expect(embedding).toEqual({
      documentId: 'doc-123',
      status: 'embedding_queued',
    });
  });
});