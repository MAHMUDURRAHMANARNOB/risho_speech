class VocabularyDialogListDataModel {
  final List<Dialog>? dialogList;

  VocabularyDialogListDataModel({required this.dialogList});

  factory VocabularyDialogListDataModel.fromJson(Map<String, dynamic> json) {
    /* List<Dialog> dialogList =
        json.map((item) => Dialog.fromJson(item)).toList();
    return VocabularyDialogListDataModel(dialogList: dialogList);*/
    return VocabularyDialogListDataModel(
      dialogList: List<Dialog>.from(
        json['dialogList'].map((v) => Dialog.fromJson(v)),
      ),
    );
  }
}

class Dialog {
  final int? id;
  final int? vocaid;
  final String? actorName;
  final String? actorGender;
  final String? conversationEn;
  final String? conversationBn;
  final String? conversationAudioFile;
  final int? seqNumber;

  Dialog({
    required this.id,
    required this.vocaid,
    required this.actorName,
    required this.actorGender,
    required this.conversationEn,
    required this.conversationBn,
    required this.conversationAudioFile,
    required this.seqNumber,
  });

  factory Dialog.fromJson(Map<String, dynamic> json) {
    return Dialog(
      id: json['id'],
      vocaid: json['vocaid'],
      actorName: json['actorName'],
      actorGender: json['actorGender'],
      conversationEn: json['conversationEn'],
      conversationBn: json['conversationBn'],
      conversationAudioFile: json['conversationAudioFile'],
      seqNumber: json['seqNumber'],
    );
  }
}
