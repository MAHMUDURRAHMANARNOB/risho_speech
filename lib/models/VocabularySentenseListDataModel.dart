class VocabularySentenceListDataModel {
  final List<Sentence>? sentenceList;

  VocabularySentenceListDataModel({required this.sentenceList});

  factory VocabularySentenceListDataModel.fromJson(Map<String, dynamic> json) {
    /* List<Sentence> sentenceList =
        json.map((item) => Sentence.fromJson(item)).toList();
    return VocabularySentenceListDataModel(sentenceList: sentenceList);*/
    return VocabularySentenceListDataModel(
      sentenceList: List<Sentence>.from(
        json['SentenceList'].map((v) => Sentence.fromJson(v)),
      ),
    );
  }
}

class Sentence {
  final int? id;
  final int? vocaId;
  final String? vocaSentence;
  final String? vocaSentenceBn;
  final String? vocaAudioFile;

  Sentence({
    required this.id,
    required this.vocaId,
    required this.vocaSentence,
    required this.vocaSentenceBn,
    required this.vocaAudioFile,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      id: json['id'],
      vocaId: json['vocaId'],
      vocaSentence: json['vocaSentense'],
      vocaSentenceBn: json['vocaSentenseBn'],
      vocaAudioFile: json['vocaAudioFile'],
    );
  }
}
