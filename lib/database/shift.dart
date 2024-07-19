// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Shift {
  String shift;
  String begin;
  String end;
  int restHour;
  Shift({
    required this.shift,
    required this.begin,
    required this.end,
    required this.restHour,
  });

  Shift copyWith({
    String? shift,
    String? begin,
    String? end,
    int? restHour,
  }) {
    return Shift(
      shift: shift ?? this.shift,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      restHour: restHour ?? this.restHour,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shift': shift,
      'begin': begin,
      'end': end,
      'restHour': restHour,
    };
  }

  factory Shift.fromMap(Map<String, dynamic> map) {
    return Shift(
      shift: map['shift'] as String,
      begin: map['begin'] as String,
      end: map['end'] as String,
      restHour: map['restHour'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Shift.fromJson(String source) =>
      Shift.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Shift(shift: $shift, begin: $begin, end: $end, restHour: $restHour)';
  }

  @override
  bool operator ==(covariant Shift other) {
    if (identical(this, other)) return true;

    return other.shift == shift &&
        other.begin == begin &&
        other.end == end &&
        other.restHour == restHour;
  }

  @override
  int get hashCode {
    return shift.hashCode ^ begin.hashCode ^ end.hashCode ^ restHour.hashCode;
  }
}
