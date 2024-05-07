class ScheduleEntry {
  final String title;
  final DateTime dateTime;
  final String description;

  ScheduleEntry({required this.title, required this.dateTime, this.description="None"});
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
    };
  }
}
