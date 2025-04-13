import React, { useEffect, useState } from 'react';
import './CreateQuiz.css';
import './General.css';
import BtnX from './pic/btnX.png';
import down from './pic/down.png';
import Illustration from '../images/Photo3.png';

// Composant bouton de sélection avec menu déroulant
const SelectDropdown = ({ label, options, onChange }) => {
  return (
    <div className="dropdown-container">
      <label className="select-label">{label}</label>
      <select className="select-elem" onChange={(e) => onChange(e.target.value)}>
        <option value="">-- Select --</option>
        {options.map((option, index) => (
          <option key={index} value={option.name || option}>
            {option.name || option}
          </option>
        ))}
      </select>
    </div>
  );
};

// Champ de texte
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

const CreateSurvey = () => {
  const [modules, setModules] = useState([]);
  const [classes, setClasses] = useState([]);
  const [surveyName, setSurveyName] = useState('');
  const [selectedModule, setSelectedModule] = useState('');
  const [selectedClass, setSelectedClass] = useState('');
  const [minutes, setMinutes] = useState('');
  const [seconds, setSeconds] = useState('');

  // Fetch des modules et classes
  useEffect(() => {
    fetch('http://127.0.0.1:8000/teachers/modules')
      .then((res) => res.json())
      .then((data) => Array.isArray(data) ? setModules(data) : setModules([]))
      .catch((err) => {
        console.error('Erreur fetch modules:', err);
        setModules([]);
      });

    fetch('http://127.0.0.1:8000/teachers/classes')
      .then((res) => res.json())
      .then((data) => Array.isArray(data) ? setClasses(data) : setClasses([]))
      .catch((err) => {
        console.error('Erreur fetch classes:', err);
        setClasses([]);
      });
  }, []);

  const handleSubmit = () => {
    const payload = {
      name: surveyName,
      module: selectedModule,
      classe: selectedClass,
      time: `${minutes}:${seconds}`
    };

    console.log('Données du sondage :', payload);
    // TODO : envoyer les données au backend via fetch POST
  };

  return (
    <div className="outerRectangle">
      <div className="innerRectangle">
        {/* Fermer */}
        <div className="close-button-container">
          <button
            onClick={() => window.history.back()}
            style={{ border: 'none', background: 'none', cursor: 'pointer' }}
          >
            <img src={BtnX} alt="Close" />
          </button>
        </div>

        {/* Titre */}
        <h1>Create Survey</h1>

        <div className="content-container">
          <div className="form-container">
            <InputField
              placeholder="Survey Name"
              value={surveyName}
              onChange={(e) => setSurveyName(e.target.value)}
            />

            <SelectDropdown
              label="Select Module"
              options={modules}
              onChange={setSelectedModule}
            />

            <SelectDropdown
              label="Select Class"
              options={classes}
              onChange={setSelectedClass}
            />

            {/* Temps */}
            <div className="dropdown-container">
              <label className="select-label">Select Time</label>
              <div style={{ display: 'flex', gap: '10px' }}>
                <input
                  type="number"
                  placeholder="Min"
                  className="time-input"
                  value={minutes}
                  onChange={(e) => setMinutes(e.target.value)}
                />
                <input
                  type="number"
                  placeholder="Sec"
                  className="time-input"
                  value={seconds}
                  onChange={(e) => setSeconds(e.target.value)}
                />
              </div>
            </div>
          </div>

          <div className="img-section">
            <img src={Illustration} alt="Illustration" className="img-fluid" />
          </div>
        </div>

        {/* Boutons */}
        <div className="action-buttons">
          <button className="cancel-button" onClick={() => window.history.back()}>
            Back
          </button>
          <button className="next-button" onClick={handleSubmit}>
            Done
          </button>
        </div>
      </div>
    </div>
  );
};

export default CreateSurvey;
