import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { PageShell } from '../components/Layout';
import { api } from '../api/client';

export default function ViewDiaryPage() {
  const [date, setDate] = useState(() => new Date().toISOString().slice(0, 10));
  const [content, setContent] = useState('Select a date to view diary notes');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
    api
      .getDiary(date)
      .then((res) => setContent(res.content))
      .catch(() => setContent('Could not load diary'))
      .finally(() => setLoading(false));
  }, [date]);

  return (
    <PageShell title="My Diary" backTo="/diary">
      <label>
        Date
        <input type="date" value={date} onChange={(e) => setDate(e.target.value)} />
      </label>
      <p style={{ margin: '16px 0', color: 'var(--muted)' }}>
        {loading ? 'Loading...' : `Notes for ${date}`}
      </p>
      <div className="diary-text">{content}</div>
      <div className="center-actions">
        <Link to="/diary" className="btn">
          Make a new entry
        </Link>
        <Link to="/home" className="btn">
          Home
        </Link>
      </div>
    </PageShell>
  );
}
