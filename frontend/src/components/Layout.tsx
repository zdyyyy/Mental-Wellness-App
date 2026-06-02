import { Link } from 'react-router-dom';

export function PageShell({
  title,
  children,
  backTo,
}: {
  title?: string;
  children: React.ReactNode;
  backTo?: string;
}) {
  return (
    <div className="page">
      <div className="page-inner">
        {backTo && (
          <Link to={backTo} className="back-link">
            ← Back
          </Link>
        )}
        {title && <h1 className="page-title">{title}</h1>}
        {children}
      </div>
    </div>
  );
}

export function HomeCard({
  title,
  subtitle,
  to,
}: {
  title: string;
  subtitle: string;
  to: string;
}) {
  return (
    <Link to={to} className="home-card">
      <h3>{title}</h3>
      <p>{subtitle}</p>
    </Link>
  );
}
