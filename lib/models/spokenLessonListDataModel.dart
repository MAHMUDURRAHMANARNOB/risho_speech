class SpokenLessonListDataModel {
  final List<SpokenLesson> lessons;

  SpokenLessonListDataModel({required this.lessons});

  factory SpokenLessonListDataModel.fromJson(List<dynamic> json) {
    final List<SpokenLesson> lessons =
        json.map((lesson) => SpokenLesson.fromJson(lesson)).toList();
    return SpokenLessonListDataModel(lessons: lessons);
  }
}

class SpokenLesson {
  final int id;
  final String conversationName;
  final String conversationDetails;
  final String? imagePath;
  final String isGuided;
  final String showFeedback;
  final String userLevel;

  SpokenLesson({
    required this.id,
    required this.conversationName,
    required this.conversationDetails,
    required this.imagePath,
    required this.isGuided,
    required this.showFeedback,
    required this.userLevel,
  });

  factory SpokenLesson.fromJson(Map<String, dynamic> json) {
    return SpokenLesson(
      id: json['id'],
      conversationName: json['conversationName'],
      conversationDetails: json['conversationDetails'],
      imagePath: json['Imagepath'],
      isGuided: json['IsGuided'],
      showFeedback: json['showfeedback'],
      userLevel: json['userlavel'],
    );
  }
}
