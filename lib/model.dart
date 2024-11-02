class TaskRecord {
  final DateTime date;
  final String taskName;
  final bool isCompleted;

  TaskRecord({required this.date, required this.taskName, required this.isCompleted});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'taskName': taskName,
        'isCompleted': isCompleted,
      };

  factory TaskRecord.fromJson(Map<String, dynamic> json) {
    return TaskRecord(
      date: DateTime.parse(json['date']),
      taskName: json['taskName'],
      isCompleted: json['isCompleted'],
    );
  }
}
