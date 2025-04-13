import React from 'react';
import './HomePage.css'; // Assurez-vous que le chemin est correct
import { Link, useNavigate } from 'react-router-dom';
import logo from '../images/logo _final.png';
import user from '../images/user.png' ;
import Image1 from '../images/Frame_2.png';
import Image2 from '../images/Frame_3.png';
import Image3 from '../images/Frame_1.png';
import Image4 from '../images/Frame_4.png';

const HomePage = () => {
    const navigate = useNavigate();
    const handleClickCreate = () => {
        navigate('../Select');
    }
    const handleModule = () => {
        navigate('../module');
    }
  return (
    <div>

        <div className='Nav'>
            <div className='Nav-Logo'><img src={logo} alt='Logo'/></div>
            <div className='Nav-Menu'>
                <p> <Link to="/homepage">home</Link></p>
                <p><Link to="/stats">stats</Link></p>
                <p>  <Link to="/module">Modules</Link></p>
                <p><Link to="/profile">Profile</Link></p>
            </div>
        </div>
        <div className='profile-icon'>
            <img src={user} alt='User'/>
        </div>
        <div className='msg-welcome'>
            <p>Welcome user</p>
        </div>
        <div className='start-container'>
        <div className='start'>
            <h2>Start your journey here!</h2>
            <p>Where do you want to start?</p>
            </div>
            <div className='logo-icon'><img src={logo} alt='Logo'/></div>
       
        
        
       </div>
       <div className='rectMenu'>
        <div className='menu-container'>
            <div className='part'>
                <img src={Image1} alt='illustrations' />
                <p>  <Link to="/module">Modules</Link> Modules</p></div>
            <div className='part'><img src={Image2} alt='illustrations' /> <p><Link to="/SELECT">Create</Link></p></div>
            <div className='part'><img src={Image3} alt='illustrations' /> <p><Link to="/feedindiv">FeedBack</Link></p></div>
            <div className='part'><img src={Image4} alt='illustrations' />  <p><Link to="/stats">Statistics</Link></p></div>
        </div>
        </div>
    </div>
  )
}

export default HomePage;