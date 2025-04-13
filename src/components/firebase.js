// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getAuth, GoogleAuthProvider } from 'firebase/auth';

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCi077qhwtkjsRgifwfqkhBjrcKTMjlBbk",
  authDomain: "quiz-6f9fe.firebaseapp.com",
  projectId: "quiz-6f9fe",
  storageBucket: "quiz-6f9fe.appspot.com", // Corrigé
  messagingSenderId: "735089531140",
  appId: "1:735089531140:web:9765becd9b938a97279851",
  measurementId: "G-YG6QM4EPEL"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

// Initialize Firebase Authentication
const auth = getAuth(app); // Ajouté
const googleProvider = new GoogleAuthProvider();

// Exportez auth et googleProvider
export { auth, googleProvider };