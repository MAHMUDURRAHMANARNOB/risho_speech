class Listeningaudioquestionresponsedatamodel {
  final int errorCode;
  final String message;
  final String? audioFile;
  final String? question;
  final int? examId;

  Listeningaudioquestionresponsedatamodel({
    required this.errorCode,
    required this.message,
    required this.audioFile,
    required this.question,
    required this.examId,
  });

  // Factory method to create an instance of the class from JSON
  factory Listeningaudioquestionresponsedatamodel.fromJson(
      Map<String, dynamic> json) {
    return Listeningaudioquestionresponsedatamodel(
      errorCode: json['errorcode'],
      message: json['message'],
      audioFile: json['audiofile'] ?? "",
      question: json['question'] ?? "",
      examId: json['examid'] ?? null,
    );
  }

// Method to convert an instance of the class to JSON
/*  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'audiofile': audioFile,
      'question': question,
      'examid': examId,
    };
  }*/
}
