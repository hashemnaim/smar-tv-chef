class RingerModel {
  bool enable;
  String dateTime;

  RingerModel({this.enable, this.dateTime});

  @override
  String toString() {
    return 'enable: $enable, dateTime: $dateTime';
  }
}
