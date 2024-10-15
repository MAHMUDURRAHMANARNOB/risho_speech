class Language {
  final int id;
  final String langName;

  Language({
    required this.id,
    required this.langName,
  });

  // Factory method to create a Language object from JSON
  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      langName: json['langName'],
    );
  }

  // Method to convert a Language object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'langName': langName,
    };
  }
}

class LanguageListDataModel {
  final List<Language> langList;

  LanguageListDataModel({required this.langList});

  // Factory method to create a LanguageListDataModel object from JSON
  factory LanguageListDataModel.fromJson(Map<String, dynamic> json) {
    var list = json['langList'] as List;
    List<Language> languageList =
        list.map((i) => Language.fromJson(i)).toList();
    return LanguageListDataModel(langList: languageList);
  }

  // Method to convert a LanguageListDataModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'langList': langList.map((lang) => lang.toJson()).toList(),
    };
  }
}
