class BoxModel {
  int intBoxID;
  int intBoxNo;
  double decBoxWeight;
  int intNoOfPartition;
  String? barcode; // Nullable barcode field
  int intMCPlanID;
  int intMCID;
  int? companyID;
  int? toSection;
  int? sectionID;

  // Constructor with required and optional fields
  BoxModel(
      {required this.intBoxID,
      required this.intBoxNo,
      required this.decBoxWeight,
      required this.intNoOfPartition,
      this.barcode, // Nullable field
      required this.intMCPlanID,
      required this.intMCID,
      this.companyID,
      this.toSection,
      this.sectionID});

  // Factory constructor to handle null and type conversion
  factory BoxModel.fromJson(Map<String, dynamic> json) {
    return BoxModel(
      intBoxID: json['intBoxID'] != null
          ? json['intBoxID'] as int
          : 0, // Handle null or missing values
      intBoxNo: json['intBoxNo'] != null ? json['intBoxNo'] as int : 0,
      decBoxWeight: json['DecBoxWeight'] != null
          ? (json['DecBoxWeight'] as num).toDouble()
          : 0.0, // Ensure double type
      intNoOfPartition: json['IntNoOfPartition'] != null
          ? json['IntNoOfPartition'] as int
          : 0,
      barcode: json['Barcode'], // Nullable, can be null directly
      intMCPlanID: json['IntMCPlanID'] != null ? json['IntMCPlanID'] as int : 0,
      intMCID: json['IntMCID'] != null ? json['IntMCID'] as int : 0,
      companyID: json['CompanyID'] != null ? json['CompanyID'] as int : 0,
      toSection: json['ToSection'] != null ? json['ToSection'] as int : 0,
      sectionID: json['sectionID'] != null ? json['sectionID'] as int : 0,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'intBoxID': intBoxID,
      'intBoxNo': intBoxNo,
      'DecBoxWeight': decBoxWeight,
      'IntNoOfPartition': intNoOfPartition,
      'Barcode': barcode ?? '',
      'IntMCPlanID': intMCPlanID,
      'IntMCID': intMCID,
      'CompanyID': companyID,
      'ToSection': toSection,
      'sectionID': sectionID
    };
  }
}
