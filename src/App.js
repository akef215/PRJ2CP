import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Login from "./components/Login";
import CreateQuiz from "./components/CreateQuiz";
import Module from "./components/Module";
import Profile from "./components/Profile";
import Select from "./components/Select";
import ProtectedRoute from "./components/ProtectedRoute";
import Layout from "./components/Layout";
import CreateQuizT1 from "./components/addSurvey";
import CreateQuizT2 from "./components/CreateQuizT2";
import CreateQuizT2Dis from "./components/CreateQuizT2Dis";
import HomePage from "./components/HomePage";
import AddClass from "./components/AddClass";
import AddModule from "./components/AddModule";
import CreateSurvey from "./components/CreateSurvey";
import AddClassCSV from "./components/AddClassCSV";
import SurveyNext from "./components/SurveyNext";
import ClassesPage from "./components/ClassesPage";
import Students from "./components/Students";
import PageType2 from "./components/PageType2";
import Page2Completed from "./components/Page2Completed";
import CreateT2Pic from "./components/CreateT2Pic";
import QuizPage from "./components/QuizPage";
//Les pages des statistiques
import Stats from "./components/Stats";
import StatsPie from "./components/StatsPie";
import StatsLine from "./components/StatsLine";
import StatsBar from "./components/StatsBar";
//les pages de feedBack
import FeedBackView from "./components/FeedBacks";
import FeedIndiv from "./components/FeedIndiv";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <CreateQuiz />
            </Layout>
            </ProtectedRoute>
          }
          path="/createQuiz"
        />
        <Route element={<PageType2 />} path="/pageType2" />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <Page2Completed />
            </Layout>
            </ProtectedRoute>
          }
          path="/page2Completed"
        />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <QuizPage />
            </Layout>
            </ProtectedRoute>
          }
          path="/quizPage"
        />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <CreateT2Pic />
            </Layout>
            </ProtectedRoute>
          }
          path="/createT2Pic"
        />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <ClassesPage />
            </Layout>
            </ProtectedRoute>
          }
          path="/classesPage"
        />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <Students />
            </Layout>
            </ProtectedRoute>
          }
          path="/students"
        />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <Module />
            </Layout>
            </ProtectedRoute>
          }
          path="/module"
        />
                <Route
          element={
            <ProtectedRoute>
              <Profile />
            </ProtectedRoute>
          }
          path="/profile"
        />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <Select />
            </Layout>
            </ProtectedRoute>
          }
          path="/select"
        />
        <Route
          element={  
              <CreateQuizT1 />
          }
          path="/addSurvey/:id"
        />
        <Route
          element={
            <Layout>
              <CreateQuizT2 />
            </Layout>
          }
          path="/createQuizT2"
        />
        <Route
          element={
            <Layout>
              <CreateQuizT2Dis />
            </Layout>
          }
          path="/createQuizT2Dis"
        />
        <Route
          element={
            <ProtectedRoute>
              <HomePage />
            </ProtectedRoute>
          }
          path="/homepage"
        />
        <Route element={<Stats />} path="/stats" />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <AddClass />
            </Layout>
            </ProtectedRoute>
          }
          path="/addClass"
        />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <AddModule />
            </Layout>
            </ProtectedRoute>
          }
          path="/addModule"
        />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <CreateSurvey />
            </Layout>
            </ProtectedRoute>
          }
          path="/createSurvey"
        />
        <Route
          element={
            <ProtectedRoute>
            <Layout>
              <AddClassCSV />
            </Layout>
            </ProtectedRoute>
          }
          path="/addClassCsv"
        />
        <Route element={<SurveyNext />} path="/surveyNext" />
        <Route element={<StatsPie />} path="/statsPie" />
        <Route element={<StatsLine />} path="/statsLine" />
        <Route element={<StatsBar />} path="/statsBar" />
        <Route element={<FeedBackView />} path="/feedbacks" />
        <Route element={<FeedIndiv />} path="/feedbacks" />
        <Route path="/feedback/:id" element={<FeedIndiv />} />
        <Route path="/" element={<Login />} />
      </Routes>
    </Router>
  );
}

export default App;
