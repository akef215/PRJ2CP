import React, { useState } from 'react';
import NavbarT1 from './NavBarT1.js';
import SidebarT1 from './SideBarT1.js';
import './GeneralT1.css';
import Image from '../images/photo1.png' ;
const CreateQuizT2Dis = () => {
  return (
    <div> 
        <NavbarT1 />
      <SidebarT1 />
      <div className='rectangle'>
      <div className="boutons">
        <button className="btn-haut"><p>Time Left</p></button>
        <button className="btn-haut"><p>question mark</p></button>
      </div>

      <div className='insideRectangle'>
        <h1>quiz Questions ?</h1>
        {/* <img src={Image} alt="quiz-qust-pic"></img> */}
      </div>
      <button className="btn-time"><p>Full Quiz Time</p></button>
      </div>
      <button className="btn-back"><p>Go back</p></button>
    
      </div>
  )
}

export default CreateQuizT2Dis