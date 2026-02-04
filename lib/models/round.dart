class Round {
  int total;
  int points;
  double utilization;
  DateTime moment;

  Round({
    required this.total,
    required this.points,
    required this.utilization,
    required this.moment,
  });

  int getTotal(){
    return total;
  }
  void setTotal(int total){
    this.total=total;
  }
  int getPoints(){
    return points;
  }
  void setPoints(int points){
    this.points=points;
  }
  double getUtilization(){
    return utilization;
  }
  void setUtilization(double utilization){
    this.utilization=utilization;
  }
  DateTime getMoment(){
    return moment;
  }
  void setMoment(DateTime moment){
    this.moment=moment;
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'total': total,
      'utilization': utilization,
      'moment': moment.toIso8601String(),
    };
  }

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      points: json['points'],
      total: json['total'],
      utilization: json['utilization'],
      moment: DateTime.parse(json['moment']),
    );
  }
}