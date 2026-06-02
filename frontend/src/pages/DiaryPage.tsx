import { useState } from 'react';
import { Link } from 'react-router-dom';
import { PageShell } from '../components/Layout';
import { api } from '../api/client';
import { useAuth } from '../context/AuthContext';

export default function DiaryPage() {
  const { refreshProfile } = useAuth();
  const [listening, setListening] = useState(false);
  const [status, setStatus] = useState('');
  const [textInput, setTextInput] = useState('');

  const SpeechRecognition =
    (window as unknown as { SpeechRecognition?: typeof window.webkitSpeechRecognition })
      .SpeechRecognition || window.webkitSpeechRecognition;

  async function saveEntry(text: string) {
    if (!text.trim()) return;
    setStatus('Saving...');
    try {
      const res = await api.appendDiary(text.trim());
      await refreshProfile();
      setStatus(`Saved! Detected mood: ${res.mood}`);
      setTextInput('');
    } catch (err) {
      setStatus(err instanceof Error ? err.message : 'Failed to save');
    }
  }

  function startListening() {
    if (!SpeechRecognition) {
      setStatus('Speech recognition is not supported in this browser. Type your thoughts below.');
      return;
    }
    const recognition = new SpeechRecognition();
    recognition.lang = 'en-US';
    recognition.interimResults = false;
    recognition.onstart = () => setListening(true);
    recognition.onend = () => setListening(false);
    recognition.onerror = () => {
      setListening(false);
      setStatus('Could not capture speech. Try typing instead.');
    };
    recognition.onresult = (event: SpeechRecognitionEvent) => {
      const text = event.results[0][0].transcript;
      setTextInput(text);
      saveEntry(text);
    };
    recognition.start();
  }

  return (
    <PageShell title="Diary" backTo="/home">
      <p style={{ color: 'var(--muted)' }}>Speak or type your thoughts</p>
      <button
        type="button"
        className={`mic-btn ${listening ? 'listening' : ''}`}
        onClick={startListening}
        aria-label="Start microphone"
      >
        🎤
      </button>
      <form
        className="form"
        style={{ maxWidth: '100%' }}
        onSubmit={(e) => {
          e.preventDefault();
          saveEntry(textInput);
        }}
      >
        <label>
          Or type here
          <textarea
            rows={4}
            value={textInput}
            onChange={(e) => setTextInput(e.target.value)}
            placeholder="How are you feeling today?"
          />
        </label>
        <button type="submit" className="btn btn-primary">
          Save entry
        </button>
      </form>
      {status && <p style={{ marginTop: 12 }}>{status}</p>}
      <div className="center-actions">
        <Link to="/diary/view" className="btn">
          View my diary
        </Link>
      </div>
    </PageShell>
  );
}
