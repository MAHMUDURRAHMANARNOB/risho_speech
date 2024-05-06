class CouponDiscountDataModel {
  final int errorCode;
  final String message;
  final double discountReceivable;
  final double discount;
  final String discountType;

  CouponDiscountDataModel({
    required this.errorCode,
    required this.message,
    required this.discountReceivable,
    required this.discount,
    required this.discountType,
  });

  factory CouponDiscountDataModel.fromJson(Map<String, dynamic> json) {
    return CouponDiscountDataModel(
      errorCode: json['errorcode'] ?? 0,
      message: json['message'] ?? '',
      discountReceivable: (json['discountReceivable'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      discountType: json['discountType'] ?? '',
    );
  }
}
