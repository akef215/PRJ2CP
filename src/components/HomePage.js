import './styles/HomePage.css';
import { useNavigate } from 'react-router-dom';
import logo from '../images/logo _final.png';
import user from '../images/profile.png' ;
import Image1 from '../images/Frame_2.png';
import Image2 from '../images/Frame_3.png';
import Image3 from '../images/Frame_1.png';
import Image4 from '../images/Frame_4.png';
import { useEffect, useState } from 'react';
import { customFetch } from '../customFetch';

const HomePage = () => {
  const navigate = useNavigate();
  const [name, setName] = useState('');
  useEffect(() => {
    customFetch('http://localhost:8000/teachers/me')
      .then(res => res?.json())
      .then(data => {
        if (data) setName(data.name);
      })
      .catch(error => console.error('Erreur lors du fetch :', error));
  }, []);
  const [profileImage, setProfileImage] = useState(user);

useEffect(() => {
  const savedImage = localStorage.getItem('profileImage');
  if (savedImage) {
    setProfileImage(savedImage);
  }
}, []);
  return (
    <>
        <div className='Nav'>
            <div className='Nav-Logo'><img src={logo} alt='Logo'/></div>
            <div className='Nav-Menu'>
                <p onClick={() => {navigate("../homepage")}} className={'nav-item active'}>home</p>
                <p onClick={() => {navigate("../stats")}} className={'nav-item'}>stats</p>
                <p onClick={() => {navigate("../pageType2")}} className={'nav-item'}>Present</p>
                <p onClick={() => {navigate("../profile")}} className={'nav-item'}>Profile</p>
            </div>
        </div>

        <div className='profile-icon'>
            <img src={profileImage} alt='User'/>
        </div>

        <div className='msg-welcome'>
            <p>Welcome {name}</p>
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
            <div className='part' onClick={() => navigate("../pageType2")}><img src={Image1} /><p>Present</p></div>
            <div className='part' onClick={() => navigate('../select')}><img src={Image2} /><p>Create</p></div>
            <div className='part'><img src={Image3} onClick={() => navigate("../feedbacks")}/><p>FeedBack</p></div>
            <div className='part'><img src={Image4} onClick={() => navigate("../stats")}/><p>Statistics</p></div>
          </div>
        </div>
    </>
  )
}

export default HomePage;