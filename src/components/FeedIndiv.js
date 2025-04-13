import React, { useState, useEffect } from 'react';
import { useNavigate, useParams, Link } from 'react-router-dom';
import './Feed.css';
import logo from '../images/logo _final.png';

const FeedIndiv = () => {
  const navigate = useNavigate();
  const [feedback, setFeedback] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const abortController = new AbortController();

    const fetchFeedback = async () => {
      try {
        const res = await fetch('http://127.0.0.1:8000/feedback', {
          signal: abortController.signal,
        });
        
        if (!res.ok) {
          const errorData = await res.json();
          throw new Error(errorData.message || "Erreur lors de la récupération du feedback.");
        }
        
        const data = await res.json();
        setFeedback(data[0]); // Adaptez selon la structure de votre API
      } catch (err) {
        if (!abortController.signal.aborted) {
          setError(err.message);
        }
      } finally {
        if (!abortController.signal.aborted) {
          setLoading(false);
        }
      }
    };

    fetchFeedback();

    return () => abortController.abort();
  }, []);

  const handleMarkAsRead = async () => {
    try {
      // Ajoutez votre logique de mise à jour ici
      alert('Marqué comme lu');
    } catch (err) {
      console.error("Erreur :", err);
    }
  };

  return (
    <div>
      {/* Navigation bar - Classes conservées */}
      <div className='Nav'>
        <div className='Nav-Logo'><img src={logo} alt='Logo' /></div>
        <div className='Nav-Menu'>
          <p><Link to="/homepage">Home</Link></p>
          <p><Link to="/stats">Stats</Link></p>
          <p><Link to="/module">Modules</Link></p>
          <p><Link to="/profile">Profile</Link></p>
        </div>
      </div>

      {/* Contenu principal - Classes originales conservées */}
      <div className='rec-ext'>
        <div className='btnHaut'>
          <button className='from'>
            <p>Feedback from: {feedback?.class || "Unknown class"}</p>
          </button>
        </div>

        <div className='rec-int'>
          {loading ? (
            <p>Chargement...</p>
          ) : error ? (
            <p style={{ color: 'red' }}>{error}</p>
          ) : (
            <p>{feedback?.fullContent || "Aucun contenu disponible."}</p>
          )}
        </div>

        {/* Boutons avec classes originales */}
        <div className='btnBas'>
          <button className='asRead' onClick={handleMarkAsRead}>
            <p>Mark as read</p>
          </button>
          <button className='Back' onClick={() => navigate(-1)}>
            <p>Go back</p>
          </button>
        </div>
      </div>
    </div>
  );
};

export default FeedIndiv;