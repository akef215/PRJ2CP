import React, { useState, useEffect } from "react";
import DataTable from "react-data-table-component";
import "./styles/Feed.css";
import logo from "../images/logo _final.png";
import Delete from "../images/delete.png";
import { useNavigate } from "react-router-dom";
import axios from "axios";

const FeedBackview = () => {
  const navigate = useNavigate();
  const [records, setRecords] = useState([]);

  useEffect(() => {
    axios
      .get("http://127.0.0.1:8000/feedback/feedback")
      .then((res) => setRecords(res.data))
      .catch((err) =>
        console.error("Erreur lors du chargement des feedbacks :", err)
      );
  }, []);
  console.log(records);

  const handleDelete = async (id) => {
    try {
      await axios.delete(`http://127.0.0.1:8000/feedback/`);
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
          <p>{row.description?.split(" ").slice(0, 15).join(" ") + "..."}</p>
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
          <p onClick={() => navigate("../homepage")}>home</p>
          <p onClick={() => navigate("../stats")}>stats</p>
          <p onClick={() => navigate("../module")}>Modules</p>
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
