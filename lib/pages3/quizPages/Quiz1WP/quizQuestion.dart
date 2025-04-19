
// class QuizQuestion {
//   final int id;
//   final String text;
//   final List<String> answers;
//   final List<String> correctAnswers; // List of correct answers
//   final int points; // Points for this question
//
//   QuizQuestion({
//     required this.id,
//     required this.text,
//     required this.answers,
//     required this.correctAnswers,
//     required this.points,
//   });
//
//   // Constructor to create an instance from JSON
//   factory QuizQuestion.fromJson(Map<String, dynamic> json) {
//     return QuizQuestion(
//       id: json['id'],
//       text: json['text'],
//       answers: List<String>.from(json['answers']),
//       correctAnswers: List<String>.from(json['correctAnswers']),  // Multiple correct answers
//       points: json['points'],  // Points for the question
//     );
//   }
// }

// import 'choice.dart';
//
// class QuizQuestion {
//   final String statement;
//   final List<Choice> choices;
//
//   QuizQuestion({
//     required this.statement,
//     required this.choices,
//   });
//
//   factory QuizQuestion.fromJson(Map<String, dynamic> json) {
//     return QuizQuestion(
//       statement: json['statement'],
//       choices: (json['choices'] as List)
//           .map((c) => Choice.fromJson(c))
//           .toList(),
//     );
//   }
// }

class QuizQuestion {
  final String statement;
  final List<Choice> choices;

  QuizQuestion({required this.statement, required this.choices});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    var choicesList = (json['choices'] as List)
        .map((choice) => Choice.fromJson(choice))
        .toList();

    return QuizQuestion(
      statement: json['statement'],
      choices: choicesList,
    );
  }
}

class Choice {
  final int choiceId;
  final String answer;
  final double points;

  Choice({required this.choiceId, required this.answer, required this.points});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      choiceId: json['choiceId'],
      answer: json['answer'],
      points: json['points'],
    );
  }
}

