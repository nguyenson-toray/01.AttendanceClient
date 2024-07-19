import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class History {
  String pcName;
  DateTime time;
  String log;
  History({
    required this.pcName,
    required this.time,
    required this.log,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pcName': pcName,
      'time': time,
      'log': log,
    };
  }

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      pcName: map['pcName'] as String,
      time: map['time'],
      log: map['log'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory History.fromJson(String source) =>
      History.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PC name: $pcName, time: $time, log: $log)';
  }
}
