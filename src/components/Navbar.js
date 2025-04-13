import { Link, useMatch, useResolvedPath } from "react-router-dom";
import LList from "../images/Rectangle 8.png";
import Quiz from "../images/QUIZ.png";
import Esi from "../images/logo.png";
import Notif from "../images/notif.png";
import Profile from "../images/user.png";
import "./General.css";

export default function Navbar({ toggleSidebar }) {
  return (
    <div className="nav">
      {/* Bouton Sidebar */}
      <button
        onClick={toggleSidebar}
        className="sidebar-toggle"
        aria-label="Toggle Sidebar"
      >
        <img src={LList} className="navbar-icon" alt="Toggle Sidebar" />
      </button>

      {/* Logo et Titre */}
      <div className="nav-center">
        <img src={Esi} className="logo-esi" alt="ESI Logo" />
        <Link to="/homepage" className="site-title">
          <img src={Quiz} className="quiz-logo" alt="Quiz Logo" />
        </Link>
      </div>

      {/* Icônes de Notifications et Profil */}
      <ul className="nav-icons">
        <CustomLink to="/notifications">
          <img src={Notif} className="icon-end" alt="Notifications" />
        </CustomLink>
        <CustomLink to="/profile">
          <img src={Profile} className="icon-end" alt="Profile" />
        </CustomLink>
      </ul>
    </div>
  );
}

function CustomLink({ to, children, ...props }) {
  const resolvedPath = useResolvedPath(to);
  const isActive = useMatch({ path: resolvedPath.pathname, end: true });

  return (
    <li className={isActive ? "active" : ""}>
      <Link to={to} {...props}>{children}</Link>
    </li>
  );
}
