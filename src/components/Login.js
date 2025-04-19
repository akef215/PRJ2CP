import React, { useState } from 'react';
import loginImage from './pic/logpic.png';
import eyeIcon from './pic/show.png';
import './styles/Login.css';
import { useNavigate } from 'react-router-dom';

function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setErrorMsg('');

    try {
      const response = await fetch('http://localhost:8000/auth/teachers/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      const data = await response.json();

      if (response.status === 200) {
        // Succès : stocker le token, rediriger...
        localStorage.setItem('token', data.access_token);
        navigate('/homePage');
      } else {
        // Erreur : afficher message
        setErrorMsg(data.detail || 'Erreur de connexion');
        console.log(errorMsg);
      }
    } catch (error) {
      setErrorMsg('Erreur réseau');
    }
  };

  return (
    <div className="login-page" style={{ backgroundColor: '#e2f8fb' }}>
      {/* Section gauche - l'image */}
      <div className="image-section">
        <img src={loginImage} alt="Login Illustration" className="login-image" />
      </div>

      {/* Section droite - Formulaire */}
      <div className="form-section">
        {/* Grand carré blanc */}
        <div className="white-box">
          {/* Carré bleu (contenant le formulaire) */}
          <div className="login-box">
            <h2 className="log-acc">Log into your Account</h2>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label htmlFor="work-email">Work email</label>
                <input
                  type="email"
                  id="work-email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                />
              </div>

              <div className="form-group">
                <label htmlFor="password">Your password</label>
                <div className="password-container">
                  <input
                    type={showPassword ? "text" : "password"}
                    id="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="toggle-password"
                  >
                    <img src={eyeIcon} alt="Toggle Password Visibility" />
                  </button>
                </div>
              </div>

              {/* Bouton Login */}
              <button type="submit" id="login">
                Login
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Login;