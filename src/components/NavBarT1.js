import { Link, useMatch, useResolvedPath } from 'react-router-dom';

import Logo from '../images/logo.png';
import Notif from '../images/notif.png';
import Profile from '../images/user.png';
import './GeneralT1.css' ;

export default function NavBarT1({ toggleSidebar }) {
  return (
    <nav className="nav">
     

      {/* Logo principal */}
      <Link to="/home" className="site-title">
        <img src={Logo} className="logo" id="esi" alt="ESI Logo" />
      </Link>
      <button className='btn-edit'>Edit info</button>

      {/*  Liens vers Notifications et Profile (NE PAS toucher au Sidebar) */}
      <ul>
        <CustomLink to="/notifications">
          <img src={Notif} className="navbar-icon" id="icon-end" alt="Notifications" />
        </CustomLink>
        <CustomLink to="/profile">
          <img src={Profile} className="navbar-icon" id="icon-end" alt="Profile" />
        </CustomLink>
      </ul>
    </nav>
  );
}

function CustomLink({ to, children, ...props }) {
  const resolvedPath = useResolvedPath(to);
  const isActive = useMatch({ path: resolvedPath.pathname, end: true });

  return (
    <li className={isActive ? 'active' : ''}>
      <Link to={to} {...props}>{children}</Link>
    </li>
  );
}
