class RequestDetails {
  String? id;
  String? sampleDispatchCode;
  int? sampleDispatchHeaderID;
  int? sampleDevelopmentPlanningDetailsID;
  String? repCode;
  String? mktExName;
  String? requestedOn;
  String? sampleCode;
  int? sectionID;
  String? sectionName;
  int? workOrderID;
  String? itemBarcode;
  String? workOrderCode;
  int? jobID;
  int? sampleDispatchDetailID;
  String? itemDescription;
  bool? bIsForDabDipDispatch;
  double? decSampleDispatchQty;
  String? dispatchUnit;
  int? dispatchMeasureUnitID;
  String? sectionDispatchOn;
  double? totalItemQty;
  bool? isToBeInvoice;
  bool? bIsSectionDispatchCompleted;
  bool? bIsEnterTechnicalDone;
  String? customerName;
  int? empID;

  RequestDetails(
      {this.id,
      this.sampleDispatchCode,
      this.sampleDispatchHeaderID,
      this.sampleDevelopmentPlanningDetailsID,
      this.repCode,
      this.mktExName,
      this.requestedOn,
      this.sampleCode,
      this.sectionID,
      this.sectionName,
      this.workOrderID,
      this.itemBarcode,
      this.workOrderCode,
      this.jobID,
      this.sampleDispatchDetailID,
      this.itemDescription,
      this.bIsForDabDipDispatch,
      this.decSampleDispatchQty,
      this.dispatchUnit,
      this.dispatchMeasureUnitID,
      this.sectionDispatchOn,
      this.totalItemQty,
      this.isToBeInvoice,
      this.bIsSectionDispatchCompleted,
      this.bIsEnterTechnicalDone,
      this.customerName,
      this.empID});

  RequestDetails.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    sampleDispatchCode = json['SampleDispatchCode'];
    sampleDispatchHeaderID = json['SampleDispatchHeaderID'];
    sampleDevelopmentPlanningDetailsID =
        json['SampleDevelopmentPlanningDetailsID'];
    repCode = json['RepCode'];
    mktExName = json['MktExName'];
    requestedOn = json['RequestedOn'];
    sampleCode = json['SampleCode'];
    sectionID = json['SectionID'];
    sectionName = json['SectionName'];
    workOrderID = json['WorkOrderID'];
    itemBarcode = json['ItemBarcode'];
    workOrderCode = json['WorkOrderCode'];
    jobID = json['JobID'];
    sampleDispatchDetailID = json['SampleDispatchDetailID'];
    itemDescription = json['ItemDescription'];
    bIsForDabDipDispatch = json['bIsForDabDipDispatch'];
    decSampleDispatchQty = json['decSampleDispatchQty'];
    dispatchUnit = json['DispatchUnit'];
    dispatchMeasureUnitID = json['DispatchMeasureUnitID'];
    sectionDispatchOn = json['SectionDispatchOn'];
    totalItemQty = json['TotalItemQty'];
    isToBeInvoice = json['IsToBeInvoice'];
    bIsSectionDispatchCompleted = json['bIsSectionDispatchCompleted'];
    bIsEnterTechnicalDone = json['bIsEnterTechnicalDone'];
    customerName = json['CustomerName'];
    empID = json['EmpID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['SampleDispatchCode'] = this.sampleDispatchCode;
    data['SampleDispatchHeaderID'] = this.sampleDispatchHeaderID;
    data['SampleDevelopmentPlanningDetailsID'] =
        this.sampleDevelopmentPlanningDetailsID;
    data['RepCode'] = this.repCode;
    data['MktExName'] = this.mktExName;
    data['RequestedOn'] = this.requestedOn;
    data['SampleCode'] = this.sampleCode;
    data['SectionID'] = this.sectionID;
    data['SectionName'] = this.sectionName;
    data['WorkOrderID'] = this.workOrderID;
    data['ItemBarcode'] = this.itemBarcode;
    data['WorkOrderCode'] = this.workOrderCode;
    data['JobID'] = this.jobID;
    data['SampleDispatchDetailID'] = this.sampleDispatchDetailID;
    data['ItemDescription'] = this.itemDescription;
    data['bIsForDabDipDispatch'] = this.bIsForDabDipDispatch;
    data['decSampleDispatchQty'] = this.decSampleDispatchQty;
    data['DispatchUnit'] = this.dispatchUnit;
    data['DispatchMeasureUnitID'] = this.dispatchMeasureUnitID;
    data['SectionDispatchOn'] = this.sectionDispatchOn;
    data['TotalItemQty'] = this.totalItemQty;
    data['IsToBeInvoice'] = this.isToBeInvoice;
    data['bIsSectionDispatchCompleted'] = this.bIsSectionDispatchCompleted;
    data['bIsEnterTechnicalDone'] = this.bIsEnterTechnicalDone;
    data['CustomerName'] = this.customerName;
    data['EmpID'] = this.empID;
    return data;
  }
}
