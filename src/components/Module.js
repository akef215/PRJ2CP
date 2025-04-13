import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import PropTypes from 'prop-types';
import './Module.css';
import moduleImage from './pic/Module.png';
import Btn from './pic/plus.png';
import threeDot from '../images/dots 1.png';
const ModuleCard = ({ imageSrc, title, code, onDelete }) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };
  return (
    <div className="rectangle-elem">
      <div className="image-container">
        <img src={imageSrc} alt={title} className="img-fluid" />
      </div>
      <div className="title-container">
        <h3>{title}</h3>
        <button className="options-button" onClick={toggleMenu}>
          <img src={threeDot} alt="Options" className="options" />
        </button>
        {isMenuOpen && (
          <div className="dropdown-menu">
            <button onClick={() => onDelete(code)}>Delete</button>
            <button>Edit</button>
          </div>
        )}
      </div>
    </div>
  );
};

ModuleCard.propTypes = {
  imageSrc: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
  code: PropTypes.string.isRequired,
  onDelete: PropTypes.func
};

const Module = () => {
  const [modules, setModules] = useState([]); // Initialisation de l'état des modules
  const [isLoading, setIsLoading] = useState(true);
  const navigate = useNavigate();

  const handleDelete = async (code) => {
    try {
      const res = await fetch(`http://localhost:8000/teachers/delete_module?code=${encodeURIComponent(code)}`, {
        method: 'DELETE',
      });
  
      if (res.ok) {
        console.log("Module supprimé !");
        // Supprime localement le module dans le state :
        setModules(prev => prev.filter(mod => mod.code !== code));
      } else {
        console.error("Erreur de suppression :", res.status);
      }
    } catch (err) {
      console.error("Erreur réseau :", err);
    }
  };
  

  // Récupérer les modules depuis le backend
  const fetchModules = async () => {
    try {
      const response = await fetch('http://127.0.0.1:8000/teachers/modules'); // Assurez-vous que cette URL correspond à votre backend
      if (response.status != 200) {
        throw new Error('Erreur lors de la récupération des modules');
      }
      const data = await response.json();
      setModules(data); // Mettre à jour l'état avec les modules récupérés
    } catch (error) {
      console.error("Erreur:", error);
    } finally {
      setIsLoading(false);
    }
  };

  // Charger les modules au montage du composant
  useEffect(() => {
    fetchModules();
  }, []);

  if (isLoading) {
    return <div>Loading...</div>; // Afficher un message de chargement
  }
    const handleClickAdd = () => {
          navigate('../AddModule');
    }
  return (
    <div className="module-content">
      <div className="first-line">
        {modules.slice(0, 3).map((module) => (
          <ModuleCard key={module.id} imageSrc={moduleImage} title={module.titre} code={module.code} onDelete={handleDelete}/>
        ))}
      </div>

      <div className="second-line">
        {modules.slice(3, 6).map((module) => (
          <ModuleCard key={module.id} imageSrc={moduleImage} title={module.titre} code={module.code} onDelete={handleDelete}/>
        ))}
      </div>

      <button className="btn" onClick={handleClickAdd} aria-label="Add module">
        <img src={Btn} alt="Add module" className="img-fluid" Link to/>
      </button>
    </div>
  );
};

export default Module;
