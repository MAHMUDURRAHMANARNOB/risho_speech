class SubscriptionStatusDataModel {
  final int? errorCode;
  final String? message;
  final String? packageName;
  final String? validityDate;
  final bool? isValid;
  final int? commentUsed;
  final int? commentsAvailable;
  final int? ticketUsed;
  final int? ticketsAvailable;
  final String? datePurchased;
  final double? audioMinutesUsed;
  final double? audioReamins;

  SubscriptionStatusDataModel({
    required this.errorCode,
    required this.message,
    required this.validityDate,
    required this.packageName,
    required this.isValid,
    required this.commentUsed,
    required this.commentsAvailable,
    required this.ticketUsed,
    required this.ticketsAvailable,
    required this.datePurchased,
    required this.audioMinutesUsed,
    required this.audioReamins,
  });

  factory SubscriptionStatusDataModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatusDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      packageName: json['packageName'],
      validityDate: json['validitydate'],
      isValid: json['isValid'] == 'Y',
      commentUsed: json['CommentUsed'],
      commentsAvailable: json['commentsavailable'],
      ticketUsed: json['TicketUsed'],
      ticketsAvailable: json['ticketsavailable'],
      datePurchased: json['datePurchased'],
      audioMinutesUsed: json['audioMinutesUsed'],
      audioReamins: json['audioReamins'],
    );
  }
}
