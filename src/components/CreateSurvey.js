import React, { useEffect, useState } from "react";
import "./styles/CreateQuiz.css";
import "./styles/General.css";
import BtnX from "./pic/btnX.png";
import down from "./pic/down.png";
import Illustration from "../images/Photo3.png";
import { useNavigate } from "react-router-dom";

// Composant bouton de sélection avec menu déroulant
const SelectDropdown = ({ label, options, onChange }) => {
  return (
    <div className="dropdown-container">
      <label className="select-label">{label}</label>
      <select
        className="select-elem"
        onChange={(e) => {
          const value = e.target.value;
          const selectedOption = options.find(
            (opt) => (opt.code || opt.titre || opt.id || "") === value
          );
          onChange(selectedOption);
        }}
      >
        <option value="">-- Select --</option>
        {options.map((option, index) => (
          <option key={index} value={option.code || option.titre || option.id}>
            {option.code || option.titre || option.id}
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
  const [surveyName, setSurveyName] = useState("");
  const [selectedModule, setSelectedModule] = useState(null);
  const [selectedClass, setSelectedClass] = useState(null);
  const [minutes, setMinutes] = useState("");
  const [seconds, setSeconds] = useState("");
  const API_URL = process.env.REACT_APP_API_URL;

  // Fetch des modules et classes
  useEffect(() => {
    fetch(`${API_URL}/teachers/modules`)
      .then((res) => res.json())
      .then((data) => {
        console.log("Modules:", data);
        setModules(Array.isArray(data) ? data : []);
      })
      .catch((err) => {
        console.error("Erreur fetch modules:", err);
        setModules([]);
      });

    fetch(`${API_URL}/teachers/groupes`)
      .then((res) => res.json())
      .then((data) => {
        console.log("Classes:", data);
        setClasses(Array.isArray(data) ? data : []);
      })
      .catch((err) => {
        console.error("Erreur fetch classes:", err);
        setClasses([]);
      });
  }, []);

  const handleSubmit = async () => {
    const today = new Date().toISOString().split("T")[0];
    const payload = {
      title: surveyName,
      date: today,
      module: selectedModule?.code,
      duree: parseInt(minutes * 60) + parseInt(seconds),
      description: "", // Tu peux rendre ça dynamique
      groupe: selectedClass?.id,
      type: "S",
      launch: false,
    };

    console.log("Payload à envoyer :", payload);

    try {
      // Attendre la réponse de fetch
      const res = await fetch(`${API_URL}/quizzes/add_quiz`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      });

      if (res.status === 200) {
        // Attendre que la réponse JSON soit traitée
        const data = await res.json();
        console.log("Réponse du serveur :", data); // Log pour la réponse

        if (data.id) {
          console.log("Survey créé avec succès !");
          navigate(`/addSurvey/${data.id}`);
        } else {
          console.error("ID manquant dans la réponse du serveur.");
        }
      } else {
        console.error("Erreur lors de la création :", res.status);
      }
    } catch (err) {
      console.error("Erreur d'envoi :", err);
    }
  };

  const navigate = useNavigate();
  return (
    <div className="outerRectangle">
      <div className="innerRectangle">
        {/* Fermer */}
        <div className="close-button-container">
          <button
            onClick={() => window.history.back()}
            style={{ border: "none", background: "none", cursor: "pointer" }}
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
              <div style={{ display: "flex", gap: "10px" }}>
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
          <button className="cancel-button" onClick={() => navigate("/select")}>
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
