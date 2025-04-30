import React, { useState } from "react";
import "./styles/CreateQuiz.css"; // Importez votre fichier CSS
import BtnX from "./pic/btnX.png";
import down from "./pic/down.png";
import imageIcon from "../images/image 1.png"; // Icône pour le bouton d'ajout d'image
import Illustration from "../images/Photo2.png";
import { useNavigate } from "react-router-dom";
import { customFetch } from "../customFetch";

// Composant réutilisable SelectButton (avec flèche)
const SelectButton = ({ label, onClick }) => {
  return (
    <button className="select-elem" onClick={onClick}>
      <span>{label}</span>
      <img src={down} alt="dropdown" className="dropdown-icon" />
    </button>
  );
};

// Composant pour ajouter une image
const ImageUploadButton = ({ onChange }) => {
  const handleFileChange = (event) => {
    const file = event.target.files[0];
    if (file) {
      onChange(file); // Transmettre le fichier sélectionné au parent
    }
  };

  return (
    <div className="image-upload-container">
      <input
        type="file"
        accept="image/*"
        style={{ display: "none" }}
        id="image-upload"
        onChange={handleFileChange}
      />
      <label htmlFor="image-upload" className="image-upload-button">
        <span>Add Cover</span>
        <img
          src={imageIcon}
          alt="Add Image"
          style={{ width: "24px", height: "24px" }}
        />
      </label>
    </div>
  );
};

// Composant InputField
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

const AddClass = () => {
  const levels = ["1CP", "2CP", "1CS", "2CS"];
  const [level, setLevel] = useState("");
  const [Nb, setNb] = useState(1);
  const API_URL = process.env.REACT_APP_API_URL;
  const navigate = useNavigate();
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
        {safeOptions.map((opt, index) => (
          <option key={index} value={opt}>
            {opt}
          </option>
        ))}
      </select>
    );
  };

  const handleNextClick = () => {
    const url = `${API_URL}/teachers/add_groupe?level=${level}&numero=${Nb}`;

    customFetch(url, {
      method: "POST",
    })
      .then((res) => {
        if (res && res.status === 200) {
          console.log("Groupe ajouté avec succès !");
          navigate("../classesPage");
        } else if (res) {
          console.error("Erreur lors de la création :", res.status);
        }
      })
      .catch((err) => console.error("Erreur d'envoi :", err));
  };
  // Gestionnaires d'événements définis
  const handleCloseButtonClick = () => {
    console.log("Close button clicked");
  };

  const handleSelectButtonClick = (label) => {
    console.log(`Selected: ${label}`);
  };

  const handleCancelClick = () => {
    navigate("../select");
  };

  const handleImageUpload = (file) => {
    console.log("Image selected:", file);
    // Vous pouvez ici traiter le fichier image (par exemple, l'afficher ou l'envoyer à un serveur)
  };

  return (
    <div className="createQuizContainer">
      <div className="outerRectangle">
        <div className="innerRectangle">
          {/* Bouton de fermeture */}
          <div className="close-button-container">
            <button
              onClick={handleCloseButtonClick}
              style={{ border: "none", background: "none", cursor: "pointer" }}
            >
              <img src={BtnX} alt="Fermer" />
            </button>
          </div>

          {/* Titre */}
          <h1>Add Class</h1>

          {/* Conteneur de contenu */}
          <div className="content-container">
            <div className="form-container">
              <SelectDropdown
                label="Select Level"
                options={levels}
                selectedOption={level}
                onChange={setLevel}
              />
              <InputField
                placeholder="Numero du groupe"
                value={Nb}
                onChange={(e) => setNb(Number(e.target.value))}
              />
            </div>

            {/* Section Image */}
            <div className="img-section">
              <img src={Illustration} alt="Illustration" />
            </div>
          </div>

          {/* Boutons d'action */}
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
    </div>
  );
};

export default AddClass;
