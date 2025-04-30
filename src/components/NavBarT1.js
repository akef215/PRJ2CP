import { Link, useMatch, useNavigate, useResolvedPath } from "react-router-dom";
import Logo from "../images/logo.png";
import Profile from "../images/user.png";
import "./styles/GeneralT1.css";

export default function NavBarT1({ toggleSidebar, type, id }) {
  const navigate = useNavigate();
  return (
    <nav className="nav">
      {/* Logo principal */}

      <Link to="/homePage" className="site-title">
        <img src={Logo} className="logo" alt="ESI Logo" />
      </Link>
      <button
        className="btn-edit"
        onClick={() =>
          navigate(
            type === "Survey" ? `/editSurvey/${id}` : `/editQuiz/${id}`
          )
        }
      >
        Edit info
      </button>

      {/*  Liens vers Notifications et Profile (NE PAS toucher au Sidebar) */}
      <ul>
        <CustomLink to="/profile">
          <img
            src={Profile}
            className="navbar-icon"
            id="icon-end"
            alt="Profile"
          />
        </CustomLink>
      </ul>
    </nav>
  );
}

function CustomLink({ to, children, ...props }) {
  const resolvedPath = useResolvedPath(to);
  const isActive = useMatch({ path: resolvedPath.pathname, end: true });

  return (
    <li className={isActive ? "active" : ""}>
      <Link to={to} {...props}>
        {children}
      </Link>
    </li>
  );
}
