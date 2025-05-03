class ReviewedQuestion {
  final int questionId;
  final String statement;
  final List<ReviewedChoice> choices;

  ReviewedQuestion({
    required this.questionId,
    required this.statement,
    required this.choices,
  });
}

class ReviewedChoice {
  final int choiceId;
  final String answer;
  final bool isSelected;
  final bool isCorrect;

  ReviewedChoice({
    required this.choiceId,
    required this.answer,
    required this.isSelected,
    required this.isCorrect,
  });
}
