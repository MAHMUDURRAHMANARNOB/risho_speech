class VocaCategoryDataModel {
  List<VocalCat>? vocalListlist;

  VocaCategoryDataModel(
    this.vocalListlist,
  );

  VocaCategoryDataModel.fromJson(Map<String, dynamic> json) {
    if (json['vocaCatList'] != null) {
      vocalListlist = <VocalCat>[];
      json['vocaCatList'].forEach((v) {
        vocalListlist!.add(new VocalCat.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vocalListlist != null) {
      data['vocaCatList'] = this.vocalListlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VocalCat {
  int? id;
  String? vocCatName;
  String? vocCatNameBn;
  String? vocaDescription; // Assuming vocaDescription can be null

  VocalCat(
    this.id,
    this.vocCatName,
    this.vocCatNameBn,
    this.vocaDescription,
  );

  VocalCat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vocCatName = json['vocCatName'];
    vocCatNameBn = json['vocCatNameBn'];
    vocaDescription = json['vocaDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vocCatName'] = this.vocCatName;
    data['vocCatNameBn'] = this.vocCatNameBn;
    data['vocaDescription'] = this.vocaDescription;
    return data;
  }
}
