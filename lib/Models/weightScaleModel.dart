class WeightMachine {
  final int weightMachineNo;
  final double weightValue;

  WeightMachine({
    required this.weightMachineNo,
    required this.weightValue,
  });

  factory WeightMachine.fromJson(Map<String, dynamic> json) {
    return WeightMachine(
      weightMachineNo: json['WeightMachineNo'],
      weightValue: json['WeightValue'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'WeightMachineNo': weightMachineNo,
      'WeightValue': weightValue,
    };
  }
}
