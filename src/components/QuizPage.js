import { useState, useEffect } from "react";
import "./styles/QuizPage.css";
import { useNavigate } from "react-router-dom";

const QuizzesSurveysPage = () => {
  const navigate = useNavigate();
  const [quizzes, setQuizzes] = useState([]);
  const [surveys, setSurveys] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const API_URL = process.env.REACT_APP_API_URL;

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        setError(null);

        const quizzesResponse = await fetch(`${API_URL}/quizzes/quizzes`);
        if (!quizzesResponse.ok) {
          throw new Error("Failed to fetch quizzes");
        }
        const quizzesData = await quizzesResponse.json();

        const surveysResponse = await fetch(`${API_URL}/quizzes/surveysAll`);
        if (!surveysResponse.ok) {
          throw new Error("Failed to fetch surveys");
        }
        const surveysData = await surveysResponse.json();

        setQuizzes(quizzesData);
        setSurveys(surveysData);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) return <div className="loading">Loading...</div>;
  if (error) return <div className="error">Error: {error}</div>;

  return (
    <div className="app-container">
      <div className="titre">
        <p>Quizzes and Surveys</p>
      </div>

      <div className="QuizSection">
        {quizzes.length === 0 ? (
          <p>No quizzes available.</p>
        ) : (
          quizzes.map((quiz) => (
            <div key={quiz.id} className="Quiz">
              <h2 className="QuizTitle">{quiz.title}</h2>
              <p>{quiz.module_code}</p>
              <p>{quiz.launch ? "Completed" : "Not completed"}</p>
              <p>{quiz.groupe_id}</p>
              <button
                className="Launch"
                onClick={() => navigate(quiz.launch
                  ? `/statSurvey/${quiz.id}`
                  : `/addQuiz${quiz.type_quizz}/${quiz.id}`)}
              >
                {quiz.launch ? "Statistics" : "Launch"}
              </button>
            </div>
          ))
        )}
      </div>

      <div className="SurveySection">
        {surveys.length === 0 ? (
          <p>No surveys available.</p>
        ) : (
          surveys.map((survey) => (
            <div key={survey.id} className="Survey">
              <h2 className="SurveyTitle">{survey.title}</h2>
              <p>{survey.groupe_id || "N/A"}</p>
              <button
                className="LaunchS"
                onClick={() => navigate(`/Statsurvey/${survey.id}`)}
              >
                Statistics
              </button>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default QuizzesSurveysPage;
