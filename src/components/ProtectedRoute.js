// ProtectedRoute.js
//protected routes that only logged-in users can
//  access. This will ensure that users cannot 
// access the quiz creation page without logging in.
import React from 'react';
import { Navigate, Outlet } from 'react-router-dom';

const ProtectedRoute = () => {
  const isLoggedIn = localStorage.getItem('isLoggedIn');

  // If the user is logged in, render the child routes
  // Otherwise, redirect to the login page
  return !isLoggedIn ? <Outlet /> : <Navigate to="/login" />;
};

export default ProtectedRoute;