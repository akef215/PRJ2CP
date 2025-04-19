import React, { useEffect, useState } from 'react'; 
import Papa from 'papaparse';
import './styles/CreateQuiz.css';
import './styles/General.css';
import BtnX from './pic/btnX.png';
import down from './pic/down.png';
import Illustration from '../images/photo.png';
import { useNavigate } from 'react-router-dom';

// Reusable SelectButton component
const SelectButton = ({ label, onClick }) => {
  return (
    <button className="select-elem" onClick={onClick}>
      <span>{label}</span>
      <img src={down} alt="dropdown" className="dropdown-icon" />
    </button>
  );
};

const InputField = ({ placeholder, type = "text", onChange, value }) => {
  return (
    <input
      type={type}
      placeholder={placeholder}
      className="quiz-name-input"
      onChange={onChange}
      value={value}
    />
  );
};

const AddClassCSV = () => {
  const [classes, setClasses] = useState([]);
  const [selectedClass, setSelectedClass] = useState('');
  const [csvFile, setCsvFile] = React.useState(null);
  const navigate = useNavigate();
    // Fetch data from API when component mounts
    useEffect(() => {
      fetch('http://localhost:8000/teachers/groupes')
        .then(res => res.json())
        .then(data => setClasses(data))
        .catch(err => console.error(err));
    }, []);

  const handleCloseButtonClick = () => {
    console.log('Close button clicked');
  };

  const handleCancelClick = () => {
    navigate("/select");
  };

  const handleNextClick = async () => {
    if (!selectedClass || !csvFile || parsedStudents.length === 0) {
      alert("Merci de sélectionner une classe et un fichier CSV valide.");
      return;
    }
  
    for (let student of parsedStudents) {
      if (!student.id || !student.email || !student.name || !student.password || !student.level || !student.groupe) {
        console.warn(`❌ Ligne incomplète:`, student);
        continue;
      }
  
      const payload = {
        name: student.name,
        level: student.level,
        groupe_id: student.groupe + student.level,
        id: student.id,
        email: student.email,
        password: student.password,
      };
  
      try {
        const res = await fetch("http://127.0.0.1:8000/students/SignUp", {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(payload),
        });
  
        const data = await res.json();
        if (res.ok) {
          console.log(`✅ Étudiant ${student.id} ajouté avec succès.`);
        } else {
          console.warn(`⚠️ Erreur pour ${student.id}:`, data);
        }
      } catch (error) {
        console.error(`❌ Échec de l'envoi pour ${student.id}:`, error);
      }
    }
    navigate('/classesPage');
    setMessage("📤 Importation terminée !");
  };
  

  const [message, setMessage] = useState('');
  const [parsedStudents, setParsedStudents] = useState([]);

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;
  
    Papa.parse(file, {
      header: true,
      skipEmptyLines: true,
      complete: function (results) {
        setParsedStudents(results.data); // On ne fait que stocker
        setMessage("✅ Fichier CSV prêt à être importé.");
      },
    });
  
    setCsvFile(file);
  };
  
  
  const SelectDropdown = ({ label, options = [], selectedOption, onChange }) => {
    const safeOptions = Array.isArray(options) ? options : [];
  
    return (
      <select className="select-elem" value={selectedOption} onChange={e => onChange(e.target.value)}>
        <option value="">{label}</option>
        {safeOptions.map((opt, index) => {
          const value = opt.code || opt.id || ""; // code pour module, id pour classe
          return (
            <option key={index} value={value}>
              {value}
            </option>
          );
        })}
      </select>
    );
  }; 

  return (    
    <div className="outerRectangle">
      <div className="innerRectangle">
        <div className="close-button-container">
          <button
            onClick={handleCloseButtonClick}
            style={{ border: 'none', background: 'none', cursor: 'pointer' }}
          >
            <img src={BtnX} alt="btnX" />
          </button>
        </div>

        <h1>Add students</h1>

        <div className="content-container">
          <div className="form-container">
          <SelectDropdown
              label="Select Class"
              options={classes}
              selectedOption={selectedClass}
              onChange={setSelectedClass}
            />
            <input 
              type="file" 
              accept=".csv" 
              onChange={handleFileChange} 
              className="quiz-name-input" 
              style={{ marginTop: '10px' }}
            />
          </div>

          <div className="img-section">
            <img src={Illustration} alt="Illustration" className="img-fluid" />
          </div>
        </div>

        <div className="action-buttons">
          <button className="cancel-button" onClick={handleCancelClick}>
            Cancel
          </button>
          <button className="next-button" onClick={handleNextClick}>
            Done
          </button>
        </div>
      </div>
    </div>
  );
};

export default AddClassCSV;