class Round {
  int total;
  int points;
  int time;
  double utilization;
  DateTime moment;
  bool withTime;

  Round({
    required this.total,
    required this.points,
    required this.time,
    required this.utilization,
    required this.moment,
    required this.withTime,
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
  int getTime(){
    return time;
  }
  void setTime(int time){
    this.time=time;
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
  bool getWithTime(){
    return withTime;
  }
  void setWithTime(bool withTime){
    this.withTime=withTime;
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'total': total,
      'time': time,
      'utilization': utilization,
      'moment': moment.toIso8601String(),
      'withTime': withTime,
    };
  }

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      points: json['points'],
      total: json['total'],
      time: json['time'],
      utilization: json['utilization'],
      moment: DateTime.parse(json['moment']),
      withTime: json['withTime'],
    );
  }
}