class ProductionModel {
  int intJobID;
  String? vcJobNo;
  String? machineBarcode;
  int intMCPlanID;
  double decAllocQty;
  double decOutPut;
  double decWPM;
  int intNoofTapes;
  int intMCCounterCount;
  double decMCCounterRate;
  int intMCID;
  String vcMCCODE;
  int companyID;
  bool isSelected;
  int? intBoxID;
  double? decBoxWeight;
  double? netWeight;
  double? netKg;
  double? netYard;
  String? Barcode;
  int? intCompanyID;

  ProductionModel(
      {required this.intJobID,
      this.vcJobNo,
      this.machineBarcode,
      required this.intMCPlanID,
      required this.decAllocQty,
      required this.decOutPut,
      required this.decWPM,
      required this.intNoofTapes,
      required this.intMCCounterCount,
      required this.decMCCounterRate,
      required this.intMCID,
      required this.vcMCCODE,
      required this.companyID,
      this.intBoxID,
      this.decBoxWeight,
      this.netWeight,
      this.netKg,
      this.netYard,
      this.Barcode,
      this.isSelected = false,
      this.intCompanyID});

  factory ProductionModel.fromJson(Map<String, dynamic> json) {
    return ProductionModel(
      intJobID: json['intJobID'] != null ? json['intJobID'] as int : 0,
      vcJobNo: json['vcJobNo'] as String?,
      machineBarcode: json['MachineBarcode'] as String?,
      intMCPlanID: json['intMCPlanID'] != null ? json['intMCPlanID'] as int : 0,
      decAllocQty:
          (json['decAllocQty'] != null ? json['decAllocQty'] as num : 0)
              .toDouble(),
      decOutPut:
          (json['decOutPut'] != null ? json['decOutPut'] as num : 0).toDouble(),
      decWPM: (json['decWPM'] != null ? json['decWPM'] as num : 0).toDouble(),
      intNoofTapes:
          json['intNoofTapes'] != null ? json['intNoofTapes'] as int : 0,
      intMCCounterCount: json['intMCCounterCount'] != null
          ? json['intMCCounterCount'] as int
          : 0,
      decMCCounterRate: (json['decMCCounterRate'] != null
              ? json['decMCCounterRate'] as num
              : 0)
          .toDouble(),
      intMCID: json['intMCID'] != null ? json['intMCID'] as int : 0,
      vcMCCODE: json['vcMCCODE'] ?? 'Unknown',
      companyID: json['CompanyID'] != null ? json['CompanyID'] as int : 0,
      intBoxID: json['intBoxID'] != null ? json['intBoxID'] as int : null,
      decBoxWeight:
          (json['decBoxWeight'] != null ? json['decBoxWeight'] as num : 0)
              .toDouble(),
      netWeight: json['netWeight'] != null
          ? (json['netWeight'] as num).toDouble()
          : null,
      netKg: json['netKg'] != null ? (json['netKg'] as num).toDouble() : null,
      netYard:
          json['netYard'] != null ? (json['netYard'] as num).toDouble() : null,
      Barcode: json['Barcode'] as String?,
      intCompanyID:
          json['intCompanyID'] != null ? json['intCompanyID'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intJobID': intJobID,
      'vcJobNo': vcJobNo,
      'MachineBarcode': machineBarcode,
      'intMCPlanID': intMCPlanID,
      'decAllocQty': decAllocQty,
      'decOutPut': decOutPut,
      'decWPM': decWPM,
      'intNoofTapes': intNoofTapes,
      'intMCCounterCount': intMCCounterCount,
      'decMCCounterRate': decMCCounterRate,
      'intMCID': intMCID,
      'vcMCCODE': vcMCCODE,
      'CompanyID': companyID,
      'intBoxID': intBoxID,
      'decBoxWeight': decBoxWeight,
      'netWeight': netWeight,
      'intCompanyID': intCompanyID
    };
  }
}
