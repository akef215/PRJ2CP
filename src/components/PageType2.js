import React, { useEffect, useState } from 'react';
import Image from '../images/Frame_1.png';
import logo from '../images/logo _final.png';
import './styles/PageType2.css';
import { useNavigate, useParams } from 'react-router-dom';

const PageType2 = () => {
  const { id } = useParams(); // quiz_id depuis l'URL
  const navigate = useNavigate();

  const [questions, setQuestions] = useState([]);
  const [choices, setChoices] = useState([]);  // Etat pour les choix
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const [timeLeft, setTimeLeft] = useState(0);
  const [quizDuration, setQuizDuration] = useState(0);
  const [elapsedTime, setElapsedTime] = useState(0); // Etat pour le temps écoulé

  useEffect(() => {
    const fetchQuizAndQuestions = async () => {
      try {
        const quizRes = await fetch(`http://127.0.0.1:8000/quizzes/quiz/${id}`);
        const quizData = await quizRes.json();
        setQuizDuration(quizData.duree); // durée totale du quiz

        const questionsRes = await fetch(`http://127.0.0.1:8000/quizzes/${id}/questions`);
        const questionsData = await questionsRes.json();
        setQuestions(questionsData);

        // Initialiser la durée de la première question
        if (questionsData.length > 0) {
          setTimeLeft(questionsData[0].duree);
          fetchChoices(questionsData[0].id);  // Récupérer les choix pour la première question
        }
      } catch (error) {
        console.error("Erreur lors du chargement du quiz :", error);
      }
    };

    fetchQuizAndQuestions();
  }, [id]);

  useEffect(() => {
    if (timeLeft <= 0) return;

    const timer = setInterval(() => {
      setTimeLeft(prev => {
        if (prev === 1) {
          handleNextQuestion();
          return 0;
        }
        return prev - 1;
      });
      setElapsedTime(prev => prev + 1); // Mise à jour du temps écoulé
    }, 1000);

    return () => clearInterval(timer);
  }, [timeLeft]);

  const handleNextQuestion = () => {
    if (currentQuestionIndex + 1 < questions.length) {
      setCurrentQuestionIndex(currentQuestionIndex + 1);
      setTimeLeft(questions[currentQuestionIndex + 1].duree);
      fetchChoices(questions[currentQuestionIndex + 1].id); // Récupérer les choix pour la question suivante
    } else {
      navigate(`/Page2Completed/${id}`); // navigation automatique à la fin du quiz
    }
  };

  const fetchChoices = async (questionId) => {
    try {
      const choicesRes = await fetch(`http://127.0.0.1:8000/quizzes/${id}/${questionId}/choices`);
      const choicesData = await choicesRes.json();
      setChoices(choicesData);  // Mettre à jour les choix pour la question en cours
    } catch (error) {
      console.error('Erreur lors du chargement des choix:', error);
    }
  };

  const formatTime = (seconds) => {
    const min = Math.floor(seconds / 60);
    const sec = seconds % 60;
    return `${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`;
  };

  // Calcul du temps restant avant la fin du quiz
  const remainingQuizTime = quizDuration - elapsedTime;

  return (
    <div>
      <div className='Nav'>
        <div className='Nav-Logo'><img src={logo} alt='Logo'/></div>
        <div className='Nav-Menu'>
          <p onClick={() => navigate("/homepage")} className='nav-item'>home</p>
          <p onClick={() => navigate("/stats")} className='nav-item'>stats</p>
          <p className='nav-item active'>Present</p>
          <p onClick={() => navigate("/profile")} className='nav-item'>Profile</p>
        </div>
      </div>

      <div className='externe'>
        <div className='btn-haut'>
          <button className='time'>
          <p>Question Time Left: {formatTime(timeLeft)}</p></button>
          <button className='time'>
            <p>Quiz Time Left: {formatTime(remainingQuizTime)}</p> {/* Affichage du temps restant du quiz */}
          </button>
        </div>

        <div className='interne'>
          <div className='title'>
            <p>{questions[currentQuestionIndex]?.statement || "Chargement de la question..."}</p>
          </div>
          <img className='image' src={Image} alt="Quiz" />

          <div className='choices'>
            {choices.map((choice) => (
              <div key={choice.id} className='choice'>
                <button className='choice-btn'>
                  {choice.answer}
                </button>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default PageType2;
