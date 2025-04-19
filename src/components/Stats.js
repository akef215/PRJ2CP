import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './styles/Stats.css'; 
import logo from '../images/logo _final.png';
import img1 from '../images/Frame_5.png';
import img2 from '../images/Frame_5.png';
import img3 from '../images/Frame_5.png';

const Stats = () => {
  const navigate = useNavigate();
  return (
    <div>
      {/* Barre de navigation */}
      <div className='Nav'>
        <div className='Nav-Logo'>
          <img src={logo} alt='Logo'/>
        </div>
       <div className='Nav-Menu'>
        <p onClick={() => {navigate("../homepage")}} className={'nav-item'}>home</p>
        <p onClick={() => {navigate("../stats")}} className={'nav-item active'}>stats</p>
        <p onClick={() => {navigate("../pageType2")}} className={'nav-item'}>Present</p>
        <p onClick={() => {navigate("../profile")}} className={'nav-item'}>Profile</p>
        </div>
      </div>
      
      {/* Conteneur principal des stats */}
      <div className="Stats-Container">

        {/* --- SVG en arrière-plan pour dessiner les flèches --- */}
        <svg className="bg-arrows" viewBox="0 0 1200 300" preserveAspectRatio="none">
          <defs>
            {/* Définit un "marker" pour la pointe de flèche */}
            <marker id="arrowhead" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto">
              <path d="M0,0 L0,8 L8,4 Z" fill="#48a9e6" />
            </marker>
          </defs>
          
          {/* Flèche qui relie la première carte à la deuxième (à ajuster) */}
          <path
            d="M 320,150 
               C 420,50 
                 520,250 
                 620,150"
            stroke="rgba(170, 207, 215, 1)"
            strokeWidth="3"
            fill="none"
            markerEnd="url(#arrowhead)"
          />
          
          {/* Flèche qui relie la deuxième carte à la troisième (à ajuster) */}
          <path
            d="M 670,150 
               C 770,50 
                 870,250 
                 970,150"
            stroke="rgba(170, 207, 215, 1)"
            strokeWidth="3"
            fill="none"
            markerEnd="url(#arrowhead)"
          />
        </svg>
        {/* --- Fin du SVG --- */}

        {/* 1ère colonne */}
        <div className="Column">
          <div className='img-pic'>
            <img src={img1} alt='Pic' />
          </div>
          <div className='Rec-1'>
            <div className='title'>
              <p>Students stats</p>
            </div>
            <div className='par'>
              <p>Check your individual student's progress and understand their progress overtime</p>
            </div>
          </div>
        </div>

        {/* 2ème colonne */}
        <div className="Column">
          <div className='img-pic'>
            <img src={img2} alt='Pic' />
          </div>
          <div className='Rec-2'>
            <div className='title'>
              <p>General classes stats</p>
            </div>
            <div className='par'>
              <p>View your quiz And survey's results individually and understand your Students' weaknesses</p>
            </div>
          </div>
        </div>

        {/* 3ème colonne */}
        <div className="Column">
          <div className='img-pic'>
            <img src={img3} alt='Pic' />
          </div>
          <div className='Rec-3'>
            <div className='title'>
              <p>Survey and quiz Stats</p>
            </div>
            <div className='par'>
              <p>View your quiz And survey's results individually and understand your Students' weaknesses</p>
            </div>
          </div>
        </div>

      </div>
    </div>
  )
}

export default Stats;
