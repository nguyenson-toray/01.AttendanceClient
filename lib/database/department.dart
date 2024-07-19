// ignore_for_file: public_member_api_docs, sort_constructors_first
class Department {
  List<String>? operationManagement;
  List<String>? production;
  List<String>? purchase;
  List<String>? qA;
  List<String>? warehouse;
  List<String>? factoryManager;

  Department(
      {this.operationManagement,
      this.production,
      this.purchase,
      this.qA,
      this.warehouse,
      this.factoryManager});

  Department.fromJson(Map<String, dynamic> json) {
    operationManagement = json['Operation Management'].cast<String>();
    production = json['Production'].cast<String>();
    purchase = json['Purchase'].cast<String>();
    qA = json['QA'].cast<String>();
    warehouse = json['Warehouse'].cast<String>();
    factoryManager = json['Factory Manager'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Operation Management'] = operationManagement;
    data['Production'] = production;
    data['Purchase'] = purchase;
    data['QA'] = qA;
    data['Warehouse'] = warehouse;
    data['Factory Manager'] = factoryManager;
    return data;
  }

  @override
  String toString() {
    return 'Department(operationManagement: $operationManagement, production: $production, purchase: $purchase, qA: $qA, warehouse: $warehouse, factoryManager: $factoryManager)';
  }
}
