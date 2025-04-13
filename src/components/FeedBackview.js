import React, { useState, useEffect } from 'react';
import DataTable from 'react-data-table-component';
import "./Feed.css";
import logo from '../images/logo _final.png';
import Delete from "../images/delete.png"; 
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { Link } from 'react-router-dom';
const FeedBackview = () => {
  const navigate = useNavigate();
  const [records, setRecords] = useState([]);

  useEffect(() => {
    axios.get("http://127.0.0.1:8000/feedback/")
      .then(res => setRecords(res.data))
      .catch(err => console.error("Erreur lors du chargement des feedbacks :", err));
  }, []);

  const handleDelete = async (id) => {
    try {
      await axios.delete(`http://127.0.0.1:8000/feedback/`);
      setRecords(prev => prev.filter(record => record.id !== id));
    } catch (err) {
      console.error("Erreur lors de la suppression :", err);
    }
  };

  const handleRead = (id) => {
    navigate(`/feedback/${id}`);
  };

  const columns = [
    {
      selector: row => row.title,
      cell: row => <div className="data-cell"><p>{row.title?.split(' ').slice(0, 5).join(' ') + '...'}</p></div>,
      width: '70%'
    },
    {
      selector: row => row.class_,
      cell: row => <div className="data-cell"><p>{row.class_}</p></div>,
      width: '10%'
    },
    {
      cell: row => (
        <div className="action-buttons">
          <button className="read-btn" onClick={() => handleRead(row.id)}>View Feedback</button>
          <button className="delete-btn" onClick={() => handleDelete(row.id)}>
            <img src={Delete} alt="Delete"/>
          </button>
        </div>
      ),
      ignoreRowClick: true,
      allowOverflow: true,
      width: '20%'
    }
  ];

  const customStyles = {
    table: {
      style: {
        border: '5px solid rgba(101, 117, 153, 1)',
        borderRadius: '20px',
        overflow: 'hidden',
        backgroundColor: '#fff',
      },
    },
    headRow: { style: { display: 'none' } },
    cells: { style: { padding: '12px' } },
  };

  return (
    <div>
      {/* Navigation */}
      <div className='Nav'>
        <div className='Nav-Logo'><img src={logo} alt='Logo' /></div>
        <div className='Nav-Menu'>
          <p><Link to="/homepage">Home</Link></p>
          <p><Link to="/stats">Stats</Link></p>
          <p><Link to="/module">Modules</Link></p>
          <p><Link to="/profile">Profile</Link></p>
        </div>
      </div>

      {/* Contenu principal */}
      <div className='main-container'>
        <DataTable 
          columns={columns} 
          data={records}
          noHeader
          customStyles={customStyles}
        />
      </div>
    </div>
  );
};

export default FeedBackview;
