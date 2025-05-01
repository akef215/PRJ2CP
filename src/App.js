import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Login from "./components/Login";
import CreateQuiz from "./components/CreateQuiz";
import Module from "./components/Module";
import Profile from "./components/Profile";
import Select from "./components/Select";
import ProtectedRoute from "./components/ProtectedRoute";
import Layout from "./components/Layout";
import AddSurvey from "./components/addSurvey";
import EditSurvey from "./components/editSurvey";
import EditQuiz from "./components/editQuiz";
import AddQuiz1 from "./components/addQuiz1";
import AddQuiz2 from "./components/addQuiz2";
import HomePage from "./components/HomePage";
import AddClass from "./components/AddClass";
import AddModule from "./components/AddModule";
import CreateSurvey from "./components/CreateSurvey";
import AddClassCSV from "./components/AddClassCSV";
import ClassesPage from "./components/ClassesPage";
import Students from "./components/Students";
import PageType2 from "./components/PageType2";
import Page2Completed from "./components/Page2Completed";
import QuizPage from "./components/QuizPage";
//Les pages des statistiques
import StatSurvey from "./components/StatSurvey";
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
        <Route element={<ProtectedRoute><PageType2 /></ProtectedRoute>} path="/pageType2/:id/" />
        <Route
          element={
            <ProtectedRoute>
              <Layout>
                <Page2Completed />
              </Layout>
            </ProtectedRoute>
          }
          path="/page2Completed/:id/"
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
          path="/students/:id"
        />
                <Route
          element={
            <ProtectedRoute>
              <StatSurvey />
            </ProtectedRoute>
          }
          path="/statSurvey/:id"
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
        <Route element={<AddSurvey />} path="/addSurvey/:id" />
        <Route element={<EditSurvey />} path="/editSurvey/:id" />
        <Route element={<EditQuiz />} path="/editQuiz/:id" />
        <Route element={<AddQuiz1 />} path="/addQuiz1/:id/" />
        <Route element={<AddQuiz2 />} path="/addQuiz2/:id/" />
        <Route
          element={
            <ProtectedRoute>
              <HomePage />
            </ProtectedRoute>
          }
          path="/homepage"
        />
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
        <Route element={<StatsPie />} path="/statsPie" />
        <Route element={<StatsLine />} path="/statsLine" />
        <Route element={<StatsBar />} path="/statsBar" />
        <Route element={<FeedBackView />} path="/feedbacks" />
        <Route element={<FeedIndiv />} path="/feedbacks" />
        <Route path="/feedback/:id" element={<FeedIndiv />} />
        <Route path="/" element={<HomePage />} />
      </Routes>
    </Router>
  );
}

export default App;
