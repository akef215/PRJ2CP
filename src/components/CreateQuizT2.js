import React, { useState } from 'react';
import NavbarT1 from './NavBarT1.js';
import SidebarT1 from './SideBarT1.js';
import './styles/GeneralT1.css';
import Image from '../images/image 1.png';
import CheckIcon from '../images/Rectangle 21.png';
import Tick from '../images/Vector 2.png';

const CreateQuizT2 = () => {
  // États existants
  const [showTicks, setShowTicks] = useState([false, false, false, false]);
  const [selectedImages, setSelectedImages] = useState([null, null, null, null]);
  const [containerHeights, setContainerHeights] = useState([0, 0, 0, 0]);
  const [showBorders, setShowBorders] = useState([false, false, false, false]);

  // Modification de la section d'image principale
  const MainImageUpload = () => (
    <div className="btn-image">
      <p>quiz questions ?</p>
      <div className="main-image-container">
        {selectedImages[0] ? (
          <>
            <img
              src={selectedImages[0]}
              alt="Uploaded"
              className="main-image"
            />
            <button 
              className="close-btn"
              onClick={() => handleCloseImage(0)}
            >
              ✕
            </button>
          </>
        ) : (
          <label htmlFor="image-upload-main" className="main-image-label">
            <img
              src={Image}
              alt="Add Image"
              className="main-image"
            />
          </label>
        )}
        <input
          type="file"
          className="file-input"
          onChange={(e) => handleImageUpload(e, 0)}
          id="image-upload-main"
          accept="image/*"
          style={{ display: 'none' }}
        />
      </div>
    </div>
  );

  // Le reste du code reste inchangé
  const handleCheckIconClick = (index) => {
    const newShowTicks = [...showTicks];
    newShowTicks[index] = !newShowTicks[index];
    setShowTicks(newShowTicks);
  };

  const handleCheckClick = (index) => {
    const newBorders = [...showBorders];
    newBorders[index] = !newBorders[index];
    setShowBorders(newBorders);
  };

  const handleImageUpload = (event, index) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        const newImages = [...selectedImages];
        newImages[index] = reader.result;
        setSelectedImages(newImages);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleCloseImage = (index) => {
    const newImages = [...selectedImages];
    newImages[index] = null;
    setSelectedImages(newImages);
  };

  return (
    <div>
      <NavbarT1 />
      <SidebarT1 />

      <div className="up-btns">
        <button className="btn-ind"><p>Full Quiz Time</p></button>
        <button className="btn-ind"><p>Total quiz mark</p></button>
        <button className="btn-ind" id="type2"><p>Edit quiz display</p></button>
      </div>

      <div className="btn-options">
        <button className="btn-sec"><p>Cancel</p></button>
        <button className="btn-sec"><p>Complete</p></button>
      </div>

      <div className="rectangleExtr">
        {/* <MainImageUpload /> */}

        <button className="btn-Tmarks">
          <p>Total Marks</p>
        </button>

        <div className="rectangleIntr">
          {[1, 2, 3, 4].map((index) => (
            <div 
              className={`rectangle-item ${showBorders[index] ? 'active-border' : ''}`} 
              key={index}
            >
              <div className="answer-top-row">
                <button 
                  className="btn-check" 
                  onClick={() => {
                    handleCheckIconClick(index);
                    handleCheckClick(index);
                  }}
                >
                  <img src={CheckIcon} alt="Check" className="check-icon" />
                  {showTicks[index] && (
                    <img
                      src={Tick}
                      alt="Tick"
                      className="tick-icon"
                    />
                  )}
                </button>

                <div className="answer-content">
                  <p>Answer {index}</p>
                  <button className="btn-mark">answer mark</button>
                </div>
              </div>

              <div className="answer-image-container">
                {selectedImages[index] ? (
                  <>
                    <img
                      src={selectedImages[index]}
                      alt="Uploaded Answer"
                      className="answer-image"
                    />
                    <button 
                      className="close-btn"
                      onClick={() => handleCloseImage(index)}
                    >
                      ✕
                    </button>
                  </>
                ) : (
                  <label htmlFor={`image-upload-${index}`} className="answer-image-label">
                    <img
                      src={Image}
                      alt="Add Answer Image"
                      className="answer-image"
                    />
                  </label>
                )}
                <input
                  type="file"
                  className="file-input"
                  onChange={(e) => handleImageUpload(e, index)}
                  id={`image-upload-${index}`}
                  accept="image/*"
                  style={{ display: 'none' }}
                />
              </div>
            </div>
          ))}

          <button className="btn-addAnswr">Add Answer</button>
        </div>
      </div>
    </div>
  );
};

export default CreateQuizT2;