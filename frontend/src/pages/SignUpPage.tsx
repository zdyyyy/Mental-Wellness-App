import { FormEvent, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { PageShell } from '../components/Layout';
import { useAuth } from '../context/AuthContext';

export default function SignUpPage() {
  const { signUp } = useAuth();
  const navigate = useNavigate();
  const [form, setForm] = useState({
    firstName: '',
    lastName: '',
    email: '',
    username: '',
    password: '',
  });
  const [error, setError] = useState('');

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError('');
    try {
      await signUp(form);
      navigate('/home');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Sign up failed');
    }
  }

  return (
    <PageShell title="Sign Up" backTo="/login">
      <form className="form" onSubmit={handleSubmit}>
        {(['firstName', 'lastName', 'email', 'username', 'password'] as const).map((field) => (
          <label key={field}>
            {field === 'firstName'
              ? 'First Name'
              : field === 'lastName'
                ? 'Last Name'
                : field.charAt(0).toUpperCase() + field.slice(1)}
            <input
              type={field === 'password' ? 'password' : field === 'email' ? 'email' : 'text'}
              value={form[field]}
              onChange={(e) => setForm({ ...form, [field]: e.target.value })}
              required
            />
          </label>
        ))}
        {error && <p className="error">{error}</p>}
        <button type="submit" className="btn btn-primary btn-block">
          Sign Up
        </button>
      </form>
      <p style={{ textAlign: 'center', marginTop: 16 }}>
        Already have an account? <Link to="/login">Sign In</Link>
      </p>
    </PageShell>
  );
}
