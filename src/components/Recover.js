import React, { useState } from 'react';
import loginImage from './pic/logpic.png';
import GoogleIcon from './pic/googlepic.png';
import './Login.css';
import { Link } from 'react-router-dom';

function Recover() {
  const [userEmail, setUserEmail] = useState('');
  const [verificationCode, setVerificationCode] = useState('');
  const [message, setMessage] = useState('');
  const [step, setStep] = useState(1); // 1 = send code, 2 = verify

  const handleSendCode = async () => {
    try {
      const response = await fetch('http://127.0.0.1:8000/auth/send-code', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ email: userEmail })
      });

      if (response.ok) {
        setMessage('Code sent successfully to your email!');
        setStep(2);
      } else if (response.status === 404) { // Email not found
        setMessage('This email is not registered. You can <Link to="/new-account">create a new account</Link>.');
      } else {
        setMessage('Failed to send code. Please check your email.');
      }
    } catch (error) {
      setMessage('Error sending code.');
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    try {
      const response = await fetch('http://127.0.0.1:8000/auth/verify-code', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          email: userEmail,
          code: verificationCode
        })
      });

      if (response.ok) {
        setMessage('Code verified. You can now reset your password.');
        // tu peux rediriger ici ou afficher un champ pour nouveau mot de passe
      } else {
        setMessage('Invalid verification code.');
      }
    } catch (error) {
      setMessage('Error verifying code.');
    }
  };

  return (
    <div className="login-page" style={{ backgroundColor: '#e2f8fb' }}>
      <div className="image-section">
        <img src={loginImage} alt="Login Illustration" className="login-image" />
      </div>

      <div className="form-section">
        <div className="white-box">
          <div className="login-box">
            <h2 className="log-acc">Recover Account</h2>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label htmlFor="work-email">Esi.dz Email</label>
                <input
                  type="email"
                  id="work-email"
                  value={userEmail}
                  onChange={(e) => setUserEmail(e.target.value)}
                  required
                />
              </div>

              {step === 2 && (
                <div className="form-group">
                  <label htmlFor="verification-code">Verification Code</label>
                  <input
                    type="text"
                    id="verification-code"
                    value={verificationCode}
                    onChange={(e) => setVerificationCode(e.target.value)}
                    required
                  />
                </div>
              )}

              {step === 1 ? (
                <button type="button" className="send-code-btn" onClick={handleSendCode}>
                  Send Code
                </button>
              ) : (
                <button type="submit" id="login">Verify</button>
              )}
            </form>

            {message && (
              <p style={{ marginTop: '10px', color: 'darkblue' }} dangerouslySetInnerHTML={{ __html: message }} />
            )}
          </div>

          <div className="auth-options">
            <div className="google-section">
              <p id="or">Or using Google</p>
              <div className="google-login">
                <button>
                  <img src={GoogleIcon} alt="Google illustration" />
                  Login with Google
                </button>
              </div>

              <p>Back to <Link to="/">Login</Link></p>
              <p>Don't have an account? <Link to="/new-account">Create Account</Link></p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Recover;
