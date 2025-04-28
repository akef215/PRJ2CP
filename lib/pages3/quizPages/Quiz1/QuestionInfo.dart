class Questioninfo {
  final int questionId;
  final String statement;
  final int timeLimitSeconds;
  final List<ChoicesNew> choices;

  Questioninfo({required this.questionId,
    required this.statement,
    required this.timeLimitSeconds,
    required this.choices,});
    
   factory Questioninfo.fromJson(Map<String, dynamic> json) {
    var choicesList =(json['choices'] as List)
          .map((c) => ChoicesNew.fromJson(c))
          .toList();
    return Questioninfo(
      questionId: json['question_id'],
      statement: json['statement'],
      timeLimitSeconds: json['time_limit_seconds'],
      choices: choicesList,
    );
  }
}

class ChoicesNew {
  final int choicesId;
  final String answer;
  final double points;

  ChoicesNew({required this.choicesId, required this.answer, required this.points});

  factory ChoicesNew.fromJson(Map<String, dynamic> json) {
    return ChoicesNew(
      choicesId: json['choice_id'],
      answer: json['answer'],
      points: json['points'],
    );
  }
}

