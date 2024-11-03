class SmsDispacthDetails {
  int? sampleDispatchHeaderID;
  int? sampleDevelopmentPlanningDetailsID;
  int? sectionID;
  String? sectionName;
  String? toSection;
  int? workOrderID;
  int? jobID;
  int? sampleDispatchDetailID;
  bool? bIsForDabDipDispatch;
  double? decSampleDispatchQty;
  int? dispatchMeasureUnitID;
  String? sectionDispatchOn;
  double? totalItemQty;
  bool? isToBeInvoice;
  bool? bIsSectionDispatchCompleted;
  bool? bIsEnterTechnicalDone;
  String? acptDispOn;
  String? dispatchOn;
  int? empID;

  SmsDispacthDetails(
      {this.sampleDispatchHeaderID,
      this.sampleDevelopmentPlanningDetailsID,
      this.sectionID,
      this.sectionName,
      this.toSection,
      this.workOrderID,
      this.jobID,
      this.sampleDispatchDetailID,
      this.bIsForDabDipDispatch,
      this.decSampleDispatchQty,
      this.dispatchMeasureUnitID,
      this.sectionDispatchOn,
      this.totalItemQty,
      this.isToBeInvoice,
      this.bIsSectionDispatchCompleted,
      this.bIsEnterTechnicalDone,
      this.acptDispOn,
      this.dispatchOn,
      this.empID});

  SmsDispacthDetails.fromJson(Map<String, dynamic> json) {
    sampleDispatchHeaderID = json['SampleDispatchHeaderID'];
    sampleDevelopmentPlanningDetailsID =
        json['SampleDevelopmentPlanningDetailsID'];
    sectionID = json['SectionID'];
    sectionName = json['SectionName'];
    toSection = json['ToSection'];
    workOrderID = json['WorkOrderID'];
    jobID = json['JobID'];
    sampleDispatchDetailID = json['SampleDispatchDetailID'];
    bIsForDabDipDispatch = json['bIsForDabDipDispatch'];
    decSampleDispatchQty = json['decSampleDispatchQty'];
    dispatchMeasureUnitID = json['DispatchMeasureUnitID'];
    sectionDispatchOn = json['SectionDispatchOn'];
    totalItemQty = json['TotalItemQty'];
    isToBeInvoice = json['IsToBeInvoice'];
    bIsSectionDispatchCompleted = json['bIsSectionDispatchCompleted'];
    bIsEnterTechnicalDone = json['bIsEnterTechnicalDone'];
    acptDispOn = json['AcptDispOn'];
    dispatchOn = json['DispatchOn'];
    empID = json['EmpID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SampleDispatchHeaderID'] = this.sampleDispatchHeaderID;
    data['SampleDevelopmentPlanningDetailsID'] =
        this.sampleDevelopmentPlanningDetailsID;
    data['SectionID'] = this.sectionID;
    data['SectionName'] = this.sectionName;
    data['ToSection'] = this.toSection;
    data['WorkOrderID'] = this.workOrderID;
    data['JobID'] = this.jobID;
    data['SampleDispatchDetailID'] = this.sampleDispatchDetailID;
    data['bIsForDabDipDispatch'] = this.bIsForDabDipDispatch;
    data['decSampleDispatchQty'] = this.decSampleDispatchQty;
    data['DispatchMeasureUnitID'] = this.dispatchMeasureUnitID;
    data['SectionDispatchOn'] = this.sectionDispatchOn;
    data['TotalItemQty'] = this.totalItemQty;
    data['IsToBeInvoice'] = this.isToBeInvoice;
    data['bIsSectionDispatchCompleted'] = this.bIsSectionDispatchCompleted;
    data['bIsEnterTechnicalDone'] = this.bIsEnterTechnicalDone;
    data['AcptDispOn'] = this.acptDispOn;
    data['DispatchOn'] = this.dispatchOn;
    data['EmpID'] = this.empID;
    return data;
  }
}
