// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of '_employeeBasic.dart';

// // **************************************************************************
// // RealmObjectGenerator
// // **************************************************************************

// // ignore_for_file: type=lint
// class EmployeeBasic extends _EmployeeBasic
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   EmployeeBasic(
//     ObjectId? id, {
//     String? empId = 'TIQN-',
//     int? attFingerId = 0,
//     String? name = "Nguyễn Văn A",
//     String? department = 'Production',
//     String? section = 'Production',
//     String? group = 'Sewing',
//     String? lineTeam,
//     String? gender = 'Female',
//     String? positionE = 'Sewing Worker',
//     String? level = 'Worker',
//     String? directIndirect = 'Direct',
//     String? sewingNonSewing = 'Sewing',
//     String? supporting = '',
//     DateTime? dob,
//     DateTime? joiningDate,
//     String? workStatus = 'Working ',
//     DateTime? resignDate,
//     DateTime? maternityComebackDate,
//     String? shift = "Day Shift",
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<EmployeeBasic>({
//         'empId': 'TIQN-',
//         'attFingerId': 0,
//         'name': "Nguyễn Văn A",
//         'department': 'Production',
//         'section': 'Production',
//         'group': 'Sewing',
//         'gender': 'Female',
//         'positionE': 'Sewing Worker',
//         'level': 'Worker',
//         'directIndirect': 'Direct',
//         'sewingNonSewing': 'Sewing',
//         'supporting': '',
//         'workStatus': 'Working ',
//         'shift': "Day Shift",
//       });
//     }
//     RealmObjectBase.set(this, '_id', id);
//     RealmObjectBase.set(this, 'empId', empId);
//     RealmObjectBase.set(this, 'attFingerId', attFingerId);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'department', department);
//     RealmObjectBase.set(this, 'section', section);
//     RealmObjectBase.set(this, 'group', group);
//     RealmObjectBase.set(this, 'lineTeam', lineTeam);
//     RealmObjectBase.set(this, 'gender', gender);
//     RealmObjectBase.set(this, 'positionE', positionE);
//     RealmObjectBase.set(this, 'level', level);
//     RealmObjectBase.set(this, 'directIndirect', directIndirect);
//     RealmObjectBase.set(this, 'sewingNonSewing', sewingNonSewing);
//     RealmObjectBase.set(this, 'supporting', supporting);
//     RealmObjectBase.set(this, 'dob', dob);
//     RealmObjectBase.set(this, 'joiningDate', joiningDate);
//     RealmObjectBase.set(this, 'workStatus', workStatus);
//     RealmObjectBase.set(this, 'resignDate', resignDate);
//     RealmObjectBase.set(this, 'maternityComebackDate', maternityComebackDate);
//     RealmObjectBase.set(this, 'shift', shift);
//   }

//   EmployeeBasic._();

//   @override
//   ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
//   @override
//   set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get empId => RealmObjectBase.get<String>(this, 'empId') as String?;
//   @override
//   set empId(String? value) => RealmObjectBase.set(this, 'empId', value);

//   @override
//   int? get attFingerId => RealmObjectBase.get<int>(this, 'attFingerId') as int?;
//   @override
//   set attFingerId(int? value) =>
//       RealmObjectBase.set(this, 'attFingerId', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   String? get department =>
//       RealmObjectBase.get<String>(this, 'department') as String?;
//   @override
//   set department(String? value) =>
//       RealmObjectBase.set(this, 'department', value);

//   @override
//   String? get section =>
//       RealmObjectBase.get<String>(this, 'section') as String?;
//   @override
//   set section(String? value) => RealmObjectBase.set(this, 'section', value);

//   @override
//   String? get group => RealmObjectBase.get<String>(this, 'group') as String?;
//   @override
//   set group(String? value) => RealmObjectBase.set(this, 'group', value);

//   @override
//   String? get lineTeam =>
//       RealmObjectBase.get<String>(this, 'lineTeam') as String?;
//   @override
//   set lineTeam(String? value) => RealmObjectBase.set(this, 'lineTeam', value);

//   @override
//   String? get gender => RealmObjectBase.get<String>(this, 'gender') as String?;
//   @override
//   set gender(String? value) => RealmObjectBase.set(this, 'gender', value);

//   @override
//   String? get positionE =>
//       RealmObjectBase.get<String>(this, 'positionE') as String?;
//   @override
//   set positionE(String? value) => RealmObjectBase.set(this, 'positionE', value);

//   @override
//   String? get level => RealmObjectBase.get<String>(this, 'level') as String?;
//   @override
//   set level(String? value) => RealmObjectBase.set(this, 'level', value);

//   @override
//   String? get directIndirect =>
//       RealmObjectBase.get<String>(this, 'directIndirect') as String?;
//   @override
//   set directIndirect(String? value) =>
//       RealmObjectBase.set(this, 'directIndirect', value);

//   @override
//   String? get sewingNonSewing =>
//       RealmObjectBase.get<String>(this, 'sewingNonSewing') as String?;
//   @override
//   set sewingNonSewing(String? value) =>
//       RealmObjectBase.set(this, 'sewingNonSewing', value);

//   @override
//   String? get supporting =>
//       RealmObjectBase.get<String>(this, 'supporting') as String?;
//   @override
//   set supporting(String? value) =>
//       RealmObjectBase.set(this, 'supporting', value);

//   @override
//   DateTime? get dob => RealmObjectBase.get<DateTime>(this, 'dob') as DateTime?;
//   @override
//   set dob(DateTime? value) => RealmObjectBase.set(this, 'dob', value);

//   @override
//   DateTime? get joiningDate =>
//       RealmObjectBase.get<DateTime>(this, 'joiningDate') as DateTime?;
//   @override
//   set joiningDate(DateTime? value) =>
//       RealmObjectBase.set(this, 'joiningDate', value);

//   @override
//   String? get workStatus =>
//       RealmObjectBase.get<String>(this, 'workStatus') as String?;
//   @override
//   set workStatus(String? value) =>
//       RealmObjectBase.set(this, 'workStatus', value);

//   @override
//   DateTime? get resignDate =>
//       RealmObjectBase.get<DateTime>(this, 'resignDate') as DateTime?;
//   @override
//   set resignDate(DateTime? value) =>
//       RealmObjectBase.set(this, 'resignDate', value);

//   @override
//   DateTime? get maternityComebackDate =>
//       RealmObjectBase.get<DateTime>(this, 'maternityComebackDate') as DateTime?;
//   @override
//   set maternityComebackDate(DateTime? value) =>
//       RealmObjectBase.set(this, 'maternityComebackDate', value);

//   @override
//   String? get shift => RealmObjectBase.get<String>(this, 'shift') as String?;
//   @override
//   set shift(String? value) => RealmObjectBase.set(this, 'shift', value);

//   @override
//   Stream<RealmObjectChanges<EmployeeBasic>> get changes =>
//       RealmObjectBase.getChanges<EmployeeBasic>(this);

//   @override
//   EmployeeBasic freeze() => RealmObjectBase.freezeObject<EmployeeBasic>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       '_id': id.toEJson(),
//       'empId': empId.toEJson(),
//       'attFingerId': attFingerId.toEJson(),
//       'name': name.toEJson(),
//       'department': department.toEJson(),
//       'section': section.toEJson(),
//       'group': group.toEJson(),
//       'lineTeam': lineTeam.toEJson(),
//       'gender': gender.toEJson(),
//       'positionE': positionE.toEJson(),
//       'level': level.toEJson(),
//       'directIndirect': directIndirect.toEJson(),
//       'sewingNonSewing': sewingNonSewing.toEJson(),
//       'supporting': supporting.toEJson(),
//       'dob': dob.toEJson(),
//       'joiningDate': joiningDate.toEJson(),
//       'workStatus': workStatus.toEJson(),
//       'resignDate': resignDate.toEJson(),
//       'maternityComebackDate': maternityComebackDate.toEJson(),
//       'shift': shift.toEJson(),
//     };
//   }

//   static EJsonValue _toEJson(EmployeeBasic value) => value.toEJson();
//   static EmployeeBasic _fromEJson(EJsonValue ejson) {
//     return switch (ejson) {
//       {
//         '_id': EJsonValue id,
//         'empId': EJsonValue empId,
//         'attFingerId': EJsonValue attFingerId,
//         'name': EJsonValue name,
//         'department': EJsonValue department,
//         'section': EJsonValue section,
//         'group': EJsonValue group,
//         'lineTeam': EJsonValue lineTeam,
//         'gender': EJsonValue gender,
//         'positionE': EJsonValue positionE,
//         'level': EJsonValue level,
//         'directIndirect': EJsonValue directIndirect,
//         'sewingNonSewing': EJsonValue sewingNonSewing,
//         'supporting': EJsonValue supporting,
//         'dob': EJsonValue dob,
//         'joiningDate': EJsonValue joiningDate,
//         'workStatus': EJsonValue workStatus,
//         'resignDate': EJsonValue resignDate,
//         'maternityComebackDate': EJsonValue maternityComebackDate,
//         'shift': EJsonValue shift,
//       } =>
//         EmployeeBasic(
//           fromEJson(id),
//           empId: fromEJson(empId),
//           attFingerId: fromEJson(attFingerId),
//           name: fromEJson(name),
//           department: fromEJson(department),
//           section: fromEJson(section),
//           group: fromEJson(group),
//           lineTeam: fromEJson(lineTeam),
//           gender: fromEJson(gender),
//           positionE: fromEJson(positionE),
//           level: fromEJson(level),
//           directIndirect: fromEJson(directIndirect),
//           sewingNonSewing: fromEJson(sewingNonSewing),
//           supporting: fromEJson(supporting),
//           dob: fromEJson(dob),
//           joiningDate: fromEJson(joiningDate),
//           workStatus: fromEJson(workStatus),
//           resignDate: fromEJson(resignDate),
//           maternityComebackDate: fromEJson(maternityComebackDate),
//           shift: fromEJson(shift),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(EmployeeBasic._);
//     register(_toEJson, _fromEJson);
//     return SchemaObject(
//         ObjectType.realmObject, EmployeeBasic, 'EmployeeBasic', [
//       SchemaProperty('id', RealmPropertyType.objectid,
//           mapTo: '_id', optional: true, primaryKey: true),
//       SchemaProperty('empId', RealmPropertyType.string, optional: true),
//       SchemaProperty('attFingerId', RealmPropertyType.int, optional: true),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('department', RealmPropertyType.string, optional: true),
//       SchemaProperty('section', RealmPropertyType.string, optional: true),
//       SchemaProperty('group', RealmPropertyType.string, optional: true),
//       SchemaProperty('lineTeam', RealmPropertyType.string, optional: true),
//       SchemaProperty('gender', RealmPropertyType.string, optional: true),
//       SchemaProperty('positionE', RealmPropertyType.string, optional: true),
//       SchemaProperty('level', RealmPropertyType.string, optional: true),
//       SchemaProperty('directIndirect', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('sewingNonSewing', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('supporting', RealmPropertyType.string, optional: true),
//       SchemaProperty('dob', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('joiningDate', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('workStatus', RealmPropertyType.string, optional: true),
//       SchemaProperty('resignDate', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('maternityComebackDate', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('shift', RealmPropertyType.string, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }
