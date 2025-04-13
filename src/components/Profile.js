import React, { useEffect, useState } from 'react';
import './Profile.css';
import logo from '../images/logo _final.png';
import user from '../images/user.png';
import Image from '../images/image 1.png';
import { Link } from 'react-router-dom';
import axios from 'axios';

const Profile = () => {
  const [profile, setProfile] = useState({
    fullName: '',
    email: '',
    identifier: '',
    image: user,
  });

  useEffect(() => {
    axios.get('http://127.0.0.1::8000/profile') // adapte l'URL si besoin
      .then(res => setProfile(prev => ({ ...prev, ...res.data })))
      .catch(err => console.error('Erreur de chargement du profil', err));
  }, []);

  const handleFileChange = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    const formData = new FormData();
    formData.append("image", file);

    try {
      const res = await axios.post("http://127.0.0.1:8000/profile/upload-image", formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });

      setProfile(prev => ({ ...prev, image: res.data.imageUrl }));
    } catch (err) {
      console.error("Erreur lors de l'upload de l'image :", err);
    }
  };

  return (
    <div>
      {/* Navigation */}
      <div className='Nav'>
        <div className='Nav-Logo'><img src={logo} alt='Logo' /></div>
        <div className='Nav-Menu'>
          <p><Link to="/homepage">home</Link></p>
          <p><Link to="/stats">stats</Link></p>
          <p><Link to="/module">Modules</Link></p>
          <p><Link to="/profile">Profile</Link></p>
        </div>
      </div>

      {/* Profile icon */}
      <div className="profile-icon">
        <img src={profile.image} alt="User" />
      </div>

      {/* Upload image */}
      <div className='im-containter'>
        <button className="add-image" onClick={() => document.getElementById('fileInput').click()}>
          <img src={Image} alt='add Pic' />
        </button>
        <input type="file" id="fileInput" className="file-input" onChange={handleFileChange} />
      </div>

      {/* Info container */}
      <div className='rectContainer'>
        <div className='msg-welcome'>
          <p>Welcome {profile.fullName || "Teacher Name"}</p>
        </div>

        <div className='Menu'>
          <ul className='list-elem'><p>Edit Profile</p></ul>
          <ul className='list-elem'><p>Full name: {profile.fullName}</p></ul>
          <ul className='list-elem'><p>Esi.dz Email: {profile.email}</p></ul>
          <ul className='list-elem'><p>Esi Identifier: {profile.identifier}</p></ul>
          <ul className='list-elem'><p>Change Password</p></ul>
        </div>
      </div>
    </div>
  );
};

export default Profile;
