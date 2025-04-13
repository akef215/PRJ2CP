import React from 'react';
import './Select.css';
import Frame1 from '../images/Frame_1.png';
import Frame2 from '../images/Frame_2.png';
import Frame3 from '../images/Frame_3.png';
import Frame4 from '../images/Frame_4.png';
import Frame5 from  '../images/Frame_5.png';
import BtnX from './pic/btnX.png';
import { useNavigate } from 'react-router-dom';

const Select = () => {
  const navigate = useNavigate();
  const handleButtonClick = (imageNumber) => {
    console.log(`Button clicked for image ${imageNumber}`);
  };

  const handleCloseButtonClick = () => {
    navigate("/homePage");
  };

  const buttonData = [
    { id: 1, image: Frame1, text: 'Create quiz', link: 'createQuiz' },
    { id: 2, image: Frame2, text: 'Add Module', link: 'addModule' },
    { id: 3, image: Frame3, text: 'Add class', link: 'addClass' },
    { id: 4, image: Frame4, text: 'Create survey', link: 'createSurvey' },
    { id: 5, image: Frame5, text: 'Add Students', link: 'addClassCSV' },
  ];

  return (
    <div className="outerRectangle">
      <div className="innerRectangle">
        <div className='btn-container'>
        <button className="close-btn" onClick={handleCloseButtonClick}>
  <img src={BtnX} alt="close" />
         </button >
         </div>
        
        <div className="rectangle-container">
          {buttonData.map((item) => (
            <button
              key={item.id}
              className="rectangle-item"
              onClick={() => navigate(`../${item.link}`)}
            >
              <img src={item.image} alt={`${item.text} icon`} />
              <p>{item.text}</p>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Select;