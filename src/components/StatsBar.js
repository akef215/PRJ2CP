import React from 'react';
import './styles/Stats.css'; 
import logo from '../images/logo _final.png';
import user from '../images/Frame_5.png';
import { Bar, Doughnut, Line } from "react-chartjs-2";
import LineData from "./data/LineData.json";
// Importation de Chart.js et du plugin d'annotation
import { Chart as ChartJS ,defaults} from "chart.js/auto";
import annotationPlugin from "chartjs-plugin-annotation";
ChartJS.register(annotationPlugin);


defaults.maintainAspectRatiolse = false ;
defaults.responsive=true ;
const StatsBar = () => {
  return (
    <div>
        <div className='Nav'>
            <div className='Nav-Logo'><img src={logo} alt='Logo'/></div>
            <div className='Nav-Menu'>
                <p>home</p>
                <p>stats</p>
                <p>Modules</p>
                <p>Profile</p>
            </div>
        </div>
        <div className='profile-icon'>
            <img src={user} alt='User'/>
        </div>
        <div className='msg-welcome'>
            <p>"name" stats</p>
        </div>
       
        <div className='rectMenu'>
            <div className='nav-second'>
                <div className='first-nav'>
                    <p>By Quiz</p>
                    <p>By chapter</p>
                    <p>Weakness</p>
                </div>
                <div className='second-nav'>
                    <p>Line graph</p>
                    <p>Bar chart</p>
                    <p>Pie Chart</p>
                </div>
        
                    <div className="Bar-container"> 
                    <Bar 
  data={{
    labels: LineData.map((data) => data.label),
    datasets: [
      {
        label: "",
        data: LineData.map((data) => data.revenue),
        backgroundColor: "rgba(107, 144, 172, 1)",
        borderRadius: 5, // Arrondi des barres
        barThickness: 40, // Épaisseur des barres
      },
    ],
  }}
  options={{
    plugins: {
      legend: { display: false },
    },
    scales: {
      x: {
        grid: {
          display: false, // Supprime la grille verticale
          drawBorder: false,
        },
        ticks: { 
                display: true ,
                color :"rgba(0, 0, 0, 1)" ,
                font:{
                    family: "'Montserrat' , sans-serif",
                    size: 12 ,
                    weight: "bold",
                },
        }, 
      },
      y: {
        grid: {
          display: false, // Supprime la grille horizontale
          drawBorder: false,
        },
        ticks: { display: false }, // Supprime les valeurs (ticks)
      },
    },
    maintainAspectRatio: false,
  }}
/>
                    </div>
                </div>
            </div>
        </div>
   
  );
}

export default StatsBar;
