class IeltsCourseListDataModel {
  final String imageUrl;
  final String title;
  final String price;

  IeltsCourseListDataModel(
      {required this.imageUrl, required this.title, required this.price});

/*factory IeltsCourseListDataModel.fromJson(Map<String, dynamic> json) {
    return IeltsCourseListDataModel(
      imageUrl: json['imageUrl'],
      title: json['title'],
      price: json['price'],
    );
  }*/
}
