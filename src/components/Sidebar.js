import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import "./styles/General.css";

import HomeIcon from "../images/home.png";
import nextIcon from "../images/right-arrow.png";
import statsIcon from "../images/stats.png";
import plusIcon from "../images/add.png";
import moduleIcon from "../images/module.png";
import classIcon from "../images/class.png";

function Sidebar() {
  const navigate = useNavigate();
  const [openMenu, setOpenMenu] = useState(null);
  const [classes, setClasses] = useState([]);
  const API_URL = process.env.REACT_APP_API_URL;
  console.log(API_URL)

  useEffect(() => {
    fetch(`${API_URL}/teachers/groupes`)
      .then((res) => res.json())
      .then((data) => setClasses(data))
      .catch((err) => console.error(err));
  }, []);

  const sidebarData = [
    {
      title: "Home",
      icon: <img src={HomeIcon} className="sidebar-icon" alt="Home" />,
      link: "/homepage",
    },
    {
      title: "Classes",
      icon: <img src={nextIcon} className="sidebar-icon" alt="Show Classes" />,
      link: "/classesPage",
      subMenu: classes.map((cls) => ({
        icon: <img src={classIcon} className="sidebar-icon" alt="Class" />,
        title: cls.id,
        link: `/students/${cls.id}`, // lien dynamique
      })),
    },
    {
      title: "Modules",
      icon: <img src={moduleIcon} className="sidebar-icon" alt="Modules" />,
      link: "/module",
    },
    {
      title: "Statistics",
      icon: <img src={statsIcon} className="sidebar-icon" alt="Statistics" />,
      link: "/statsLine",
    },
    {
      title: "Create",
      icon: <img src={plusIcon} className="sidebar-icon" alt="Create" />,
      link: "/select",
    },
  ];

  const handleToggle = (index) => {
    setOpenMenu(openMenu === index ? null : index);
  };

  return (
    <div className="Sidebar">
      <ul className="SidebarList">
        {sidebarData.map((val, key) => (
          <div key={key}>
            <li
              className={`row ${val.subMenu ? "has-submenu" : ""} ${openMenu === key ? "open" : ""}`}
              onClick={() => val.subMenu ? handleToggle(key) : navigate(val.link)}
            >
              <div className="icon">{val.icon}</div>
              <div className="icon">{val.title}</div>
            </li>

            {val.subMenu && openMenu === key && (
              <ul className="subMenu">
                {val.subMenu.map((subItem, subKey) => (
                  <li 
                    key={subKey} 
                    className="row submenu-item"
                    onClick={() => {navigate(subItem.link); window.location.reload();}}
                  >
                    <div className="icon">{subItem.icon}</div>
                    <div className="icon">{subItem.title}</div>
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
