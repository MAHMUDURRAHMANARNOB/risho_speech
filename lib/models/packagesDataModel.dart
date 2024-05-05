class PackagesDataModel {
  final int errorCode;
  final String message;
  final List<Package> packageList;

  PackagesDataModel({
    required this.errorCode,
    required this.message,
    required this.packageList,
  });

  factory PackagesDataModel.fromJson(Map<String, dynamic> json) {
    List<Package> packages = (json['packageList'] as List)
        .map((packageJson) => Package.fromJson(packageJson))
        .toList();

    return PackagesDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      packageList: packages,
    );
  }
}

class Package {
  final int? id;
  final String? name;
  final double? price;
  final double? discountedPrice;
  final String? duration;
  final String? subsType;
  final int? noOfCourse;
  final int? noOfComments;
  final int? noOfTickets;
  final double? audiominutes;
  final String? imagePath;
  final String? subDesc;
  final double? discountinPer;
  final double? dollarAmount;

  Package({
    required this.id,
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.duration,
    required this.subsType,
    required this.noOfCourse,
    required this.noOfComments,
    required this.noOfTickets,
    required this.audiominutes,
    required this.imagePath,
    required this.subDesc,
    required this.discountinPer,
    required this.dollarAmount,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['Name'],
      price: json['Price'].toDouble() ?? 0.0,
      discountedPrice: json['discountedPrice'].toDouble() ?? 0.0,
      duration: json['duration'],
      subsType: json['subsType'],
      noOfCourse: json['NoOfCourse'],
      noOfComments: json['NoOfComments'],
      noOfTickets: json['NoOfTickets'],
      audiominutes: json['audiominutes'],
      imagePath: json['Imagepath'],
      subDesc: json['subDesc'] != null ? json['subDesc'] : "",
      discountinPer: json['discountinPer'] != null
          ? json['discountinPer'].toDouble()
          : 0.0,
      dollarAmount: json['DollarAmount'],
    );
  }
}
