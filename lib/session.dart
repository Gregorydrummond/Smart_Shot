class Session {
  int totalShots;
  double shotPercentage;
  List<int> shots;
  DateTime date;

  Session(this.totalShots, this.shotPercentage, this.shots, this.date);

  void shotTaken(int shot) {
    shots.add(shot);
    totalShots++;
  }
}
