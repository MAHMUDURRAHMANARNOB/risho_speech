class IeltsVocabularyCategoryListDataModel {
  final List<VocaCat> vocaCatList;

  IeltsVocabularyCategoryListDataModel({required this.vocaCatList});

  factory IeltsVocabularyCategoryListDataModel.fromJson(
      Map<String, dynamic> json) {
    return IeltsVocabularyCategoryListDataModel(
      vocaCatList: List<VocaCat>.from(
          json['vocaCatList'].map((item) => VocaCat.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vocaCatList': vocaCatList.map((item) => item.toJson()).toList(),
    };
  }
}

class VocaCat {
  final int id;
  final String topicName;
  final String? coverImages;
  final int wordsCreated;

  VocaCat({
    required this.id,
    required this.topicName,
    this.coverImages,
    required this.wordsCreated,
  });

  factory VocaCat.fromJson(Map<String, dynamic> json) {
    return VocaCat(
      id: json['id'],
      topicName: json['topicName'],
      coverImages: json['coverImages'],
      wordsCreated: json['wordsCreated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicName': topicName,
      'coverImages': coverImages,
      'wordsCreated': wordsCreated,
    };
  }
}
