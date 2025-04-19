import React, { useState, useEffect } from 'react';
import NavbarT1 from './NavBarT1.js';
import SidebarT1 from './SideBarT1.js';
import './styles/GeneralT1.css';
import DefaultImage from '../images/image 1.png';

const CreateT2Pic = () => {
  const [selectedImage, setSelectedImage] = useState(null);
  const [isImageLarge, setIsImageLarge] = useState(false);
  const [questionTitle, setQuestionTitle] = useState("quiz Question ?");

  const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setSelectedImage(reader.result);
        setIsImageLarge(true); // Active la classe pour agrandir l'image
      };
      reader.readAsDataURL(file);
    }
  };

  const triggerFileInput = () => {
    document.getElementById('fileInput').click();
  };
  // États pour le temps
  const [inputTime, setInputTime] = useState('');
  const [timeLeft, setTimeLeft] = useState(0);
  const [timerStarted, setTimerStarted] = useState(false);
  const [isTimerPaused, setIsTimerPaused] = useState(false);
  
  // États pour la note du quiz
  const [quizNote, setQuizNote] = useState('');
  const [noteSubmitted, setNoteSubmitted] = useState(false);

  // Lancement du décompte dès que le timer est lancé et non en pause
  useEffect(() => {
    if (!timerStarted || isTimerPaused || timeLeft <= 0) return;

    const timer = setInterval(() => {
      setTimeLeft(prev => prev - 1);
    }, 1000);

    return () => clearInterval(timer);
  }, [timerStarted, isTimerPaused, timeLeft]);

  // Formater le temps en mm:ss
  const formatTime = () => {
    const minutes = Math.floor(timeLeft / 60);
    const seconds = timeLeft % 60;
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  };

  // Démarrage du chronomètre avec la valeur saisie
  const handleStart = () => {
    const seconds = parseInt(inputTime, 10);
    if (!isNaN(seconds) && seconds > 0) {
      setTimeLeft(seconds);
      setTimerStarted(true);
      setIsTimerPaused(false);
    }
  };

  
  // Fonction pour basculer entre pause et reprise du timer
  const togglePause = () => {
    setIsTimerPaused(prev => !prev);
  };

  // Gestion de la validation de la note lors du blur (quand l'utilisateur quitte le champ)
  const handleNoteBlur = () => {
    if (quizNote.trim() !== '') {
      setNoteSubmitted(true);
    }
  };
  return (
    <div>
      <NavbarT1 />
      <SidebarT1 />
      <div className="exterieure">
        <div className="btns-up">
          {!timerStarted ? (
            <div>
              <input 
                type="number" 
                className='entre'
                placeholder="Entrez le temps en secondes" 
                value={inputTime}
                onChange={e => setInputTime(e.target.value)}
              />
              <button className='bouton' onClick={handleStart}>Démarrer</button>
            </div>
          ) : (
            <button className='time'>{formatTime()}</button>
          )}
          
          {/* Zone de note et bouton pour pause/reprise */} 
          <div className="mark-container">
            {/* Si la note n'est pas encore validée, affiche le champ de saisie */} 
            {!noteSubmitted ? (
              <input 
                type="text"
                className="entre"
                value={quizNote}
                onChange={(e) => setQuizNote(e.target.value)}
                onBlur={handleNoteBlur}
                placeholder="Ecrire votre note..."
              />
            ) : (
              <p>{quizNote}</p>
            )}
            {/* Bouton pour mettre en pause/reprendre le chronomètre */} 
            <div className='pause'>
              <button 
                className={`mark ${isTimerPaused ? 'paused' : ''}`}
                onClick={togglePause}
              >
                {isTimerPaused ? 'Reprendre' : 'Pause'}
              </button>
            </div>
          </div>
        </div>

        <div className="interieure">
          {/* Champ input pour modifier le titre en direct */}
          <input 
            type="text" 
            value={questionTitle} 
            onChange={(e) => setQuestionTitle(e.target.value)} 
            className="title" 
            style={{ position: 'relative', left: '30%', marginTop: '20px' }} 
          />
          <div>
            <input 
              id="fileInput" 
              type="file" 
              accept="image/*" 
              style={{ display: 'none' }} 
              onChange={handleImageUpload} 
            />
            <button className='ajouter-image' onClick={triggerFileInput}>
              <img 
                src={selectedImage || DefaultImage} 
                alt="add" 
                className={isImageLarge ? 'large-image' : 'default-image'} 
              />
            </button>
          </div>
        </div>
        
        <button className='full-time'>Full Quiz Time Left</button>
      </div>
      <button className='goback'>Go back</button>
    </div>
  );
};

export default CreateT2Pic;
