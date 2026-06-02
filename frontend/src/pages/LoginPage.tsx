import { FormEvent, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { PageShell } from '../components/Layout';
import { useAuth } from '../context/AuthContext';

export default function LoginPage() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError('');
    try {
      await login(username, password);
      navigate('/home');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Login failed');
    }
  }

  return (
    <PageShell title="Login" backTo="/">
      <form className="form" onSubmit={handleSubmit}>
        <label>
          Username
          <input value={username} onChange={(e) => setUsername(e.target.value)} required />
        </label>
        <label>
          Password
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </label>
        {error && <p className="error">{error}</p>}
        <button type="submit" className="btn btn-primary btn-block">
          Sign In
        </button>
      </form>
      <p style={{ textAlign: 'center', marginTop: 16 }}>
        Don&apos;t have an account? <Link to="/signup">Sign Up</Link>
      </p>
      <p style={{ textAlign: 'center', marginTop: 8, color: 'var(--muted)', fontSize: '0.85rem' }}>
        Demo: username <strong>demo</strong>, password <strong>demo123</strong>
      </p>
    </PageShell>
  );
}
