class sectionwiseuser {
  String? id;
  int? empID;
  int? sectionID;
  String? sectionName;
  String? acptDispOn;
  String? dispatchOn;

  sectionwiseuser(
      {this.id,
      this.empID,
      this.sectionID,
      this.sectionName,
      this.acptDispOn,
      this.dispatchOn});

  sectionwiseuser.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    empID = json['EmpID'];
    sectionID = json['SectionID'];
    sectionName = json['SectionName'];
    acptDispOn = json['AcptDispOn'];
    dispatchOn = json['DispatchOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['EmpID'] = this.empID;
    data['SectionID'] = this.sectionID;
    data['SectionName'] = this.sectionName;
    data['AcptDispOn'] = this.acptDispOn;
    data['DispatchOn'] = this.dispatchOn;
    return data;
  }
}
