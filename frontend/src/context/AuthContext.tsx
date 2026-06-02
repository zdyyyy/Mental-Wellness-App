import { createContext, useContext, useEffect, useState, ReactNode } from 'react';
import { api, AuthResponse, setToken } from '../api/client';

type AuthState = {
  username: string | null;
  firstName: string | null;
  lastName: string | null;
  mood: string | null;
  loading: boolean;
  login: (username: string, password: string) => Promise<void>;
  signUp: (data: {
    firstName: string;
    lastName: string;
    email: string;
    username: string;
    password: string;
  }) => Promise<void>;
  logout: () => void;
  refreshProfile: () => Promise<void>;
};

const AuthContext = createContext<AuthState | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [username, setUsername] = useState<string | null>(null);
  const [firstName, setFirstName] = useState<string | null>(null);
  const [lastName, setLastName] = useState<string | null>(null);
  const [mood, setMood] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  function applyAuth(data: AuthResponse) {
    setToken(data.token);
    setUsername(data.username);
    setFirstName(data.firstName);
    setLastName(data.lastName);
    setMood(data.mood);
    setLoading(false);
  }

  useEffect(() => {
    const token = localStorage.getItem('mindlift_token');
    if (!token) {
      setLoading(false);
      return;
    }
    api
      .me()
      .then((p) => {
        setUsername(p.username);
        setFirstName(p.firstName);
        setLastName(p.lastName);
        setMood(p.mood);
      })
      .catch(() => setToken(null))
      .finally(() => setLoading(false));
  }, []);

  const value: AuthState = {
    username,
    firstName,
    lastName,
    mood,
    loading,
    login: async (u, p) => {
      const data = await api.login({ username: u, password: p });
      applyAuth(data);
    },
    signUp: async (data) => {
      const res = await api.signUp(data);
      applyAuth(res);
    },
    logout: () => {
      setToken(null);
      setUsername(null);
      setFirstName(null);
      setLastName(null);
      setMood(null);
    },
    refreshProfile: async () => {
      const p = await api.me();
      setMood(p.mood);
    },
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
}
