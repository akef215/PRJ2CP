import { useState } from 'react';
import './QuizPage.css';

const Reclamations = () => {
  const [questions, setQuestions] = useState([
    {
      id: 1,
      text: "What is the binary equivalent of the decimal number 10?",
      answers: ["1010", "1100", "1001", "0010"],
      notes: ["Student Note about the reclamation"]
    },
    {
      id: 2,
      text: "What is the hexadecimal equivalent of the decimal number 255?",
      answers: ["FF", "F0", "FA", "00"],
      notes: ["Another important note here"]
    },
    {
      id: 3,
      text: "What is 2's complement of 00001010?",
      answers: ["11110110", "00001011", "11110101", "11111111"],
      notes: ["Note example 3"]
    },
    {
      id: 4,
      text: "How many bits in a byte?",
      answers: ["8", "4", "16", "32"],
      notes: ["Note example 4"]
    }
  ]);

  const [newNote, setNewNote] = useState({ questionId: null, text: "" });

  const addNote = (questionId) => {
    if (newNote.text.trim()) {
      setQuestions(questions.map(q => 
        q.id === questionId 
          ? { ...q, notes: [...q.notes, newNote.text] } 
          : q
      ));
      setNewNote({ questionId: null, text: "" });
    }
  };

  return (
    <div className="reclamations-container">
      <h1>Reclamations</h1>
      
      <div className="questions-section">
        <div className="questions-grid">
          {questions.map((question) => (
            <div key={question.id} className="question-block">
              <div className="question-content">
                <div className='qst-box'>
                  <h3>Question</h3> 
                  <p>{String(question.id).padStart(2, '0')}: {question.text}</p>
                </div>
                
                {/* Grille des réponses en 2 colonnes */}
                <div className="answers-grid">
                  {question.answers.map((answer, index) => (
                    <label key={index} className="answer-item">
                      <input type="checkbox" />
                      <span>{answer}</span>
                    </label>
                  ))}
                </div>
              </div>

              <div className="notes-section">
                <h4>Student Notes</h4>
                {question.notes.map((note, index) => (
                  <div key={index} className="note-block">
                    <p>{note}</p>
                  </div>
                ))}
                
                <div className="add-note-form">
                  <textarea
                    value={newNote.questionId === question.id ? newNote.text : ""}
                    onChange={(e) => setNewNote({ 
                      questionId: question.id, 
                      text: e.target.value 
                    })}
                    placeholder="Add note..."
                  />
                  <button 
                    className='btn-add-note' 
                    onClick={() => addNote(question.id)}
                  >
                    Add Note
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Reclamations;