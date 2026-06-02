import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { PageShell } from '../components/Layout';
import { api, Genre } from '../api/client';
import { useAuth } from '../context/AuthContext';

function GenreGrid({ genres }: { genres: Genre[] }) {
  return (
    <div className="genre-grid">
      {genres.map((g) => (
        <Link key={g.id} to={`/music/${g.id}`} className="genre-card home-card">
          <img src={g.coverUrl} alt={g.name} />
          <h3>{g.name}</h3>
        </Link>
      ))}
    </div>
  );
}

export default function MusicPage() {
  const { refreshProfile } = useAuth();
  const [genres, setGenres] = useState<Genre[]>([]);
  const [recommended, setRecommended] = useState<Genre[]>([]);
  const [recMood, setRecMood] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    async function load() {
      try {
        await refreshProfile();
        const [allGenres, rec] = await Promise.all([api.genres(), api.musicRecommendations()]);
        if (cancelled) return;
        setGenres(allGenres);
        setRecMood(rec.mood);
        setRecommended(rec.recommendedGenres);
      } catch (err) {
        console.error(err);
      }
    }
    load();
    return () => {
      cancelled = true;
    };
  }, [refreshProfile]);

  const recommendedIds = new Set(recommended.map((g) => g.id));
  const otherGenres = genres.filter((g) => !recommendedIds.has(g.id));

  return (
    <PageShell title="Music Therapy" backTo="/home">
      {recMood && recommended.length > 0 ? (
        <section style={{ marginBottom: 32 }}>
          <h2 className="section-title">Suggested Genre For You</h2>
          <p style={{ color: 'var(--muted)', marginBottom: 12 }}>
            Based on your diary mood: <span className="mood-badge">{recMood}</span>
          </p>
          <GenreGrid genres={recommended} />
        </section>
      ) : recMood ? (
        <p style={{ color: 'var(--muted)', marginBottom: 24 }}>
          No suggestions for mood &quot;{recMood}&quot;. Write a diary entry or browse all genres below.
        </p>
      ) : (
        <p style={{ color: 'var(--muted)', marginBottom: 24 }}>
          No mood detected yet. Add a diary entry first to get personalized recommendations.
        </p>
      )}

      <section>
        <h2 className="section-title">Something Else On Your Mind?</h2>
        <GenreGrid genres={otherGenres.length > 0 ? otherGenres : genres} />
      </section>
    </PageShell>
  );
}
