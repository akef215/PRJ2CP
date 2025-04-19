import React, { useState, useEffect } from 'react';
import Image from '../images/Frame_1.png';
import logo from '../images/logo _final.png';
import "./styles/PageType2.css";
import { useNavigate } from 'react-router-dom';

const PageType2 = () => {
  // États pour le temps
  const [inputTime, setInputTime] = useState('');
  const [timeLeft, setTimeLeft] = useState(0);
  const [timerStarted, setTimerStarted] = useState(false);
  const [isTimerPaused, setIsTimerPaused] = useState(false);
  const navigate = useNavigate();
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
              <div className='Nav'>
                  <div className='Nav-Logo'><img src={logo} alt='Logo'/></div>
                  <div className='Nav-Menu'>
                      <p onClick={() => {navigate("../homepage")}} className={'nav-item'}>home</p>
                      <p onClick={() => {navigate("../stats")}} className={'nav-item'}>stats</p>
                      <p onClick={() => {navigate("../pageType2")}} className={'nav-item active'}>Present</p>
                      <p onClick={() => {navigate("../profile")}} className={'nav-item'}>Profile</p>
                  </div>
              </div>
      <div className='externe'>
        <div className='btn-haut'>
          {/* Affiche l'input et le bouton Démarrer tant que le timer n'est pas lancé */}
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
              // Sinon, affiche simplement la note
              <p>{quizNote}</p>
            )}
            {/* Bouton pour mettre en pause/reprendre le chronomètre */}
            < div className='pause'>
            <button 
          
              className={`mark ${isTimerPaused ? 'paused' : ''}`}
              onClick={togglePause}
            >
              {isTimerPaused ? 'Reprendre' : 'Pause'}
            </button>
            </div>
          </div>
        </div>

        <div className='interne'>
          <div className='title'>
            <p>quiz question?</p>
          </div>
          <img className='image' src={Image} alt="Image"/>
        </div>
        
        <button className='full-time'>
          <p> Full Quiz Time left </p>
        </button>
      </div>
      
      <div className='btn-bas'>
        <button className='go-back'>Go back</button>
        <button className='Next'>Next</button>
      </div>
    </div>
  );
}

export default PageType2;
