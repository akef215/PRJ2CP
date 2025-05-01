import React from 'react'
import './styles/PageType2.css' ;
import { useNavigate, useParams } from 'react-router-dom';
const Page2Completed = () => {
  const navigate = useNavigate();
  const {id} = useParams();
  return (
    <div >
        <div className='rectangle'>
            <p> Quiz Completed Successfully</p>
        </div> 
        <div className='btns'>
            <button className='btn1' onClick={() => navigate(`/statSurvey/${id}`)}>Check stats</button>
            <button className='btn2' onClick={() => navigate('/homePage')}>Go Home</button>
        </div>
    </div>
  )
}

export default Page2Completed