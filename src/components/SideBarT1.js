import React from 'react';
import "./styles/GeneralT1.css";
import Add from '../images/icon-add.png';



function SideBarT1() {
  return (
    <div className="Sidebar">
      <ul className="SidebarList">
        <button className='btn-add'>
          <img src={Add} alt="add"/>
         <p>Add question</p> 
          </button>

        <ul  style={{ paddingLeft: 0 }}> 
            <li className="SidebarItem"><p>1 Question name</p></li>
            <li className="SidebarItem"><p>2 Question name</p></li>
            <li className="SidebarItem"><p>3 Question name</p></li>
            <li className="SidebarItem"><p>4 Question name</p></li>
        </ul>
      </ul>
    </div>
  );
}

export default SideBarT1;
