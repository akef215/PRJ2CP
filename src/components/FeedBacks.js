import React, { useState, useEffect } from "react";
import DataTable from "react-data-table-component";
import "./styles/Feed.css";
import logo from "../images/logo _final.png";
import { useNavigate } from "react-router-dom";
import axios from "axios";

const FeedBackview = () => {
  const navigate = useNavigate();
  const [records, setRecords] = useState([]);
  const API_URL = process.env.REACT_APP_API_URL;

  useEffect(() => {
    axios
      .get(`${API_URL}/feedback`)
      .then((res) => setRecords(res.data))
      .catch((err) =>
        console.error("Erreur lors du chargement des feedbacks :", err)
      );
  }, []);
  console.log(records);

  const handleDelete = async (id) => {
    try {
      await axios.delete(`${API_URL}/feedback/`);
      setRecords((prev) => prev.filter((record) => record.id !== id));
    } catch (err) {
      console.error("Erreur lors de la suppression :", err);
    }
  };

  const handleRead = (id) => {
    navigate(`/feedback/${id}`);
  };

  const columns = [
    {
      selector: (row) => row.description,
      cell: (row) => (
        <div className="data-cell">
          <p>{row.description?.split(" ").slice(0, 10).join(" ") + "..."}</p>
        </div>
      ),
      width: "60%",
    },
    {
      selector: (row) => row.groupe,
      cell: (row) => (
        <div className="data-cell">
          <p>{row.groupe}</p>
        </div>
      ),
      width: "10%",
    },
    {
      cell: (row) => (
        <div className="action-buttons">
          <button className="read-btn" onClick={() => handleRead(row.id)}>
            View Feedback
          </button>
          {/*<button className="delete-btn" onClick={() => handleDelete(row.id)}>
            <img src={Delete} alt="Delete" />
          </button>*/}
        </div>
      ),
      width: "30%",
    },
  ];

  const customStyles = {
    table: {
      style: {
        border: "5px solid rgba(101, 117, 153, 1)",
        borderRadius: "20px",
        overflow: "hidden",
        backgroundColor: "#fff",
        width: "100%",
        maxWidth: "100%",
        overflowX: "hidden",
        tableLayout: "fixed",

      },
    },
    headRow: { style: { display: "none" } },
    cells: { style: { padding: "12px" } },
  };

  return (
    <div>
      {/* Navigation */}
      <div className="Nav">
        <div className="Nav-Logo">
          <img src={logo} alt="Logo" />
        </div>
        <div className="Nav-Menu">
          <p onClick={() => navigate("../homepage")}>Home</p>
          <p onClick={() => navigate("../stats")}>Stats</p>
          <p onClick={() => navigate("../quizPage")}>Quizzes</p>
          <p onClick={() => navigate("../profile")}>Profile</p>
        </div>
      </div>

      {/* Contenu principal */}
      <div className="main-container">
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
