class VocabularyWord {
  final int id;
  final int topicId;
  final String vocabularyWord;
  final String wordsynonyms;
  final String wordantonyms;
  final String wordMeaning;
  final String wordSoundFile;
  final String banglaMeaning;
  final bool isIdioms;

  VocabularyWord({
    required this.id,
    required this.topicId,
    required this.vocabularyWord,
    required this.wordsynonyms,
    required this.wordantonyms,
    required this.wordMeaning,
    required this.wordSoundFile,
    required this.banglaMeaning,
    required this.isIdioms,
  });

  // Factory method to create a VocabularyWord object from a JSON map
  factory VocabularyWord.fromJson(Map<String, dynamic> json) {
    return VocabularyWord(
      id: json['id'],
      topicId: json['topicId'],
      vocabularyWord: json['vocabularyWord'],
      wordsynonyms: json['wordsynonyms'],
      wordantonyms: json['wordantonyms'],
      wordMeaning: json['wordMeaning'],
      wordSoundFile: json['wordSoundFile'],
      banglaMeaning: json['banglaMeaning'],
      isIdioms: json['isIdioms'] == 'Y',
    );
  }

  // Method to convert a VocabularyWord object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'vocabularyWord': vocabularyWord,
      'wordsynonyms': wordsynonyms,
      'wordantonyms': wordantonyms,
      'wordMeaning': wordMeaning,
      'wordSoundFile': wordSoundFile,
      'banglaMeaning': banglaMeaning,
      'isIdioms': isIdioms ? 'Y' : 'N',
    };
  }
}

class IeltsVocabularyListDataModel {
  final List<VocabularyWord> vocaList;

  IeltsVocabularyListDataModel({required this.vocaList});

  // Factory method to create a VocabularyList object from a JSON map
  factory IeltsVocabularyListDataModel.fromJson(Map<String, dynamic> json) {
    var list = json['vocaList'] as List;
    List<VocabularyWord> vocabularyList =
        list.map((i) => VocabularyWord.fromJson(i)).toList();

    return IeltsVocabularyListDataModel(vocaList: vocabularyList);
  }

  // Method to convert a VocabularyList object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'vocaList': vocaList.map((word) => word.toJson()).toList(),
    };
  }
}
