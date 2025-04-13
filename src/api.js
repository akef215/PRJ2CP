import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL;

export const getData = async (endpoint) => {
    try {
        const response = await axios.get(`${API_URL}/${endpoint}`);
        return response.data;
    } catch (error) {
        console.error('Erreur API:', error);
        return null;
    }
};
