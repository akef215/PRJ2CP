class SurveyQuestion {
  final String questionId;
  final List<SurveyChoice> choices;

  SurveyQuestion({required this.questionId, required this.choices});

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    return SurveyQuestion(
      questionId: json['question_id'],
      choices: (json['choices'] as List)
          .map((choice) => SurveyChoice.fromJson(choice))
          .toList(),
    );
  }
}

class SurveyChoice {
  final String choiceId;
  final int count;

  SurveyChoice({required this.choiceId, required this.count});

  factory SurveyChoice.fromJson(Map<String, dynamic> json) {
    return SurveyChoice(
      choiceId: json['choice_id'],
      count: json['count'],
    );
  }
}
