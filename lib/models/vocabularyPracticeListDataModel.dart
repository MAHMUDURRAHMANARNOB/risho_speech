class VocabularyPracticeListDataModel {
  final List<VocaWord> vocaList;

  VocabularyPracticeListDataModel({
    required this.vocaList,
  });

  factory VocabularyPracticeListDataModel.fromJson(Map<String, dynamic> json) {
    return VocabularyPracticeListDataModel(
      vocaList: List<VocaWord>.from(
        json['vocaList'].map((v) => VocaWord.fromJson(v)),
      ),
    );
  }
}

class VocaWord {
  final int id;
  final String vocWord;
  final int vocaCatId;
  final String englishMeaning;
  final String banglaMeaning;
  final String wordAudio;

  VocaWord({
    required this.id,
    required this.vocWord,
    required this.vocaCatId,
    required this.englishMeaning,
    required this.banglaMeaning,
    required this.wordAudio,
  });

  factory VocaWord.fromJson(Map<String, dynamic> json) {
    return VocaWord(
      id: json['id'],
      vocWord: json['vocWord'],
      vocaCatId: json['vocaCatId'],
      englishMeaning: json['englishMeaning'],
      banglaMeaning: json['banglaMeaning'],
      wordAudio: json['wordaudios'],
    );
  }
}
