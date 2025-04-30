import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './styles/Classes.css';
import ClassIcon1 from "../images/Frame_1.png"; // Image unique pour toutes les classes
import Btn from './pic/plus.png';

const ClassesPage = () => {
  const [classes, setClasses] = useState([]);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  // Fonction pour récupérer les groupes
  const fetchClasses = async () => {
    try {
      const res = await fetch(`${API_URL}/teachers/groupes`);
      const data = await res.json();
      const formattedData = data.map((item, index) => ({
        ...item,
        id: item.id || index + 1,
        image: ClassIcon1,
      }));
      setClasses(formattedData);
    } catch (err) {
      console.error(err);
      setError("Failed to fetch groups");
    }
  };

  const handleDelete = async (id) => {
    try {
      const res = await fetch(`${API_URL}/teachers/delete_groupe?code=${encodeURIComponent(id)}`, {
        method: 'DELETE',
      });

      if (res.ok) {
        console.log("Groupe supprimé !");
        // Met à jour l'état local
        setClasses(prev => prev.filter(mod => mod.id !== id));
        // Rafraîchit les classes après suppression
        await fetchClasses();
      } else {
        console.error("Erreur de suppression :", res.status);
        setError("Failed to delete the group");
      }
    } catch (err) {
      console.error("Erreur réseau :", err);
      setError("Network error occurred");
    }
  };

  useEffect(() => {
    fetchClasses();
  }, []);

  const handleAddClass = () => {
    navigate('/addClass');
  };

  const handleViewStudent = (classId) => {
    navigate(`/students/${classId}`);
  };
  const API_URL = process.env.REACT_APP_API_URL;

  return (
    <div className="classes-container">
      <div className='titre'>
        <p>Classes</p>
      </div>

      {error && <div className="error-message">{error}</div>}

      <div className="classes-list">
        {classes.map(cls => (
          <div key={cls.id} className="class-row">
            <img 
              src={cls.image} 
              alt="class icon" 
              className="class-icon" 
            />
            <div className="class-info">
              <span className="class-name">{cls.level || 'Unnamed'}</span>
              <span className="class-code">Group {cls.numero}</span>
            </div>
            <div className="class-actions">
              <button className="view-students" onClick={() => handleViewStudent(cls.id)}>
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
