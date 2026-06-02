import { Navigate, Route, Routes } from 'react-router-dom';
import { useAuth } from './context/AuthContext';
import EntryPage from './pages/EntryPage';
import LoginPage from './pages/LoginPage';
import SignUpPage from './pages/SignUpPage';
import HomePage from './pages/HomePage';
import DiaryPage from './pages/DiaryPage';
import ViewDiaryPage from './pages/ViewDiaryPage';
import MusicPage from './pages/MusicPage';
import SongListPage from './pages/SongListPage';
import PlayerPage from './pages/PlayerPage';
import MoodTrendPage from './pages/MoodTrendPage';
import ChatPage from './pages/ChatPage';

function PrivateRoute({ children }: { children: React.ReactNode }) {
  const { username, loading } = useAuth();
  if (loading) return <div className="page center">Loading...</div>;
  if (!username) return <Navigate to="/login" replace />;
  return <>{children}</>;
}

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<EntryPage />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/signup" element={<SignUpPage />} />
      <Route
        path="/home"
        element={
          <PrivateRoute>
            <HomePage />
          </PrivateRoute>
        }
      />
      <Route
        path="/diary"
        element={
          <PrivateRoute>
            <DiaryPage />
          </PrivateRoute>
        }
      />
      <Route
        path="/diary/view"
        element={
          <PrivateRoute>
            <ViewDiaryPage />
          </PrivateRoute>
        }
      />
      <Route
        path="/music"
        element={
          <PrivateRoute>
            <MusicPage />
          </PrivateRoute>
        }
      />
      <Route
        path="/music/:genreId"
        element={
          <PrivateRoute>
            <SongListPage />
          </PrivateRoute>
        }
      />
      <Route
        path="/player"
        element={
          <PrivateRoute>
            <PlayerPage />
          </PrivateRoute>
        }
      />
      <Route
        path="/mood"
        element={
          <PrivateRoute>
            <MoodTrendPage />
          </PrivateRoute>
        }
      />
      <Route
        path="/chat"
        element={
          <PrivateRoute>
            <ChatPage />
          </PrivateRoute>
        }
      />
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}
