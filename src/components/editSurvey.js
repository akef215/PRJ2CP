import React, { useEffect, useState } from "react";
import "./styles/CreateQuiz.css";
import "./styles/General.css";
import BtnX from "./pic/btnX.png";
import down from "./pic/down.png";
import Illustration from "../images/Photo3.png";
import { useNavigate, useParams } from "react-router-dom";

// Composant bouton de sélection avec menu déroulant
const SelectDropdown = ({ label, options, onChange, value }) => {
    return (
      <div className="dropdown-container">
        <label className="select-label">{label}</label>
        <select
          className="select-elem"
          value={value} // Utilise la valeur initiale ici
          onChange={(e) => {
            const selectedValue = e.target.value;
            const selectedOption = options.find(
              (opt) => (opt.code || opt.titre || opt.id || "") === selectedValue
            );
            onChange(selectedOption); // Passe l'option sélectionnée à la fonction onChange
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

const EditSurvey = () => {
    const [modules, setModules] = useState([]); // Modules disponibles
    const [classes, setClasses] = useState([]); // Classes disponibles
    const [surveyName, setSurveyName] = useState(""); // Nom du questionnaire
    const [selectedModule, setSelectedModule] = useState(null); // Module sélectionné
    const [selectedClass, setSelectedClass] = useState(null); // Classe sélectionnée
    const [minutes, setMinutes] = useState(""); // Minutes
    const [seconds, setSeconds] = useState(""); // Secondes
    const { id } = useParams();
  
    // Récupération des modules et des classes
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
  
    // Récupérer les données du quiz pour l'édition
    useEffect(() => {
      if (!id) return; // Si l'ID est non défini, on ne fait rien
  
      fetch(`${API_URL}/quizzes/quiz/${id}`)
        .then((res) => res.json())
        .then((data) => {
          console.log("Quiz à éditer :", data);
          setSurveyName(data.title || "");
          
          // Initialisation des valeurs sélectionnées pour les modules et classes
          setSelectedModule(data.module_code ? { code: data.module_code } : null); // Module sélectionné
          setSelectedClass(data.groupe ? { id: data.groupe } : null); // Classe sélectionnée
  
          // Initialisation de la durée en minutes et secondes
          if (data.duree) {
            const totalSeconds = data.duree * 60;
            setMinutes(Math.floor(totalSeconds / 60));
            setSeconds(totalSeconds % 60);
          }
        })
        .catch((err) => {
          console.error("Erreur fetch quiz :", err);
        });
    }, [id]);
  
    // Gérer la soumission du formulaire
    const handleSubmit = async () => {
      const today = new Date().toISOString().split("T")[0];
      const durationInMinutes = parseInt(minutes) + parseInt(seconds)/60; // Durée en secondes
      const payload = {
        title: surveyName,
        date: today,
        module_code: selectedModule?.code,
        duree: durationInMinutes
      };
  
      console.log("Payload à envoyer :", payload);
  
      try {
        const res = await fetch(`${API_URL}/quizzes/modify/${id}`, {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(payload),
        });
  
        if (res.status === 200) {
          const data = await res.json();
          console.log("Réponse du serveur :", data);
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
    const API_URL = process.env.REACT_APP_API_URL;
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
          <h1>Edit Survey</h1>
  
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
                value={selectedModule ? selectedModule.code : ""}
              />
  
              <SelectDropdown
                label="Select Class"
                options={classes}
                onChange={setSelectedClass}
                value={selectedClass ? selectedClass.id : ""}
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
            <button className="cancel-button" onClick={() => navigate(`/addSurvey/${id}`)}>  
              Cancel
            </button>
            <button className="next-button" onClick={handleSubmit}>
              Edit
            </button>
          </div>
        </div>
      </div>
    );
  };
  
export default EditSurvey;
  
