class Company {
  final int companyID;
  final String company;

  Company({
    required this.companyID,
    required this.company,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyID: json['CompanyID'],
      company: json['Company'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'CompanyID': companyID,
      'Company': company,
    };
  }
}
