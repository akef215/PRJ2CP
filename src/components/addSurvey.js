import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import NavbarT1 from "./NavBarT1";
import "./styles/QuizT1.css";

const initialQuestion = {
  showTicks: [],
  showBorders: [],
  selectedImages: [null, null, null, null, null],
  statement: "",
  duree: 0,
  id: null,
  choices: [], // Nouvelle propriété pour stocker les choix
};

const CreateQuizT1 = () => {
  const [questionsData, setQuestionsData] = useState([]);
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const id = useParams();
  const quizId = id.id;
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
      const res = await fetch(
        `http://localhost:8000/quizzes/${quizId}/questions`
      );
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
        `http://localhost:8000/quizzes/${quizId}/${questionId}/choices`
      );
      const data = await res.json();
      const showTicks = data.map((choice, i) => choice.is_correct || false);
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
    const updated = [...questionsData];
    updated[currentQuestionIndex] = {
      ...updated[currentQuestionIndex],
      ...newData,
    };
    setQuestionsData(updated);
  };

  const toggleTickAndBorder = (index) => {
    const updatedTicks = [...currentData.showTicks];
    const updatedBorders = [...currentData.showBorders];

    updatedTicks[index] = !updatedTicks[index];
    updatedBorders[index] = !updatedBorders[index];

    updateCurrentData({ showTicks: updatedTicks, showBorders: updatedBorders });
  };

  const handleImageUpload = (event, index) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        const updatedImages = [...currentData.selectedImages];
        updatedImages[index] = reader.result;
        updateCurrentData({ selectedImages: updatedImages });
      };
      reader.readAsDataURL(file);
    }
  };

  const handleCloseImage = (index) => {
    const updatedImages = [...currentData.selectedImages];
    updatedImages[index] = null;
    updateCurrentData({ selectedImages: updatedImages });
  };

  const addNewQuestion = async () => {
    try {
      const response = await fetch(
        `http://localhost:8000/quizzes/${quizId}/add_questions`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            id: questionsData.length + 1,
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
        choices: [],
        showTicks: [],
        showBorders: [],
      };

      setQuestionsData([...questionsData, newQuestion]);
      setCurrentQuestionIndex(questionsData.length);
    } catch (error) {
      console.error("Erreur ajout question :", error);
    }
    window.location.reload();
  };
  const navigate = useNavigate();
  const addChoice = async () => {
    const question = questionsData[currentQuestionIndex];
    if (!question?.id) return;

    try {
      const res = await fetch(
        `http://localhost:8000/quizzes/${quizId}/add_questions/${question.id}/add_choices`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            id: question.choices.length + 1,
            score: 0,
            answer: `Answer ${question.choices.length + 1}`,
          }),
        }
      );

      if (!res.ok) throw new Error("Erreur ajout réponse");

      const newChoice = await res.json();
      fetchChoices(question.id, currentQuestionIndex);
    } catch (err) {
      console.error("Erreur ajout réponse :", err);
    }
  };

  const currentData = questionsData[currentQuestionIndex] || initialQuestion;
  const handleCancelClick = async () => {
    if (!quizId) {
      console.error("Invalid quizId");
      return;
    }

    try {
      const response = await fetch(
        `http://localhost:8000/quizzes/delete/${quizId}`,
        {
          method: "DELETE",
        }
      );

      if (response.status === 200) {
        console.log("Quiz supprimé avec succès !");
        navigate("/select");
      } else {
        console.error(
          "Erreur lors de la suppression du quiz :",
          response.status
        );
      }
    } catch (err) {
      console.error("Erreur d'envoi de la requête :", err);
    }
  };

  return (
    <div>
      <NavbarT1 />
      <div className="quiz-container">
        <div className="left-panel">
          <button className="add-question" onClick={addNewQuestion}>
            + Add question
          </button>
          {questionsData.map((_, index) => (
            <div
              className={`question-item ${
                index === currentQuestionIndex ? "active-question" : ""
              }`}
              key={index}
              onClick={() => setCurrentQuestionIndex(index)}
            >
              Question {index + 1}
            </div>
          ))}
        </div>

        <div className="right-panel">
          <div className="answers-section">
            <input
              type="text"
              className="question-itemTest"
              value={currentData.statement}
              onChange={async (e) => {
                const newStatement = e.target.value;
                updateCurrentData({ statement: newStatement });

                try {
                  await fetch(
                    `http://localhost:8000/quizzes/${quizId}/modify_questions/${currentData.id}`,
                    {
                      method: "PUT",
                      headers: {
                        "Content-Type": "application/json",
                      },
                      body: JSON.stringify({
                        statement: newStatement,
                        duree: currentData.duree || 0, // ou duree modifiable plus tard
                      }),
                    }
                  );
                } catch (err) {
                  console.error("Erreur de mise à jour de la question :", err);
                }
              }}
            />
            {currentData.choices.map((choice, i) => (
              <div
                key={i}
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

                    // 1. Update frontend state
                    const updatedChoices = [...currentData.choices];
                    updatedChoices[i] = {
                      ...updatedChoices[i],
                      answer: updatedAnswer,
                    };
                    updateCurrentData({ choices: updatedChoices });
                    // 2. Update backend
                    try {
                      await fetch(
                        `http://localhost:8000/quizzes/${quizId}/modify_questions/${currentData.id}/modify_choices/${i+1}`,
                        {
                          method: "PUT",
                          headers: {
                            "Content-Type": "application/json",
                          },
                          body: JSON.stringify({
                            score: choice.score || 0,
                            answer: updatedAnswer,
                          }),
                        }
                      );
                    } catch (err) {
                      console.error(
                        "Erreur lors de la mise à jour du choix :",
                        err
                      );
                    }
                  }}
                  placeholder={`Réponse ${i + 1}`}
                />
              </div>
            ))}

            <button className="btn-addAnswrQ1" onClick={addChoice}>
              Add Option
            </button>
          </div>

          <div className="footer-buttons">
            <div className="right-btns">
              <button className="btn-sec" onClick={handleCancelClick}>
                Cancel
              </button>
              <button className="btn-sec" onClick={() => navigate("../pageType2")}>Complete</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CreateQuizT1;
