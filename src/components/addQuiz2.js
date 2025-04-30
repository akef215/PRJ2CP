import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import NavbarT1 from "./NavBarT1";
import Delete from "../images/delete.png";
import "./styles/QuizT1.css";

const initialQuestion = {
  showTicks: [],
  showBorders: [],
  selectedImages: [null, null, null, null, null],
  statement: "",
  duree: 0,
  id: null,
  choices: [],
};

const AddQuiz2 = () => {
  const [questionsData, setQuestionsData] = useState([]);
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const { id: quizId } = useParams();
  const navigate = useNavigate();
  const API_URL = process.env.REACT_APP_API_URL;

  useEffect(() => {
    fetchQuestions();
  }, []);

  useEffect(() => {
    const question = questionsData[currentQuestionIndex];
    if (question?.id) {
      fetchChoices(question.id, currentQuestionIndex);
    }
  }, [currentQuestionIndex]);

  const fetchQuestions = async () => {
    try {
      const res = await fetch(`${API_URL}/quizzes/${quizId}/questions`);
      const questions = await res.json();
      const formatted = questions.map((q) => ({
        ...initialQuestion,
        id: q.question_id ?? q.id,
        statement: q.statement,
        duree: q.duree,
      }));
      setQuestionsData(formatted);
    } catch (error) {
      console.error("Erreur chargement questions :", error);
    }
  };

  const fetchChoices = async (questionId, index) => {
    try {
      const res = await fetch(
        `${API_URL}/quizzes/${quizId}/${questionId}/choices`
      );
      const data = await res.json();

      const showTicks = data.map((choice) => choice.is_correct || false);
      const showBorders = showTicks.map(Boolean);

      const updated = [...questionsData];
      updated[index] = {
        ...updated[index],
        choices: data,
        showTicks,
        showBorders,
      };
      setQuestionsData(updated);
    } catch (error) {
      console.error("Erreur chargement réponses :", error);
    }
  };

  const updateCurrentData = (newData) => {
    setQuestionsData((prev) => {
      const updated = [...prev];
      updated[currentQuestionIndex] = {
        ...updated[currentQuestionIndex],
        ...newData,
      };
      return updated;
    });
  };

  const handleDeleteChoice = async (choiceId) => {
    const updatedChoices = currentData.choices.filter((c) => c.id !== choiceId);
    updateCurrentData({ choices: updatedChoices });

    try {
      await fetch(`${API_URL}/quizzes/delete_choices/${choiceId}`, {
        method: "DELETE",
      });
    } catch (err) {
      console.error("Erreur lors de la suppression du choix :", err);
    }
  };

  const handleDeleteQuestion = async (qstnId) => {
    const updatedQuestions = questionsData.filter((q) => q.id !== qstnId);
    setQuestionsData(updatedQuestions);

    // Optionnel : ajuster l’index courant
    if (currentQuestionIndex >= updatedQuestions.length) {
      setCurrentQuestionIndex(updatedQuestions.length - 1);
    }

    try {
      await fetch(`${API_URL}/quizzes/delete_questions/${qstnId}`, {
        method: "DELETE",
      });
    } catch (err) {
      console.error("Erreur lors de la suppression de la question :", err);
    }
  };

  const addNewQuestion = async () => {
    try {
      const response = await fetch(
        `${API_URL}/quizzes/${quizId}/add_questions`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            statement: `Question ${questionsData.length + 1}`,
            duree: 0,
          }),
        }
      );
      const data = await response.json();
      const newQuestion = {
        ...initialQuestion,
        id: data.id ?? data.question_id ?? null,
        statement: data.statement,
        duree: data.duree,
      };

      setQuestionsData([...questionsData, newQuestion]);
      setCurrentQuestionIndex(questionsData.length);
    } catch (error) {
      console.error("Erreur ajout question :", error);
    }
  };

  const addChoice = async () => {
    const question = questionsData[currentQuestionIndex];
    if (!question?.id) return;

    try {
      const res = await fetch(
        `${API_URL}/quizzes/${quizId}/${currentData.id}/add_choices`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            score: 0,
            answer: `Answer ${question.choices.length + 1}`,
          }),
        }
      );
      if (!res.ok) throw new Error("Erreur ajout réponse");

      fetchChoices(question.id, currentQuestionIndex);
    } catch (err) {
      console.error("Erreur ajout réponse :", err);
    }
  };

  const handleCancelClick = async () => {
    try {
      const res = await fetch(`${API_URL}/quizzes/delete/${quizId}`, {
        method: "DELETE",
      });
      if (res.ok) navigate("/select");
      else console.error("Erreur suppression quiz :", res.status);
    } catch (err) {
      console.error("Erreur requête suppression :", err);
    }
  };

  const currentData = questionsData[currentQuestionIndex] || initialQuestion;

  return (
    <div>
      <NavbarT1 type="Quiz" id={quizId} />
      <div className="quiz-container">
        <div className="left-panel">
          <button className="add-question" onClick={addNewQuestion}>
            + Add question
          </button>
          {questionsData.map((_, index) => (
            <div
              key={index}
              className={`question-item ${
                index === currentQuestionIndex ? "active-question" : ""
              }`}
              onClick={() => setCurrentQuestionIndex(index)}
            >
              Question {index + 1}
            </div>
          ))}
        </div>

        <div className="right-panel">
          <div className="answers-section">
            <div className="questions-section">
              <input
                type="text"
                className="question-itemTest"
                value={currentData.statement}
                placeholder="Question Statement"
                onChange={async (e) => {
                  const newStatement = e.target.value;
                  updateCurrentData({ statement: newStatement });

                  try {
                    await fetch(
                      `${API_URL}/quizzes/modify_questions/${currentData.id}`,
                      {
                        method: "PUT",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({
                          statement: newStatement,
                          duree: currentData.duree,
                        }),
                      }
                    );
                  } catch (err) {
                    console.error("Erreur mise à jour question :", err);
                  }
                }}
              />
            </div>

            {currentData.choices.map((choice, i) => (
              <div
                key={choice.id}
                className={`d-flex align-items-center gap-2 mb-2 rectangle-itemQ1 ${
                  currentData.showBorders[i] ? "active-border" : ""
                }`}
              >
                <input
                  type="text"
                  className="form-control"
                  value={choice.answer}
                  onChange={async (e) => {
                    const updatedAnswer = e.target.value;
                    const updatedChoices = [...currentData.choices];
                    updatedChoices[i] = {
                      ...updatedChoices[i],
                      answer: updatedAnswer,
                    };
                    updateCurrentData({ choices: updatedChoices });

                    try {
                      await fetch(
                        `${API_URL}/quizzes/modify_choices/${choice.id}`,
                        {
                          method: "PUT",
                          headers: { "Content-Type": "application/json" },
                          body: JSON.stringify({
                            score: choice.score || 0,
                            answer: updatedAnswer,
                          }),
                        }
                      );
                    } catch (err) {
                      console.error("Erreur mise à jour choix :", err);
                    }
                  }}
                  placeholder={`Réponse ${i + 1}`}
                />

                <input
                  type="text"
                  className="form-control-score"
                  style={{ width: "80px" }}
                  value={choice.score?.toString() ?? ""}
                  onChange={async (e) => {
                    const newScore = e.target.value;
                    if (isNaN(Number(newScore)) && newScore !== "") return;

                    const updatedChoices = [...currentData.choices];
                    updatedChoices[i] = {
                      ...updatedChoices[i],
                      score: newScore,
                    };
                    updateCurrentData({ choices: updatedChoices });

                    if (newScore !== "") {
                      try {
                        await fetch(
                          `${API_URL}/quizzes/modify_choices/${choice.id}`,
                          {
                            method: "PUT",
                            headers: { "Content-Type": "application/json" },
                            body: JSON.stringify({
                              score: parseFloat(newScore),
                              answer: choice.answer,
                            }),
                          }
                        );
                      } catch (err) {
                        console.error("Erreur mise à jour score :", err);
                      }
                    }
                  }}
                  placeholder="Score"
                />

                <img
                  src={Delete}
                  alt="Delete"
                  style={{
                    width: "20px",
                    height: "20px",
                    cursor: "pointer",
                    filter: "brightness(0) invert(1)",
                  }}
                  onClick={() => handleDeleteChoice(choice.id)}
                />
              </div>
            ))}

            <button className="btn-addAnswrQ1" onClick={addChoice}>
              Add Option
            </button>

            <button
              className="btn-addAnswrQ2"
              onClick={() => handleDeleteQuestion(currentData.id)}
            >
              Delete Question
            </button>
          </div>

          <div className="footer-buttons">
            <div className="right-btns">
              <button className="btn-sec" onClick={handleCancelClick}>
                Cancel
              </button>
              <button
                className="btn-sec"
                onClick={() => navigate("../pageType2")}
              >
                Complete
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AddQuiz2;
