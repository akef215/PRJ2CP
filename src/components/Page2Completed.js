import React from 'react'
import './styles/PageType2.css' ;
import { useNavigate } from 'react-router-dom';
const Page2Completed = () => {
  const navigate = useNavigate();
  return (
    <div >
        <div className='rectangle'>
            <p> Quiz Completed Successfully</p>
        </div> 
        <div className='btns'>
            <button className='btn1'>Check stats</button>
            <button className='btn2' onClick={() => navigate('/homePage')}>Go Home</button>
        </div>
    </div>
  )
}

export default Page2Completed