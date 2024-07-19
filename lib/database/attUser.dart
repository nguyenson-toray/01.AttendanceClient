class _AttUser {
  late int? attFingerId;
  late String? employeeId;
  late String? name;
  get getAttFingerId => attFingerId;

  set setAttFingerId(attFingerId) => this.attFingerId = attFingerId;

  get getEmployeeId => employeeId;

  set setEmployeeId(employeeId) => this.employeeId = employeeId;

  get getName => name;

  set setName(name) => this.name = name;

  @override
  String toString() {
    return '_AttUser(attFingerId: $attFingerId, employeeId: $employeeId, name: $name)';
  }
}
