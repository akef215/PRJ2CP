import { useLocation } from 'react-router-dom';
import Navbar from './Navbar';
import Sidebar from './Sidebar';
import './styles/Select.css';
import './styles/General.css';
import { useState, useMemo } from 'react';

const Layout = ({ children }) => {
  const location = useLocation();
  const [isSidebarVisible, setIsSidebarVisible] = useState(false);

  //  Déterminer si on cache la Navbar et la Sidebar
  const hideNavAndSidebar = useMemo(() => (
    ["/login", "/recover", "/new-account" , "/createQuizT1" , "/Homepage" , "/statsPie" , "/statsLine" , "/stats" , "/feedBackView" , "/feedIndiv" , "/CreateT2Pic"].includes(location.pathname)
  ), [location.pathname]);

  // ✅ Fonction pour basculer le Sidebar (uniquement pour le bouton Rectangle)
  const handleSidebarToggle = () => {
    setIsSidebarVisible((prev) => !prev);
  };

  return (
    <div>
      {!hideNavAndSidebar && (
        <Navbar toggleSidebar={handleSidebarToggle} />
      )}

      <main style={{ position: 'relative', zIndex: 1, paddingBottom: '10px' }}>{children}</main>

      {/* ✅ Afficher le Sidebar uniquement quand isSidebarVisible est true */}
      {!hideNavAndSidebar && isSidebarVisible && <Sidebar />}
      
    </div>
  );
};

export default Layout;
