class CallingAgentDataModel {
  List<Agentlist>? agentlist;

  CallingAgentDataModel({this.agentlist});

  CallingAgentDataModel.fromJson(Map<String, dynamic> json) {
    if (json['agentlist'] != null) {
      agentlist = <Agentlist>[];
      json['agentlist'].forEach((v) {
        agentlist!.add(new Agentlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.agentlist != null) {
      data['agentlist'] = this.agentlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Agentlist {
  String? country;
  List<Agents>? agents;

  Agentlist({this.country, this.agents});

  Agentlist.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    if (json['agents'] != null) {
      agents = <Agents>[];
      json['agents'].forEach((v) {
        agents!.add(new Agents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    if (this.agents != null) {
      data['agents'] = this.agents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Agents {
  int? id;
  String? agentName;
  String? agentDesc;
  String? agentGender;
  String? agentPicture;
  int? totalUsed;

  Agents(
      {this.id,
      this.agentName,
      this.agentDesc,
      this.agentGender,
      this.agentPicture,
      this.totalUsed});

  Agents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agentName = json['agentName'];
    agentDesc = json['agentDesc'];
    agentGender = json['agentGender'];
    agentPicture = json['agentPicture'];
    totalUsed = json['TotalUsed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['agentName'] = this.agentName;
    data['agentDesc'] = this.agentDesc;
    data['agentGender'] = this.agentGender;
    data['agentPicture'] = this.agentPicture;
    data['TotalUsed'] = this.totalUsed;
    return data;
  }
}
