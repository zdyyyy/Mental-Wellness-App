import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { PageShell } from '../components/Layout';
import { api, Song } from '../api/client';

export default function SongListPage() {
  const { genreId } = useParams();
  const navigate = useNavigate();
  const [songs, setSongs] = useState<Song[]>([]);

  useEffect(() => {
    if (!genreId) return;
    api.songs(Number(genreId)).then(setSongs).catch(console.error);
  }, [genreId]);

  function play(song: Song) {
    sessionStorage.setItem(
      'mindlift_current_song',
      JSON.stringify(song)
    );
    navigate('/player');
  }

  return (
    <PageShell title="Songs" backTo="/music">
      <ul className="song-list">
        {songs.map((song) => (
          <li
            key={song.id}
            className="song-item"
            onClick={() => play(song)}
            onKeyDown={(e) => e.key === 'Enter' && play(song)}
            role="button"
            tabIndex={0}
          >
            <img src={song.coverUrl} alt="" />
            <div>
              <strong>{song.title}</strong>
              <br />
              <span style={{ color: 'var(--muted)', fontSize: '0.9rem' }}>{song.artist}</span>
            </div>
          </li>
        ))}
      </ul>
    </PageShell>
  );
}
