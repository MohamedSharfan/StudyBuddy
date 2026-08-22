import {
  curriculumHealth,
  knowledgeJobs,
  launchSignals,
  metrics,
  publicationQueue,
  releaseChecklist,
  subjects,
  workflowQueue,
} from '@/lib/seed';

export default function AdminDashboard() {
  return (
    <main className="adminShell">
      <div className="glow glowOne" />
      <div className="glow glowTwo" />

      <aside className="sidebar">
        <div className="brand">
          <span className="brandMark">SB</span>
          <div>
            <strong>StudyBuddy</strong>
            <small>Phase 6 Admin CMS</small>
          </div>
        </div>

        <div className="statusCard">
          <span className="statusDot" />
          Live publishing mode
          <small>AI knowledge sync and curriculum reviews are active.</small>
        </div>

        <nav>
          {['Dashboard', 'Subjects', 'Lessons', 'Flashcards', 'Quizzes', 'AI Knowledge', 'Analytics'].map((item) => (
            <a className={item === 'Dashboard' ? 'active' : ''} href="#" key={item}>
              {item}
            </a>
          ))}
        </nav>

        <button className="sidebarButton">Sync embeddings</button>
      </aside>

      <section className="workspace">
        <header className="hero">
          <div className="heroCopy">
            <p className="eyebrow">Tamil Medium O/L</p>
            <h1>Content command center for a real learning startup.</h1>
            <p>
              Publish syllabus content, tune AI Panda knowledge, and keep the curriculum pipeline moving
              with audit-friendly release gates.
            </p>
            <div className="heroActions">
              <button>Publish lesson pack</button>
              <button className="ghost">Open AI knowledge queue</button>
            </div>
          </div>

          <div className="heroPanel">
            <div className="heroPanelTop">
              <span className="eyebrow">Launch status</span>
              <strong>98.4%</strong>
            </div>
            <p>Curriculum ready for the next mobile release.</p>
            <div className="heroMeter">
              <span />
            </div>
            <small>Content QA, embeddings, and reward economy checks are all in range.</small>
          </div>
        </header>

        <section className="metrics wideMetrics">
          {metrics.map((metric, index) => (
            <article className="metricCard" key={metric.label} style={{ animationDelay: `${index * 80}ms` }}>
              <span>{metric.label}</span>
              <strong>{metric.value}</strong>
              <small>{metric.trend} this month</small>
            </article>
          ))}
        </section>

        <section className="signalsRow">
          {launchSignals.map((signal) => (
            <article className="signalCard" key={signal.label}>
              <span>{signal.label}</span>
              <strong>{signal.value}</strong>
              <small>{signal.trend}</small>
            </article>
          ))}
        </section>

        <section className="grid">
          <article className="panel wide">
            <div className="panelHeader">
              <div>
                <p className="eyebrow">CMS</p>
                <h2>Subject publishing</h2>
              </div>
              <button className="ghost">New subject</button>
            </div>
            <table>
              <thead>
                <tr>
                  <th>Subject</th>
                  <th>Medium</th>
                  <th>Chapters</th>
                  <th>Lessons</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {subjects.map((subject) => (
                  <tr key={subject.name}>
                    <td>{subject.name}</td>
                    <td>{subject.medium}</td>
                    <td>{subject.chapters}</td>
                    <td>{subject.lessons}</td>
                    <td>
                      <span className={`status ${subject.status.toLowerCase()}`}>{subject.status}</span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </article>

          <article className="panel">
            <p className="eyebrow">AI Panda</p>
            <h2>Knowledge base</h2>
            <div className="uploadBox">
              <span>PDF</span>
              <strong>Drop syllabus or paper files</strong>
              <small>Embeddings run on the backend with pgvector indexing.</small>
            </div>
            <div className="jobList">
              {knowledgeJobs.map((job) => (
                <div className="job" key={job.title}>
                  <div>
                    <strong>{job.title}</strong>
                    <small>{job.chunks} chunks</small>
                  </div>
                  <span>{job.status}</span>
                </div>
              ))}
            </div>
          </article>
        </section>

        <section className="lowerGrid">
          <article className="panel">
            <div className="panelHeader">
              <div>
                <p className="eyebrow">Quality Gate</p>
                <h2>Before publishing</h2>
              </div>
              <button className="ghost">Publish pack</button>
            </div>
            <div className="checks">
              {releaseChecklist.map((item, index) => (
                <label key={item}>
                  <input type="checkbox" defaultChecked={index < 4} />
                  {item}
                </label>
              ))}
            </div>
          </article>

          <article className="panel">
            <div className="panelHeader">
              <div>
                <p className="eyebrow">Learning Ops</p>
                <h2>Publication queue</h2>
              </div>
              <button className="ghost">Manage queue</button>
            </div>
            <div className="jobList">
              {publicationQueue.map((item) => (
                <div className="job queueJob" key={item.title}>
                  <div>
                    <strong>{item.title}</strong>
                    <small>{item.owner}</small>
                  </div>
                  <span>{item.status}</span>
                </div>
              ))}
            </div>
          </article>

          <article className="panel">
            <div className="panelHeader">
              <div>
                <p className="eyebrow">Curriculum Health</p>
                <h2>Release readiness</h2>
              </div>
              <button className="ghost">Export report</button>
            </div>
            <div className="healthList">
              {curriculumHealth.map((item) => (
                <div className="healthRow" key={item.subject}>
                  <div>
                    <strong>{item.subject}</strong>
                    <small>
                      {item.published} of {item.chapters} chapters published
                    </small>
                  </div>
                  <span>{item.status}</span>
                </div>
              ))}
            </div>
          </article>

          <article className="panel">
            <div className="panelHeader">
              <div>
                <p className="eyebrow">Workflow</p>
                <h2>AI and editorial queue</h2>
              </div>
              <button className="ghost">Open task board</button>
            </div>
            <div className="jobList">
              {workflowQueue.map((item) => (
                <div className="job queueJob" key={item.title}>
                  <div>
                    <strong>{item.title}</strong>
                    <small>
                      {item.stage} · {item.owner}
                    </small>
                  </div>
                  <span>{item.due}</span>
                </div>
              ))}
            </div>
          </article>
        </section>

        <section className="panel roadmap">
          <div>
            <p className="eyebrow">Gamification Ops</p>
            <h2>Reward economy sanity check</h2>
          </div>
          <div className="checks">
            {['Coins unlock cosmetics only', 'Streak rewards feel generous', 'Rank thresholds are balanced', 'No academic advantage'].map(
              (item, index) => (
                <label key={item}>
                  <input type="checkbox" defaultChecked={index !== 3} />
                  {item}
                </label>
              ),
            )}
          </div>
        </section>
      </section>
    </main>
  );
}
