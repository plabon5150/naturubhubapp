class Section {
  String? id;
  int? sECTIONID;
  String? sECTIONNAME;

  Section({this.id, this.sECTIONID, this.sECTIONNAME});

  Section.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    sECTIONID = json['SECTION_ID'];
    sECTIONNAME = json['SECTION_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['SECTION_ID'] = this.sECTIONID;
    data['SECTION_NAME'] = this.sECTIONNAME;
    return data;
  }
}
