import React, { useState, useEffect } from 'react';
import DataTable from 'react-data-table-component';
import "./Students.css";
import S from "../images/S.png";
import A from "../images/A.png";

const Students = () => {
  const [students, setStudents] = useState([]);
  const [records, setRecords] = useState([]);
  const [newStudent, setNewStudent] = useState({
    matricule: '',
    name: '',
    email: '',
    photo: ''
  });
  const [showForm, setShowForm] = useState(false);

  // Fonction pour récupérer les étudiants depuis le backend
  const fetchStudents = async () => {
    try {
      const response = await fetch("http://127.0.0.1:8000/teachers/students"); // Vérifiez cette URL
      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }
      const data = await response.json();
      console.log("Données reçues :", data);
      setStudents(data);
      setRecords(data);
    } catch (error) {
      console.error("Erreur lors de la récupération des étudiants :", error);
    }
  };

  useEffect(() => {
    fetchStudents();
  }, []);

  // Filtrer les étudiants
  const handleFilter = (event) => {
    const term = event.target.value.toLowerCase();
    const newData = students.filter((row) =>
      row.name.toLowerCase().includes(term)
    );
    setRecords(newData);
  };

  // Ajouter un nouvel étudiant
  const handleAddStudent = async (e) => {
    e.preventDefault();
    if (!newStudent.matricule || !newStudent.name || !newStudent.email) {
      alert('Veuillez remplir tous les champs obligatoires');
      return;
    }
    
    try {
      const response = await fetch("http://127.0.0.1:8000/teachers/students", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(newStudent)
      });
      const data = await response.json();
      console.log("Nouvel étudiant ajouté :", data);

      // On s'assure que l'objet retourné contienne bien "matricule"
      const studentAdded = {
        ...data,
        matricule: data.matricule || newStudent.matricule  // Si le backend renvoie "id" au lieu de "matricule", on utilise la valeur saisie
      };

      // Mettez à jour la liste des étudiants
      setStudents([...students, studentAdded]);
      setRecords([...records, studentAdded]);
      setNewStudent({ matricule: '', name: '', email: '', photo: '' });
      setShowForm(false);
    } catch (error) {
      console.error("Erreur lors de l'ajout de l'étudiant :", error);
    }
  };

  // Configuration des colonnes du tableau
  const columns = [
    {
      selector: row => row.photo,
      cell: row => (
        <img 
          src={row.photo || "https://via.placeholder.com/50"} 
          alt="Student" 
          style={{ width: '50px', height: '50px', borderRadius: '50%' }} 
        />
      ),
      sortable: false
    },
    { 
      name: 'Matricule', 
      // On affiche row.matricule si disponible, sinon on essaye row.id
      selector: row => row.matricule || row.id, 
      sortable: true 
    },
    { name: 'Nom complet', selector: row => row.name, sortable: true },
    { name: 'Email', selector: row => row.email, sortable: true }
  ];

  return (
    <div className='container'>
      <div className='header-controls'>
        <div className='search'>
          <img src={S} alt="Search"/> 
          <input type='text' onChange={handleFilter} placeholder='Search'/>
        </div>
        <div className='ajouter'>
          <button 
            className={`toggle-form-btn ${showForm ? 'cancel' : ''}`}
            onClick={() => setShowForm(!showForm)}>
            {showForm ? 'Annuler' : 'Ajouter un étudiant'}
            {!showForm && <img src={A} alt="add"/>}
          </button>
        </div>
      </div>

      {/* Formulaire d'ajout d'étudiant */}
      {showForm && (
        <div className="add-form">
          <form onSubmit={handleAddStudent}>
            <input
              type="text"
              placeholder="Matricule *"
              value={newStudent.matricule}
              onChange={(e) => setNewStudent({...newStudent, matricule: e.target.value})}
              required
            />
            <input
              type="text"
              placeholder="Nom complet *"
              value={newStudent.name}
              onChange={(e) => setNewStudent({...newStudent, name: e.target.value})}
              required
            />
            <input
              type="email"
              placeholder="Email *"
              value={newStudent.email}
              onChange={(e) => setNewStudent({...newStudent, email: e.target.value})}
              required
            />
            <input
              type="text"
              placeholder="URL de la photo"
              value={newStudent.photo}
              onChange={(e) => setNewStudent({...newStudent, photo: e.target.value})}
            />
            <button type="submit" className="add-button">
              Confirmer l'ajout
            </button>
          </form>
        </div>
      )}

      <DataTable 
        columns={columns} 
        data={records} 
        fixedHeader 
        noDataComponent="Aucun étudiant trouvé" 
      />
    </div>
  );
};

export default Students;
