import { Link, useMatch, useResolvedPath } from "react-router-dom";
import LList from "../images/Rectangle 8.png";
import Esi from "../images/logo.png";
import Profile from "../images/user.png";
import "./styles/General.css";

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
      <ul className="nav-icons">
      {/* Logo et Titre */}
        <CustomLink to='/HomePage'>
          <img src={Esi} className="logoNavBar" alt="ESI Logo" />
        </CustomLink>
      {/* Icônes de Profil */}
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
