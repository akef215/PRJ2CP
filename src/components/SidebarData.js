import React from "react";
import HomeIcon from "../images/home.png";
import calendarIcon from "../images/calendar.png";
import nextIcon from "../images/right-arrow.png";
import saveIcon from "../images/save-file.png";
import setIcon from "../images/setting.png";
import statsIcon from "../images/stats.png";
import plusIcon from "../images/add.png";
import classIcon from "../images/class.png"; // Correction du nom

export const SidebarData = [
    {
        title: "Home",
        icon: <img src={HomeIcon} className="sidebar-icon" alt="Home" />,
        link: "/homepage",
    },
    {
        title: "Calendar",
        icon: <img src={calendarIcon} className="sidebar-icon" alt="Calendar" />,
        link: "/calendar",
    },
    {
        title: "Show Classes",
        icon: <img src={nextIcon} className="sidebar-icon" alt="Show Classes" />,
        link: "#",
        subMenu: [
            {
                icon: <img src={classIcon} className="sidebar-icon" alt="Class" />,
                title: "Class 1",
               
            },
            {
                icon: <img src={classIcon} className="sidebar-icon" alt="Class" />,
                title: "Class 2",
              
            },
            {
                icon: <img src={classIcon} className="sidebar-icon" alt="Class" />,
                title: "Class 3",
               
            }
        ]
    },
    {
        title: "Archive",
        icon: <img src={saveIcon} className="sidebar-icon" alt="Archive" />,
        link: "/archive",
    },
    {
        title: "Settings",
        icon: <img src={setIcon} className="sidebar-icon" alt="Settings" />,
        link: "/settings",
    },
    {
        title: "Statistics",
        icon: <img src={statsIcon} className="sidebar-icon" alt="Statistics" />,
        link: "/stats",
    },
    {
        title: "Create",
        icon: <img src={plusIcon} className="sidebar-icon" alt="Create" />,
        link: "/select",
    }
];
