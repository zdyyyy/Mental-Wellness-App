import { Link } from 'react-router-dom';
import { PageShell } from '../components/Layout';

export default function EntryPage() {
  return (
    <PageShell>
      <div className="center-actions" style={{ minHeight: '70vh', justifyContent: 'center' }}>
        <h1 className="hero-title">Mind Lift</h1>
        <Link to="/login" className="btn">
          Dive Into Mental Calmness
        </Link>
      </div>
    </PageShell>
  );
}
