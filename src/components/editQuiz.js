import React, { useEffect, useState } from "react";
import "./styles/CreateQuiz.css";
import "./styles/General.css";
import BtnX from "./pic/btnX.png";
import Illustration from "../images/photo1.png";
import { useNavigate } from "react-router-dom";
import { useParams } from "react-router-dom";

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

const EditQuiz = () => {
  const [quizName, setQuizName] = useState("");
  const [duree, setDuree] = useState();
  const [modules, setModules] = useState([]);
  const [classes, setClasses] = useState([]);

  const [selectedModule, setSelectedModule] = useState("");
  const [selectedClass, setSelectedClass] = useState("");
  const [selectedType, setSelectedType] = useState("");
  const { id } = useParams();
  const API_URL = process.env.REACT_APP_API_URL;
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

  // Récupérer les données du quiz pour l'édition
  useEffect(() => {
    if (!id) return; // Si l'ID est non défini, on ne fait rien

    fetch(`${API_URL}/quizzes/quiz/${id}`)
      .then((res) => res.json())
      .then((data) => {
        setQuizName(data.title || "");

        // Initialisation des valeurs sélectionnées pour les modules et classes
        setSelectedModule(data.module_code ? { code: data.module_code } : null); // Module sélectionné
        setSelectedClass(data.groupe_id ? { id: data.groupe_id } : null); // Classe sélectionnée

        // Initialisation de la durée en minutes et secondes
        if (data.duree) {
          setDuree(data.duree);
        }
      })
      .catch((err) => {
        console.error("Erreur fetch quiz :", err);
      });
  }, [id]);
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

  // Gérer la soumission du formulaire
  const handleNextClick = async () => {
    const today = new Date().toISOString().split("T")[0];
    const durationInMinutes = parseFloat(duree);
    const payload = {
      title: quizName,
      date: today,
      module_code: selectedModule?.code,
      duree: durationInMinutes,
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

  const navigate = useNavigate(); // Appel du hook ici, au top niveau

  const handleCloseButtonClick = () => {
    navigate("../Select"); // Redirection correcte
  };
  const handleCancelClick = () => {
    navigate(`/addQuiz/${id}`); // Redirection correcte
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
        <h1>Edit Quiz</h1>

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
              selectedOption={selectedModule?.code || ""}
              onChange={(code) => {
                const selected = modules.find((m) => m.code === code);
                setSelectedModule(selected || null);
              }}
            />
            <SelectDropdown
              label="Select Class"
              options={classes}
              selectedOption={selectedClass?.id || ""}
              onChange={setSelectedClass}
            />
            <InputField
              placeholder="Duree"
              value={duree}
              onChange={(e) => setDuree(e.target.value)}
            />
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
            Edit
          </button>
        </div>
      </div>
    </div>
  );
};

export default EditQuiz;
