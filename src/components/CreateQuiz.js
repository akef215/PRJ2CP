import React, { useEffect, useState } from "react";
import "./styles/CreateQuiz.css";
import "./styles/General.css";
import BtnX from "./pic/btnX.png";
import down from "./pic/down.png";
import Illustration from "../images/photo1.png";
import { useNavigate } from "react-router-dom";

// Reusable SelectButton component
const SelectButton = ({ label, onClick }) => {
  return (
    <button className="select-elem" onClick={onClick}>
      <span>{label}</span>
      <img src={down} alt="dropdown" className="dropdown-icon" />
    </button>
  );
};
const API_URL = process.env.REACT_APP_API_URL;

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
  const [quizName, setQuizName] = useState("");
  const [duree, setDuree] = useState();
  const [modules, setModules] = useState([]);
  const [classes, setClasses] = useState([]);
  const [minutes, setMinutes] = useState();
  const [seconds, setSeconds] = useState();

  const [selectedModule, setSelectedModule] = useState("");
  const [selectedClass, setSelectedClass] = useState("");
  const [selectedType, setSelectedType] = useState("");

  // Fetch data from API when component mounts
  useEffect(() => {
    fetch(`${API_URL}/teachers/modules`) // Mets ton vrai endpoint ici
      .then((res) => res.json())
      .then((data) => setModules(data))
      .catch((err) => console.error(err));

    fetch(`${API_URL}/teachers/groupes`)
      .then((res) => res.json())
      .then((data) => setClasses(data))
      .catch((err) => console.error(err));
  }, []);
  // Gestionnaires d'événements définis

  const SelectDropdown = ({
    label,
    options = [],
    selectedOption,
    onChange,
  }) => {
    const safeOptions = Array.isArray(options) ? options : [];

    return (
      <select
        className="select-elem"
        value={selectedOption}
        onChange={(e) => onChange(e.target.value)}
      >
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

  const handleNextClick = async () => {
    const today = new Date().toISOString().split("T")[0];
    const payload = {
      title: quizName,
      date: today,
      module: selectedModule,
      duree: parseInt(minutes * 60) + parseInt(seconds),
      description: "",
      groupe: selectedClass,
      type: selectedType,
      launch: false
    };

    console.log("Payload à envoyer :", payload);

    // Envoi au back
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
          console.log("Quiz créé avec succès !");
          navigate(`/addQuiz${selectedType}/${data.id}`);
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

  const navigate = useNavigate(); // Appel du hook ici, au top niveau

  const handleCloseButtonClick = () => {
    navigate("../Select"); // Redirection correcte
  };
  const handleCancelClick = () => {
    navigate("../Select"); // Redirection correcte
  };
  return (
    <div className="outerRectangle">
      <div className="innerRectangle">
        {/* Close button */}
        <div className="close-button-container">
          <button
            onClick={handleCloseButtonClick}
            style={{ border: "none", background: "none", cursor: "pointer" }}
          >
            <img src={BtnX} alt="btnX" />
          </button>
        </div>

        {/* Title */}
        <h1>Create Quiz</h1>

        {/* Content container */}
        <div className="content-container">
          <div className="form-container">
            <InputField
              placeholder="Quiz Name"
              value={quizName}
              onChange={(e) => setQuizName(e.target.value)}
            />
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
            <select
              value={selectedType}
              onChange={(e) => setSelectedType(e.target.value)}
              className="select-elem"
            >
              <option value="">Select Type</option>
              <option value="1">1</option>
              <option value="2">2</option>
            </select>
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
