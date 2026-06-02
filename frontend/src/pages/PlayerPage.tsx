import { useMemo } from 'react';
import { Link } from 'react-router-dom';
import { PageShell } from '../components/Layout';
import { Song } from '../api/client';

export default function PlayerPage() {
  const song = useMemo(() => {
    const raw = sessionStorage.getItem('mindlift_current_song');
    return raw ? (JSON.parse(raw) as Song) : null;
  }, []);

  if (!song) {
    return (
      <PageShell title="Player" backTo="/music">
        <p>No song selected.</p>
        <Link to="/music" className="btn">
          Browse music
        </Link>
      </PageShell>
    );
  }

  return (
    <PageShell title={song.title} backTo="/music">
      <img
        src={song.coverUrl}
        alt={song.title}
        style={{ width: '100%', maxWidth: 320, borderRadius: 16, display: 'block', margin: '0 auto' }}
      />
      <p style={{ textAlign: 'center', color: 'var(--muted)' }}>{song.artist}</p>
      <div className="player-bar">
        <audio controls autoPlay src={song.url} style={{ width: '100%' }}>
          Your browser does not support audio playback.
        </audio>
      </div>
    </PageShell>
  );
}
