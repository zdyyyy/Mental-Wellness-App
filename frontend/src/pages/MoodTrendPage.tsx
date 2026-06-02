import { useEffect, useState } from 'react';
import { PageShell } from '../components/Layout';
import { api } from '../api/client';

const MOOD_COLORS: Record<string, string> = {
  happy: '#38bdf8',
  sad: '#818cf8',
  fear: '#fbbf24',
  angry: '#f87171',
};

export default function MoodTrendPage() {
  const [history, setHistory] = useState<{ recordedAt: string; mood: string; source: string }[]>([]);
  const [counts, setCounts] = useState<Record<string, number>>({});
  const [currentMood, setCurrentMood] = useState<string | null>(null);
  const [predicted, setPredicted] = useState<string | null>(null);
  const [insight, setInsight] = useState('');
  const [usedAi, setUsedAi] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([api.moodTrend(30), api.moodPredict()])
      .then(([trend, predict]) => {
        setHistory(trend.history);
        setCounts(trend.counts);
        setCurrentMood(trend.currentMood);
        setPredicted(predict.predictedMood);
        setInsight(predict.insight);
        setUsedAi(predict.usedAi);
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  const maxCount = Math.max(1, ...Object.values(counts));

  return (
    <PageShell title="Mood Insights" backTo="/home">
      {loading ? (
        <p>Loading...</p>
      ) : (
        <>
          {currentMood && (
            <p style={{ marginBottom: 16 }}>
              Current mood: <span className="mood-badge">{currentMood}</span>
            </p>
          )}

          {predicted && (
            <div className="insight-card">
              <h2 className="section-title">Tomorrow&apos;s forecast</h2>
              <p>
                Predicted mood: <strong>{predicted}</strong>
                {usedAi ? ' (AI)' : ' (pattern-based)'}
              </p>
              <p style={{ color: 'var(--muted)', marginTop: 8 }}>{insight}</p>
            </div>
          )}

          <h2 className="section-title" style={{ marginTop: 24 }}>
            Last 30 days
          </h2>
          {history.length === 0 ? (
            <p style={{ color: 'var(--muted)' }}>
              No mood records yet. Write diary entries or chat with MindLift companion.
            </p>
          ) : (
            <div className="mood-chart">
              {history.map((point, i) => (
                <div
                  key={`${point.recordedAt}-${i}`}
                  className="mood-bar-wrap"
                  title={`${point.mood} (${point.source})`}
                >
                  <div
                    className="mood-bar"
                    style={{
                      height: `${40 + (counts[point.mood] ?? 1) * (60 / maxCount)}px`,
                      background: MOOD_COLORS[point.mood] ?? '#94a3b8',
                    }}
                  />
                  <span className="mood-bar-label">{point.mood.slice(0, 1)}</span>
                </div>
              ))}
            </div>
          )}

          <div className="mood-legend" style={{ marginTop: 24 }}>
            {Object.entries(counts).map(([mood, count]) => (
              <span
                key={mood}
                className="mood-badge"
                style={{ background: MOOD_COLORS[mood], marginRight: 8 }}
              >
                {mood}: {count}
              </span>
            ))}
          </div>
        </>
      )}
    </PageShell>
  );
}
