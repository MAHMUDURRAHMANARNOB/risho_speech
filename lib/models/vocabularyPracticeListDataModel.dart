class VocabularyPracticeListDataModel {
  final List<VocabularyItem>? vocaList;

  VocabularyPracticeListDataModel({required this.vocaList});

  factory VocabularyPracticeListDataModel.fromJson(Map<String, dynamic> json) {
    return VocabularyPracticeListDataModel(
      vocaList: json['vocaList'] != null
          ? List<VocabularyItem>.from(
              json['vocaList'].map((x) => VocabularyItem.fromJson(x)))
          : [],
    );
  }
}

class VocabularyItem {
  final int id;
  final String? vocWord;
  final int? vocaCatId;
  final String? englishMeaning;
  final String? banglaMeaning;
  final String? wordAudios;

  VocabularyItem({
    required this.id,
    this.vocWord,
    this.vocaCatId,
    this.englishMeaning,
    this.banglaMeaning,
    this.wordAudios,
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) {
    return VocabularyItem(
      id: json['id'],
      vocWord: json['vocWord'],
      vocaCatId: json['vocaCatId'],
      englishMeaning: json['englishMeaning'],
      banglaMeaning: json['banglaMeaning'],
      wordAudios: json['wordAudios'],
    );
  }
}
