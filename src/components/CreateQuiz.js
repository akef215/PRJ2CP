import React, { useEffect, useState } from 'react';
import './CreateQuiz.css';
import './General.css';
import BtnX from './pic/btnX.png';
import down from './pic/down.png';
import Illustration from '../images/photo1.png';
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

const InputField = ({ placeholder, value, onChange }) => {
  return (
    <input
      type="text"
      placeholder={placeholder}
      className="quiz-name-input"
      value={value}
      onChange={onChange}
    />
  );
};

const CreateQuiz = () => {
  const [quizName, setQuizName] = useState('');
  const [duree, setDuree] = useState(30);
  const [modules, setModules] = useState([]);
  const [classes, setClasses] = useState([]);

  const [selectedModule, setSelectedModule] = useState('');
  const [selectedClass, setSelectedClass] = useState('');
  const [selectedType, setSelectedType] = useState('');

  // Fetch data from API when component mounts
  useEffect(() => {
    fetch('http://localhost:8000/teachers/modules') // Mets ton vrai endpoint ici
      .then(res => res.json())
      .then(data => setModules(data))
      .catch(err => console.error(err));

    fetch('http://localhost:8000/teachers/groupes')
      .then(res => res.json())
      .then(data => setClasses(data))
      .catch(err => console.error(err));
  }, []);
  // Gestionnaires d'événements définis

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

  const handleNextClick = () => {
    const today = new Date().toISOString().split('T')[0];
    const payload = {
      title: quizName,
      date: today,
      module: selectedModule,
      duree: parseInt(duree),
      description: "",  // Tu peux rendre ça dynamique
      groupes: {
        group_ids: [selectedClass]
      }
    };
  
    console.log("Payload à envoyer :", payload);
  
    // Envoi au back
    fetch('http://localhost:8000/quizzes/add_quiz', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload)
    })
    .then(res => {
      if (res.status === 200) {
        console.log("Quiz créé avec succès !");
        navigate('../CreateQuizT1');  // Redirection vers la page Select
      } else {
        console.error("Erreur lors de la création :", res.status);
      }
    })
    .then(data => {
      console.log("Réponse du serveur :", data);
      // Redirection ou feedback ici
    })
    .catch(err => console.error("Erreur d'envoi :", err));
  };
  
  const navigate = useNavigate();  // Appel du hook ici, au top niveau

    const handleCloseButtonClick = () => {
      navigate('../Select');  // Redirection correcte
    };
    const handleCancelClick = () => {
      navigate('../Select');  // Redirection correcte
    };
  return (   
    
    <div className="outerRectangle">
      <div className="innerRectangle">
        {/* Close button */}
        <div className="close-button-container">
          <button
            onClick={handleCloseButtonClick}
            style={{ border: 'none', background: 'none', cursor: 'pointer' }}
          >
            <img src={BtnX} alt="btnX" />
          </button>
        </div>

        {/* Title */}
        <h1>Create Quiz</h1>

        {/* Content container */}
        <div className="content-container">
          <div className="form-container">
            <InputField placeholder="Quiz Name"  
            value={quizName}
            onChange={(e) => setQuizName(e.target.value)}/>
            <SelectDropdown
              label="Select Module"
              options={modules}
              selectedOption={selectedModule}
              onChange={setSelectedModule}
            />
            <SelectDropdown
              label="Select Class"
              options={classes}
              selectedOption={selectedClass}
              onChange={setSelectedClass}
            />
            {/*<SelectButton
              label="Select Chapter"
              onClick={() => handleSelectButtonClick('Select Chapter')}
            />*/}
            <select value={selectedType} onChange={(e) => setSelectedType(e.target.value)} className="select-elem">
            <option value="">Select Type</option>
            <option value="1">1</option>
            <option value="2">2</option>
            </select>
            <InputField placeholder="Duree"  
            value={duree}
            onChange={(e) => setDuree(e.target.value)}/>
          </div>

          {/* Image section */}
          <div className="img-section">
            <img src={Illustration} alt="Illustration" className="img-fluid" />
          </div>
        </div>

        {/* Action buttons */}
        <div className="action-buttons">
          <button className="cancel-button" onClick={handleCancelClick}>
            Cancel
          </button>
          <button className="next-button" onClick={handleNextClick}>
            Next
          </button>
        </div>
      </div>
    </div>
  );
};

export default CreateQuiz;