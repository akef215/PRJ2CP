class Quizzesstructure {
  final int id;
  final String title;
  final String date;
  final String type_quizz;

  Quizzesstructure({required this.id,
    required this.title,
    required this.date,
    required this.type_quizz,});
    
   factory Quizzesstructure.fromJson(Map<String, dynamic> json) {
    return Quizzesstructure(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      type_quizz: json['type_quizz'],
    );
  }
}

