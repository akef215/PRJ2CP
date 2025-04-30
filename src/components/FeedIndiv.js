import React, { useState, useEffect } from "react";
import { useNavigate, useParams, Link } from "react-router-dom";
import "./styles/Feed.css";
import logo from "../images/logo _final.png";

const FeedIndiv = () => {
  const navigate = useNavigate();
  const [feedback, setFeedback] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const {id} = useParams();
  const API_URL = process.env.REACT_APP_API_URL;

  useEffect(() => {
    const abortController = new AbortController();

    const fetchFeedback = async () => {
      try {
        const res = await fetch(`${API_URL}/feedback/${id}`, {
          signal: abortController.signal,
        });

        if (!res.ok) {
          const errorData = await res.json();
          throw new Error(
            errorData.message || "Erreur lors de la récupération du feedback."
          );
        }

        const data = await res.json();

        // Tu récupères description et groupe ici
        const { description, groupe } = data;

        setFeedback({ description, groupe }); // ou stocke-les séparément si tu veux
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
      const res = await fetch(`${API_URL}/feedback/${id}`, {
        method: "DELETE",
      });
  
      if (!res.ok) {
        const errorData = await res.json();
        throw new Error(errorData.message || "Erreur lors de la suppression.");
      }
  
      navigate('/feedbacks'); // Retour à la page précédente
    } catch (err) {
      console.error("Erreur :", err);
      alert("Une erreur est survenue : " + err.message);
    }
  };
  

  return (
    <div>
      {/* Navigation bar - Classes conservées */}
      <div className="Nav">
        <div className="Nav-Logo">
          <img src={logo} alt="Logo" />
        </div>
        <div className="Nav-Menu">
          <p onClick={() => navigate("../homepage")}>Home</p>
          <p onClick={() => navigate("../stats")}>Stats</p>
          <p onClick={() => navigate("../quizPage")}>Quizzes</p>
          <p onClick={() => navigate("../profile")}>Profile</p>
        </div>
      </div>

      {/* Contenu principal - Classes originales conservées */}
      <div className="rec-ext">
        <div className="btnHaut">
          <button className="from">
            <p>Feedback from: {feedback?.groupe || "Unknown class"}</p>
          </button>
        </div>

        <div className="rec-int">
          {loading ? (
            <p>Chargement...</p>
          ) : error ? (
            <p style={{ color: "red" }}>{error}</p>
          ) : (
            <p>{feedback?.description || "Aucun contenu disponible."}</p>
          )}
        </div>

        {/* Boutons avec classes originales */}
        <div className="btnBas">
          <button className="asRead" onClick={handleMarkAsRead}>
            <p>Mark as read</p>
          </button>
          <button className="Back" onClick={() => navigate(-1)}>
            <p>Go back</p>
          </button>
        </div>
      </div>
    </div>
  );
};

export default FeedIndiv;
