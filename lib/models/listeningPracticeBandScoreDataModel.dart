class ListeningPracticeBandScoreDataModel {
  final int errorCode;
  final String message;
  final int score;
  final double ieltsBand;
  final List<AnswerReview> ansReview;

  ListeningPracticeBandScoreDataModel({
    required this.errorCode,
    required this.message,
    required this.score,
    required this.ieltsBand,
    required this.ansReview,
  });

  factory ListeningPracticeBandScoreDataModel.fromJson(
      Map<String, dynamic> json) {
    return ListeningPracticeBandScoreDataModel(
      errorCode: json['errorcode'] as int,
      message: json['message'] as String,
      score: json['Score'] as int,
      ieltsBand: (json['ieltsBand'] as num).toDouble(),
      ansReview: (json['ansreview'] as List)
          .map((item) => AnswerReview.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'Score': score,
      'ieltsBand': ieltsBand,
      'ansreview': ansReview.map((item) => item.toJson()).toList(),
    };
  }
}

class AnswerReview {
  final int questionNo;
  final String correctAns;
  final String givenAns;
  final bool isCorrect;

  AnswerReview({
    required this.questionNo,
    required this.correctAns,
    required this.givenAns,
    required this.isCorrect,
  });

  factory AnswerReview.fromJson(Map<String, dynamic> json) {
    return AnswerReview(
      questionNo: json['QuestionNo'] as int,
      correctAns: json['correctAns'] as String,
      givenAns: json['givenAns'] as String,
      isCorrect: (json['iscorrect'] as String) == 'Y',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'QuestionNo': questionNo,
      'correctAns': correctAns,
      'givenAns': givenAns,
      'iscorrect': isCorrect ? 'Y' : 'N',
    };
  }
}
