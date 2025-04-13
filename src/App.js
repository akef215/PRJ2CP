import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Login from './components/Login';
import Recover from './components/Recover';
import NewAcc from './components/NewAcc';
import CreateQuiz from './components/CreateQuiz';
import Module from './components/Module';
import Notifications from './components/Notifications';
import Profile from './components/Profile';
import Select from './components/Select';
import ProtectedRoute from './components/ProtectedRoute';
import Layout from './components/Layout';
import CreateQuizT1 from './components/CreateQuizT1';
import CreateQuizT2 from './components/CreateQuizT2';
import CreateQuizT2Dis from './components/CreateQuizT2Dis';
import HomePage from './components/HomePage';
import Calendar from './components/Calendar';
import Settings from './components/Settings';
import Archive from './components/Archive';
import AddClass from './components/AddClass';
import AddModule from './components/AddModule';
import CreateSurvey  from './components/CreateSurvey';
import AddClassCSV from './components/AddClassCSV';
import SurveyNext from './components/SurveyNext';
import ClassesPage from './components/ClassesPage';
import Students from './components/Students';
import PageType2 from './components/PageType2';
import Page2Completed from './components/Page2Completed';
import CreateT2Pic from './components/CreateT2Pic';
import QuizPage from './components/QuizPage';
//Les pages des statistiques 
import Stats from './components/Stats';
import StatsPie from './components/StatsPie';
import StatsLine from './components/StatsLine';
import StatsBar from './components/StatsBar';
//les pages de feedBack 
import FeedBackView from './components/FeedBackview';
import FeedIndiv from './components/FeedIndiv';
import Reclamations from './components/Reclamations';
//Interface , props 
function App() {
  return (
    <Router>
       {/* <Sidebar />  */}
      <Routes>
        {/* ✅ Routes publiques (pas de Navbar, Sidebar ou Rectangle) */}
        <Route path="/login" element={<Login />} />
        <Route path="/recover" element={<Recover />} />
        <Route path="/newacc" element={<NewAcc />} />

        {/* ✅ Routes protégées (avec Navbar, Sidebar et Rectangle) */}
        <Route element={<ProtectedRoute />}>
          <Route
            element={
              <Layout>
                <CreateQuiz />
              </Layout>
            }
            path="/createQuiz"
          />
           <Route
            element={
              <Layout>
                <PageType2 />
              </Layout>
            }
            path="/pageType2"
          />
           <Route
            element={
              <Layout>
                <Reclamations />
              </Layout>
            }
            path="/reclamations"
          />
           <Route
            element={
              <Layout>
                <Page2Completed />
              </Layout>
            }
            path="/page2Completed"
          />
           <Route
            element={
              <Layout>
                <QuizPage/>
              </Layout>
            }
            path="/quizPage"
          />
            <Route
            element={
              <Layout>
                <CreateT2Pic />
              </Layout>
            }
            path="/createT2Pic"
          />
           <Route
            element={
              <Layout>
                <ClassesPage />
              </Layout>
            }
            path="/classesPage"
          />
           <Route
            element={
              <Layout>
                <Students />
              </Layout>
            }
            path="/students"
          />
          <Route
            element={
              <Layout>
                <Module />
              </Layout>
            }
            path="/module"
          />
          <Route
            element={
              <Layout>
                <Notifications />
              </Layout>
            }
            path="/notifications"
          />
          <Route
            element={
              <Layout>
                <Profile />
              </Layout>
            }
            path="/profile"
          />
          <Route
            element={
              <Layout>
                <Select />
              </Layout>
            }
            path="/select"
          />
        </Route>
        <Route
            element={
              <Layout>
                <CreateQuizT1/>
              </Layout>
            }
            path="/createQuizT1"
          />
        <Route
            element={
              <Layout>
                <CreateQuizT2/>
              </Layout>
            }
            path="/createQuizT2"
          />
          <Route
            element={
              <Layout>
                <CreateQuizT2Dis/>
              </Layout>
            }
            path="/createQuizT2Dis"
          />
           <Route
            element={
              <Layout>
                <HomePage/>
              </Layout>
            }
            path="/homepage"
          />
     
      <Route
            element={
              <Layout>
                <Calendar/>
              </Layout>
            }
            path="/calendar"
          />
           <Route
            element={
              <Layout>
                <Settings/>
              </Layout>
            }
            path="/settings"
          />
           <Route
            element={
              <Layout>
                <Stats/>
              </Layout>
            }
            path="/stats"
          />
           <Route
            element={
              <Layout>
                <Archive/>
              </Layout>
            }
            path="/archive"
          />
          <Route
            element={
              <Layout>
                <AddClass/>
              </Layout>
            }
            path="/addClass"
          />
           <Route
            element={
              <Layout>
                <AddModule/>
              </Layout>
            }
            path="/addModule"
          />
           <Route
            element={
              <Layout>
                <CreateSurvey/>
              </Layout>
            }
            path="/createSurvey"
          />
            <Route
            element={
              <Layout>
                <AddClassCSV/>
              </Layout>
            }
            path="/addClassCsv"
          />
           <Route
            element={
              <Layout>
                <SurveyNext/>
              </Layout>
            }
            path="/surveyNext"
          />
           <Route
            element={
              <Layout>
                <StatsPie/>
              </Layout>
            }
            path="/statsPie"
          />
           <Route
            element={
              <Layout>
                <StatsLine/>
              </Layout>
            }
            path="/statsLine"
          />
           <Route
            element={
              <Layout>
                <StatsBar/>
              </Layout>
            }
            path="/statsBar"
          />
            <Route
            element={
              <Layout>
                <FeedBackView/>
              </Layout>
            }
            path="/feedbackView"
          />
           <Route
            element={
              <Layout>
                <FeedIndiv/>
              </Layout>
            }
            path="/feedIndiv"
          />
          <Route path="/feedback/:id" element={<FeedIndiv />} />
           </Routes>
    </Router>
  );
}

export default App;
