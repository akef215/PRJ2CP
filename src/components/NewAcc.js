import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import loginImage from './pic/logpic.png';
import eyeIcon from './pic/show.png';
import './Login.css';

function NewAcc() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [esiId, setEsiId] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError('');

    // Vérification des champs et suppression des espaces superflus
    const trimmedEmail = email.trim();
    if (password !== confirmPassword) {
      setError("Les mots de passe ne correspondent pas");
      return;
    }

    if (!trimmedEmail.endsWith('@esi.dz')) {
      setError("Veuillez utiliser une adresse email se terminant par @esi.dz");
      return;
    }

    setIsLoading(true);
    try {
      const response = await fetch(' http://127.0.0.1:8000/teachers/register', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email: trimmedEmail,
          password,
          esi_id: esiId.trim(),
        }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || "Échec de la création du compte");
      }

      // Optionnel : Utilisation de la réponse si besoin
      // const data = await response.json();
      alert("Compte créé avec succès !");
      navigate('/login'); // Redirection vers la page de connexion
    } catch (error) {
      console.error("Erreur:", error);
      setError(error.message || "Une erreur est survenue lors de la création du compte");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="login-page">
      {/* Section gauche - Image */}
      <div className="image-section">
        <img src={loginImage} alt="Login Illustration" className="login-image" />
      </div>

      {/* Section droite - Formulaire */}
      <div className="form-section">
        <div className="white-box" style={{ marginTop: '-220px' }}>
          <div className="login-box" style={{ marginTop: '-115px', height: '480px' }}>
            <h2 className="log-acc">Create a new Account</h2>

            {error && <div className="error-message">{error}</div>}

            <form onSubmit={handleSubmit}>
              {/* Email */}
              <div className="form-group">
                <label htmlFor="work-email">Esi.dz Email</label>
                <input
                  type="email"
                  id="work-email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  placeholder="Enter your Esi.dz email"
                />
              </div>

              {/* Password */}
              <div className="form-group">
                <label htmlFor="password">Your Password</label>
                <div className="password-container">
                  <input
                    type={showPassword ? 'text' : 'password'}
                    id="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                    placeholder="Enter your password"
                    minLength="6"
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

              {/* Confirm Password */}
              <div className="form-group">
                <label htmlFor="confirm-password" style={{ marginTop: '-30px' }}>
                  Confirm Password
                </label>
                <div className="password-container">
                  <input
                    type={showPassword ? 'text' : 'password'}
                    id="confirm-password"
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    required
                    placeholder="Confirm your password"
                    minLength="6"
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

              {/* ESI Identifier */}
              <div className="form-group">
                <label htmlFor="esi-id" style={{ marginTop: '-30px' }}>Esi Identifier</label>
                <input
                  type="text"
                  id="esi-id"
                  value={esiId}
                  onChange={(e) => setEsiId(e.target.value)}
                  required
                  placeholder="Enter your Esi identifier"
                />
              </div>

              {/* Submit Button */}
              <button 
                type="submit" 
                id="login" 
                style={{ marginTop: '50px' }}
                disabled={isLoading}
              >
                {isLoading ? "Creating account..." : "Create Account"}
              </button>
            </form>

            <div className="login-link">
              <p>Already have an account? <Link to="/login">Login</Link></p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default NewAcc;
