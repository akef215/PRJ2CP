import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Classes.css';
// Importer des images différentes pour chaque classe
import ClassIcon1 from "../images/Frame_1.png";
import ClassIcon2 from "../images/Frame_2.png";
import ClassIcon3 from "../images/Frame_3.png";
import ClassIcon4 from "../images/Frame_4.png";
import Btn from './pic/plus.png';
const ClassesPage = () => {
  const handleAddClass = () => {
    navigate('/addClass'); // Remplace par la route vers la page souhaitée
  };
    const navigate = useNavigate();
  // État avec des images uniques
  const [classes, setClasses] = useState([
    { 
      id: 1, 
      name: '2CP SECTION A', 
      code: 'C1',
      image: ClassIcon1 // Image unique
    },
    { 
      id: 2, 
      name: '2CP SECTION B', 
      code: 'C7',
      image: ClassIcon2
    },
    { 
      id: 3, 
      name: '2CP SECTION C', 
      code: 'C8',
      image: ClassIcon3
    },
    { 
      id: 4, 
      name: '2CP SECTION C', 
      code: 'C9',
      image: ClassIcon4
    }
  ]);

  const handleDelete = (id) => {
    setClasses(prev => prev.filter(cls => cls.id !== id));
  };

  return (
    <div className="classes-container">
      <div className='titre'>
        <p>Classes of "module name"</p>
      </div>

      <div className="classes-list">
        {classes.map(cls => (
          <div key={cls.id} className="class-row">
            {/* Utiliser l'image spécifique à la classe */}
            <img 
              src={cls.image} 
              alt="class icon" 
              className="class-icon" 
            />
            
            <div className="class-info">
              <span className="class-name">{cls.name}</span>
              <span className="class-code">{cls.code}</span>
            </div>
            
            <div className="class-actions">
              <button className="view-students">
                View Students
              </button>
              <button 
                className="delete-btn"
                onClick={() => handleDelete(cls.id)}
              >
                Delete
              </button>
            </div>
          </div>
        ))}
      </div>
      <button className="btn" onClick={handleAddClass} aria-label="Add module">
              <img src={Btn} alt="Add module" className="img-fluid" />
            </button>
    </div>
  );
};

export default ClassesPage;