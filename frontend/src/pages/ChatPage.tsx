import { FormEvent, useEffect, useRef, useState } from 'react';
import { PageShell } from '../components/Layout';
import { api } from '../api/client';
import { useAuth } from '../context/AuthContext';

type Msg = { role: string; content: string; createdAt: string };

export default function ChatPage() {
  const { refreshProfile } = useAuth();
  const [messages, setMessages] = useState<Msg[]>([]);
  const [input, setInput] = useState('');
  const [sending, setSending] = useState(false);
  const [error, setError] = useState('');
  const bottomRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    api.chatHistory().then((r) => setMessages(r.messages)).catch(console.error);
  }, []);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  async function handleSend(e: FormEvent) {
    e.preventDefault();
    const text = input.trim();
    if (!text || sending) return;
    setInput('');
    setSending(true);
    setError('');
    const optimistic: Msg = {
      role: 'user',
      content: text,
      createdAt: new Date().toISOString(),
    };
    setMessages((prev) => [...prev, optimistic]);
    try {
      const res = await api.chatSend(text);
      setMessages(res.recent);
      await refreshProfile();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Send failed');
    } finally {
      setSending(false);
    }
  }

  return (
    <PageShell title="MindLift Companion" backTo="/home">
      <p style={{ color: 'var(--muted)', marginBottom: 12 }}>
        A supportive space to talk. Not a substitute for professional care.
      </p>
      <div className="chat-window">
        {messages.length === 0 && (
          <p className="chat-empty">Say hello. I am here to listen.</p>
        )}
        {messages.map((m, i) => (
          <div key={`${m.createdAt}-${i}`} className={`chat-bubble chat-${m.role}`}>
            {m.content}
          </div>
        ))}
        <div ref={bottomRef} />
      </div>
      {error && <p className="error">{error}</p>}
      <form className="chat-form" onSubmit={handleSend}>
        <textarea
          rows={2}
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Share what is on your mind..."
          disabled={sending}
        />
        <button type="submit" className="btn btn-primary" disabled={sending}>
          {sending ? 'Sending...' : 'Send'}
        </button>
      </form>
    </PageShell>
  );
}
