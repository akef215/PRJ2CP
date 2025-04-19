// customFetch.js

export const customFetch = async (url, options = {}) => {
    const token = localStorage.getItem("token");
  
    const headers = {
      ...options.headers,
      Authorization: token ? `Bearer ${token}` : undefined,
      "Content-Type": "application/json",
    };
  
    const config = {
      ...options,
      headers,
    };
  
    try {
      const response = await fetch(url, config);
  
      if (response.status === 401) {
        // Token expiré ou invalide
        localStorage.removeItem("token");
        window.location.href = "/login"; // Redirige vers la page de connexion
        return;
      }
  
      return response;
    } catch (error) {
      console.error("Erreur dans customFetch :", error);
      throw error;
    }
  };
  