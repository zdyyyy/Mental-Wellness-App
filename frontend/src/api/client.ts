const API_BASE = import.meta.env.VITE_API_URL ?? '';

export type AuthResponse = {
  token: string;
  username: string;
  firstName: string;
  lastName: string;
  mood: string | null;
};

export type Genre = { id: number; name: string; coverUrl: string };
export type Song = {
  id: number;
  title: string;
  artist: string;
  genreId: number;
  url: string;
  coverUrl: string;
};
function getToken(): string | null {
  return localStorage.getItem('mindlift_token');
}

export function setToken(token: string | null) {
  if (token) localStorage.setItem('mindlift_token', token);
  else localStorage.removeItem('mindlift_token');
}

async function request<T>(path: string, options: RequestInit = {}): Promise<T> {
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(options.headers as Record<string, string>),
  };
  const token = getToken();
  if (token) headers.Authorization = `Bearer ${token}`;

  const res = await fetch(`${API_BASE}${path}`, { ...options, headers });
  const data = await res.json().catch(() => ({}));
  if (!res.ok) {
    throw new Error((data as { error?: string }).error ?? 'Request failed');
  }
  return data as T;
}

export const api = {
  signUp: (body: {
    firstName: string;
    lastName: string;
    email: string;
    username: string;
    password: string;
  }) => request<AuthResponse>('/api/auth/signup', { method: 'POST', body: JSON.stringify(body) }),

  login: (body: { username: string; password: string }) =>
    request<AuthResponse>('/api/auth/login', { method: 'POST', body: JSON.stringify(body) }),

  me: () => request<{ username: string; firstName: string; lastName: string; email: string; mood: string | null }>('/api/auth/me'),

  appendDiary: (text: string) =>
    request<{ mood: string }>('/api/diary', { method: 'POST', body: JSON.stringify({ text }) }),

  getDiary: (date: string) => request<{ date: string; content: string }>(`/api/diary?date=${date}`),

  genres: () => request<Genre[]>('/api/music/genres'),

  musicRecommendations: () =>
    request<{ mood: string | null; recommendedGenres: Genre[] }>('/api/music/recommendations'),

  songs: (genreId: number) => request<Song[]>(`/api/music/genres/${genreId}/songs`),

  moodTrend: (days = 30) =>
    request<{
      history: { recordedAt: string; mood: string; source: string }[];
      counts: Record<string, number>;
      currentMood: string | null;
    }>(`/api/mood/trend?days=${days}`),

  moodPredict: () =>
    request<{ predictedMood: string; insight: string; usedAi: boolean }>('/api/mood/predict'),

  chatHistory: () =>
    request<{ messages: { role: string; content: string; createdAt: string }[] }>('/api/chat/history'),

  chatSend: (message: string) =>
    request<{
      reply: string;
      recent: { role: string; content: string; createdAt: string }[];
    }>('/api/chat', { method: 'POST', body: JSON.stringify({ message }) }),
};
