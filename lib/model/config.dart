// import 'dart:convert';
// import 'package:realm/realm.dart';

// // ignore_for_file: public_member_api_docs, sort_constructors_first
// @RealmModel()
// class _Config {
//   late String mainFuntion;
//   get getMainFuntion => this.mainFuntion;

//   set setMainFuntion(mainFuntion) => this.mainFuntion = mainFuntion;
//   _Config({
//     required this.mainFuntion,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'mainFuntion': mainFuntion,
//     };
//   }

//   factory _Config.fromMap(Map<String, dynamic> map) {
//     return _Config(
//       mainFuntion: map['mainFuntion'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory _Config.fromJson(String source) =>
//       _Config.fromMap(json.decode(source) as Map<String, dynamic>);
// }
