import React, { useState } from 'react';
import NavbarT1 from './NavBarT1.js';
import SidebarT1 from './SideBarT1.js';
import './SurveyNext.css';
import Image from '../images/image 1.png';
import CheckIcon from '../images/Rectangle 21.png';
import Tick from '../images/Vector 2.png';

const SurveyNext = () => {
  const [showTicks, setShowTicks] = useState([false, false]);
  const [questions, setQuestions] = useState([
    { id: 1, text: 'Option 1' },
    { id: 2, text: 'Option 2' },
  ]);

  const handleCheckIconClick = (index) => {
    const newShowTicks = [...showTicks];
    newShowTicks[index] = !newShowTicks[index];
    setShowTicks(newShowTicks);
  };

  const handleAddOption = () => {
    const newOption = { id: questions.length + 1, text: `Option ${questions.length + 1}` };
    setQuestions([...questions, newOption]);
  };

  return (
    <div>
      <NavbarT1 />
      <SidebarT1 />
      <div className="btn-options">
        <button className="btn-sec"><p>Cancel</p></button>
        <button className="btn-sec"><p>Complete</p></button>
      </div>

      <div className="rectangleExtr">
        <button className="btn-image">
          <p>question?</p>
        </button>
        <div className="rectangleIntr">
          {questions.map((question, index) => (
            <div className="rectangle-item" key={question.id}>
              <div className="answer-top-row">
                <button
                  className="btn-check"
                  onClick={() => handleCheckIconClick(index)}
                >
                  <img src={CheckIcon} alt="Check" className="check-icon" />
                  {showTicks[index] && (
                    <img src={Tick} alt="Tick" className="tick-icon" />
                  )}
                </button>
                <div className="answer-content">
                  <p>{question.text}</p>
                </div>
              </div>
            </div>
          ))}
         
        </div>
        <button className="btn-addAnswr" onClick={handleAddOption}>
            Add Option
          </button>
      </div>
    </div>
  );
};

export default SurveyNext;