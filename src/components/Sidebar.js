import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./styles/General.css";
import { SidebarData } from "./SidebarData";

function Sidebar() {
  const navigate = useNavigate();
  const [openMenu, setOpenMenu] = useState(null);

  const handleToggle = (index) => {
    setOpenMenu(openMenu === index ? null : index);
  };

  return (
    <div className="Sidebar">
      <ul className="SidebarList">
        {SidebarData.map((val, key) => (
          <div key={key}>
            {/* Élément principal */}
            <li
              className={`row ${val.subMenu ? "has-submenu" : ""} ${openMenu === key ? "open" : ""}`}
              onClick={() => val.subMenu ? handleToggle(key) : navigate(val.link)}
            >
              <div className="icon">{val.icon}</div>
              
            </li>

            {/* Sous-menu */}
            {val.subMenu && openMenu === key && (
              <ul className="subMenu">
                {val.subMenu.map((subItem, subKey) => (
                  <li 
                    key={subKey} 
                    className="row submenu-item"
                    onClick={() => navigate(subItem.link)}
                  >
                    <div className="icon">{subItem.icon}</div>
                    <div className="title">{subItem.title}</div>
                    title
                  </li>
                ))}
              </ul>
            )}
          </div>
        ))}
      </ul>
    </div>
  );
}

export default Sidebar;
