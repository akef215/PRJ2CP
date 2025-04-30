import React, { useEffect, useState } from "react";
import "./styles/Profile.css";
import logo from "../images/logo _final.png";
import user from "../images/user.png";
import Image from "../images/image 1.png";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { customFetch } from "../customFetch";
import { Navigate } from "react-router-dom";

const Profile = () => {
  const [profile, setProfile] = useState({
    fullName: "",
    email: "",
    identifier: "",
    image: user,
  });
  const API_URL = process.env.REACT_APP_API_URL;

  const [name, setName] = useState("");
  const [email, setEmail] = useState("");

  useEffect(() => {
    const savedImage = localStorage.getItem("profileImage");
    if (savedImage) {
      setProfile((prev) => ({ ...prev, image: savedImage }));
    }

    // Ton fetch existant
      customFetch(`${API_URL}/teachers/me`)
        .then(res => res?.json())
        .then(data => {
          if (data) {
            setName(data.name);
            setEmail(data.email);
          }
        })
        .catch(error => console.error('Erreur lors du fetch :', error));
    }, []);

  const toBase64 = (file) =>
    new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => resolve(reader.result);
      reader.onerror = (error) => reject(error);
    });

  const handleFileChange = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    try {
      const base64 = await toBase64(file);

      // ⬇️ on stocke dans localStorage
      localStorage.setItem("profileImage", base64);

      // ⬇️ on met à jour le state
      setProfile((prev) => ({ ...prev, image: base64 }));

      // (optionnel) upload sur backend si nécessaire
      const formData = new FormData();
      formData.append("image", file);
      await axios.post(`${API_URL}/profile/upload-image`, formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });
    } catch (err) {
      console.error("Erreur lors du traitement de l'image :", err);
    }
  };

  const navigate = useNavigate();
  return (
    <div>
      {/* Barre de navigation */}
      <div className='Nav'>
        <div className='Nav-Logo'>
          <img src={logo} alt='Logo'/>
        </div>
       <div className='Nav-Menu'>
        <p onClick={() => {navigate("../homepage")}} className={'nav-item'}>Home</p>
        <p onClick={() => {navigate("../stats")}} className={'nav-item'}>Stats</p>
        <p onClick={() => {navigate("../quizPage")}} className={'nav-item'}>Quizzes</p>
        <p onClick={() => {navigate("../profile")}} className={'nav-item active'}>Profile</p>
        </div>
      </div>
      {/* Upload image */}
      <div className="im-containter">
        {/*<button className="add-image" onClick={() => document.getElementById('fileInput').click()}>
          <img src={Image} alt='add Pic' />
        </button>*/}
      </div>
      {/* Profile icon */}
      <div className="profile-iconP">
        <img
          src={profile.image}
          alt="User"
          onClick={() => document.getElementById("fileInput").click()}
        />
        <input
          type="file"
          id="fileInput"
          className="file-input"
          onChange={handleFileChange}
        />
      </div>

      {/* Info container */}
      <div className="rectContainer">
        <div className="msg-welcome">
          <p>Welcome {name || "Teacher Name"}</p>
        </div>

        <div className="Menu">
          <ul className="list-elem">
            <p>Edit Profile</p>
          </ul>
          <ul className="list-elem">
            <p>{name}</p>
          </ul>
          <ul className="list-elem">
            <p>{email}</p>
          </ul>
          <ul className="list-elem">
            <p>Change Password</p>
          </ul>
          <ul className="list-elem red" onClick={() => {localStorage.removeItem("token"); window.location.reload();}}>
            <p>Log Out</p>
          </ul>
        </div>
      </div>
    </div>
  );
};

export default Profile;
