class ValidateSentenceDataModel {
  final String correctSentence;
  final String explanation;
  final String alternate;
  final String banglaExplanation;

  ValidateSentenceDataModel({
    required this.correctSentence,
    required this.explanation,
    required this.alternate,
    required this.banglaExplanation,
  });

  factory ValidateSentenceDataModel.fromJson(Map<String, dynamic> json) {
    return ValidateSentenceDataModel(
      correctSentence: json['correctSentence'] ?? '',
      explanation: json['explanation'] ?? '',
      alternate: json['alternate'] ?? '',
      banglaExplanation: json['banglaExplanation'] ?? '',
    );
  }
}
