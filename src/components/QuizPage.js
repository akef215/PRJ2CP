import { useState, useEffect } from 'react';
import './styles/QuizPage.css';

const QuizzesSurveysPage = () => {
  // State for data
  const [quizzes, setQuizzes] = useState([]);
  const [surveys, setSurveys] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // States for add forms
  const [newQuiz, setNewQuiz] = useState({
    name: '',
    chapter: '',
    subject: ''
  });
  const [newSurvey, setNewSurvey] = useState('');
  const [addingQuiz, setAddingQuiz] = useState(false);
  const [addingSurvey, setAddingSurvey] = useState(false);

  // Initial data fetch
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        setError(null);

        const quizzesResponse = await fetch('http://127.0.0.1:8000/quizzes/available');
        if (!quizzesResponse.ok) {
          throw new Error('Failed to fetch quizzes');
        }
        const quizzesData = await quizzesResponse.json();

        const surveysResponse = await fetch('http://127.0.0.1:8000/feedback/');
        if (!surveysResponse.ok) {
          throw new Error('Failed to fetch surveys');
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

  // Add a quiz
  const handleAddQuiz = async () => {
    try {
      setError(null);
      if (!newQuiz.name || !newQuiz.chapter || !newQuiz.subject) {
        setError('Veuillez remplir tous les champs du quiz.');
        return;
      }

      const response = await fetch('http://127.0.0.1:8000/quizzes/add_quiz', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ ...newQuiz, type: 'full time' })
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.detail || 'Échec de l’ajout du quiz');
      }

      const addedQuiz = await response.json();
      setQuizzes([...quizzes, addedQuiz]);
      setNewQuiz({ name: '', chapter: '', subject: '' });
      setAddingQuiz(false);
    } catch (err) {
      setError(err.message);
    }
  };

  // Add a survey
  const handleAddSurvey = async () => {
    try {
      setError(null);
      if (!newSurvey) {
        setError('Veuillez saisir le nom du survey.');
        return;
      }

      const response = await fetch('http://127.0.0.1:8000/feedback/', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: newSurvey })
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.detail || 'Échec de l’ajout du survey');
      }

      const addedSurvey = await response.json();
      setSurveys([...surveys, addedSurvey]);
      setNewSurvey('');
      setAddingSurvey(false);
    } catch (err) {
      setError(err.message);
    }
  };

  // Delete a whole quiz
  const handleDeleteQuiz = async (quizId) => {
    try {
      setError(null);
      const response = await fetch(`http://127.0.0.1:8000/quizzes/delete/${quizId}`, {
        method: 'DELETE'
      });
      if (!response.ok) {
        throw new Error('Échec de la suppression du quiz');
      }
      setQuizzes(quizzes.filter(quiz => quiz.id !== quizId));
    } catch (err) {
      setError(err.message);
    }
  };

  // Delete a question using quizId and questionId
  const handleDeleteQuestion = async (quizId, questionId) => {
    try {
      setError(null);
      const response = await fetch(`http://127.0.0.1:8000/quizzes/${quizId}/delete_questions/${questionId}`, {
        method: 'DELETE'
      });
      if (!response.ok) {
        throw new Error('Échec de la suppression de la question');
      }
      // Option 1: Refetch all quizzes
      const quizzesResponse = await fetch('http://127.0.0.1:8000/quizzes/available');
      const quizzesData = await quizzesResponse.json();
      setQuizzes(quizzesData);

      // Option 2: If you prefer, update the state locally.
    } catch (err) {
      setError(err.message);
    }
  };

  // Delete a choice using quizId, questionId, and choiceId
  const handleDeleteChoice = async (quizId, questionId, choiceId) => {
    try {
      setError(null);
      const response = await fetch(
        `http://127.0.0.1:8000/quizzes/${quizId}/delete_questions/${questionId}/delete_choices/${choiceId}`,
        { method: 'DELETE' }
      );
      if (!response.ok) {
        throw new Error('Échec de la suppression du choix');
      }
      // Refetch quizzes to update data
      const quizzesResponse = await fetch('http://127.0.0.1:8000/quizzes/available');
      const quizzesData = await quizzesResponse.json();
      setQuizzes(quizzesData);
    } catch (err) {
      setError(err.message);
    }
  };

  if (loading) return <div className="loading">Loading...</div>;
  if (error) return <div className="error">Error: {error}</div>;

  return (
    <div className="app-container">
      <h1 className="main-title">Quiz 2</h1>
      {error && <div className="error-message">{error}</div>}

      {/* Quizzes Section */}
      <section className="section-container">
        <div className="section-header">
          <h2 className="section-title">Quizzes</h2>
          <button onClick={() => setAddingQuiz(!addingQuiz)} className="add-button quiz-button">
            {addingQuiz ? 'Cancel' : 'Add Quiz'}
          </button>
        </div>

        {addingQuiz && (
          <div className="add-form">
            <input
              type="text"
              placeholder="Quiz name"
              value={newQuiz.name}
              onChange={(e) => setNewQuiz({ ...newQuiz, name: e.target.value })}
              className="form-input"
              required
            />
            <input
              type="number"
              placeholder="Chapter number"
              value={newQuiz.chapter}
              onChange={(e) => setNewQuiz({ ...newQuiz, chapter: e.target.value })}
              className="form-input"
              required
              min="1"
            />
            <input
              type="text"
              placeholder="Subject"
              value={newQuiz.subject}
              onChange={(e) => setNewQuiz({ ...newQuiz, subject: e.target.value })}
              className="form-input"
              required
            />
            <div className="form-buttons">
              <button onClick={handleAddQuiz} className="save-button">
                Save Quiz
              </button>
            </div>
          </div>
        )}

        <div className="table-container">
          <table className="quizzes-table">
            <thead>
              <tr>
                <th>Quiz name</th>
                <th>Chapter</th>
                <th>Type</th>
                <th>State</th>
                <th>Subject</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {quizzes.map((quiz) => (
                <tr key={quiz.id}>
                  <td>{quiz.name}</td>
                  <td>Chapter {quiz.chapter}</td>
                  <td>{quiz.type}</td>
                  <td className={`state ${quiz.state.replace(' ', '-')}`}>{quiz.state}</td>
                  <td>{quiz.subject}</td>
                  <td>
                    <button onClick={() => handleDeleteQuiz(quiz.id)} className="delete-button">
                      Delete Quiz
                    </button>

                    {/* If quiz has questions, render them */}
                    {quiz.questions && quiz.questions.map((question) => (
                      <div key={question.id}>
                        <span>{question.text}</span>
                        <button onClick={() => handleDeleteQuestion(quiz.id, question.id)} className="delete-button">
                          Delete Question
                        </button>
                        {/* Render choices for each question */}
                        {question.choices && question.choices.map((choice) => (
                          <div key={choice.id}>
                            <span>{choice.text}</span>
                            <button
                              onClick={() => handleDeleteChoice(quiz.id, question.id, choice.id)}
                              className="delete-button"
                            >
                              Delete Choice
                            </button>
                          </div>
                        ))}
                      </div>
                    ))}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>

      {/* Surveys Section */}
      <section className="section-container">
        <div className="section-header">
          <h2 className="section-title">Surveys</h2>
          <button onClick={() => setAddingSurvey(!addingSurvey)} className="add-button survey-button">
            {addingSurvey ? 'Cancel' : 'Add Survey'}
          </button>
        </div>

        {addingSurvey && (
          <div className="add-form">
            <input
              type="text"
              placeholder="Survey name"
              value={newSurvey}
              onChange={(e) => setNewSurvey(e.target.value)}
              className="form-input"
              required
            />
            <div className="form-buttons">
              <button onClick={handleAddSurvey} className="save-button">
                Save Survey
              </button>
            </div>
          </div>
        )}

        <div className="table-container">
          <table className="surveys-table">
            <thead>
              <tr>
                <th>Survey name</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              {surveys.map((survey) => (
                <tr key={survey.id}>
                  <td>{survey.name}</td>
                  <td>
                    <button
                      className="view-results-button"
                      onClick={() => console.log(`View results for survey ${survey.id}`)}
                    >
                      View results
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
};

export default QuizzesSurveysPage;
