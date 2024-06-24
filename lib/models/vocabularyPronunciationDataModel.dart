class ValidateVocabPronunciationDataModel {
  int error;
  String message;
  double? accuracyScore;
  double? fluencyScore;
  double? completenessScore;
  double? prosodyScore;
  String? speechText;
  String? speechTextbn;
  String? fileLoc;
  List<Word>? words;

  ValidateVocabPronunciationDataModel({
    required this.error,
    required this.message,
    this.accuracyScore,
    this.fluencyScore,
    this.completenessScore,
    this.prosodyScore,
    this.speechText,
    this.speechTextbn,
    this.fileLoc,
    this.words,
  });

  factory ValidateVocabPronunciationDataModel.fromJson(
      Map<String, dynamic> jsonData) {
    // final jsonData = json.decode(jsonString);
    return ValidateVocabPronunciationDataModel(
      error: jsonData['errorcode'],
      message: jsonData['message'],
      accuracyScore: jsonData['accuracyScore'].toDouble(),
      fluencyScore: jsonData['fluencyScore'].toDouble(),
      completenessScore: jsonData['completenessScore'].toDouble(),
      prosodyScore: jsonData['prosodyScore'].toDouble(),
      speechText: jsonData['speechText'],
      speechTextbn: jsonData['speechTextbn'],
      fileLoc: jsonData['fileLoc'],
      words: jsonData['words'] != null
          ? (jsonData['words'] as List<dynamic>)
              .map((word) => Word.fromJson(word))
              .toList()
          : [],
    );
  }
}

class Word {
  String? word;
  double? accuracyScore;
  String? errorType;
  List<Phoneme>? phonemes;

  Word({
    this.word,
    this.accuracyScore,
    this.errorType,
    this.phonemes,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['Word'],
      accuracyScore: json['AccuracyScore'].toDouble(),
      errorType: json['ErrorType'],
      phonemes: json['Phonemes'] != null
          ? (json['Phonemes'] as List<dynamic>)
              .map((phoneme) => Phoneme.fromJson(phoneme))
              .toList()
          : [],
    );
  }
}

class Phoneme {
  String? phoneme;
  double? accuracyScore;

  Phoneme({
    this.phoneme,
    this.accuracyScore,
  });

  factory Phoneme.fromJson(Map<String, dynamic> json) {
    return Phoneme(
      phoneme: json['Phoneme'],
      accuracyScore: json['AccuracyScore'].toDouble(),
    );
  }
}
