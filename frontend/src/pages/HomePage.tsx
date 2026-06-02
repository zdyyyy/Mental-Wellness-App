import { useNavigate } from 'react-router-dom';
import { HomeCard, PageShell } from '../components/Layout';
import { useAuth } from '../context/AuthContext';

export default function HomePage() {
  const { username, mood, logout } = useAuth();
  const navigate = useNavigate();

  return (
    <PageShell>
      <h1 className="hero-title" style={{ fontSize: '2rem' }}>
        Welcome, {username}
      </h1>
      {mood && <span className="mood-badge">Current mood: {mood}</span>}
      <div className="home-grid">
        <HomeCard
          title="Harmony Haven"
          subtitle="Find calmness with music therapy"
          to="/music"
        />
        <HomeCard
          title="Reflections of Resilience"
          subtitle="Embrace healing through journaling"
          to="/diary"
        />
        <HomeCard
          title="MindLift Companion"
          subtitle="Talk with AI for gentle support"
          to="/chat"
        />
        <HomeCard
          title="Mood Insights"
          subtitle="Track your emotional patterns and forecast"
          to="/mood"
        />
      </div>
      <div className="center-actions">
        <button
          type="button"
          className="btn"
          onClick={() => {
            logout();
            navigate('/login');
          }}
        >
          Sign Out
        </button>
      </div>
    </PageShell>
  );
}
