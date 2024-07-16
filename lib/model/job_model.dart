import 'package:intl/intl.dart';

class Job {
  String id;
  String name;
  String noOfPairs;
  String weight;
  String damage;
  String status;
  DateTime? datedispatched;
  DateTime? datereceived;
  bool isChecked;
  Job(
      {required this.id,
      required this.name,
      required this.noOfPairs,
      required this.weight,
      required this.damage,
        this.status = 'pending',
        this.datedispatched,
        this.datereceived,
      required this.isChecked});

  factory Job.fromJson(Map<String, dynamic> data) {
    return Job(
        id: data['dept_id'],
        name: data['dept_name'],
        noOfPairs: data['no_of_pairs'] ?? '0',
        weight: data['weight'] ?? '0',
        damage: data['pairs_damage'] ?? '0',
        status: data['status'] ?? 'pending',
        isChecked: data['isChecked'] ?? false,
      datedispatched: data['datedispatched'] != null
          ? DateTime.parse(data['datedispatched'])
          : null,
      datereceived: data['datereceived'] != null
          ? DateTime.parse(data['datereceived'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'no_of_pairs': noOfPairs,
      'weight': weight,
      'damage': damage,
      'status': status,
      'datedispatched': datedispatched != null
          ? DateFormat('yyyy-MM-dd').format(datedispatched!)
          : null,
      'datereceived': datereceived != null
          ? DateFormat('yyyy-MM-dd').format(datereceived!)
          : null,
    };
  }

  Job copyWith(
      {String? id,
      String? name,
      String? noOfPairs,
      String? weight,
      String? damage,
        String? status,
        DateTime? datedispatched,
        DateTime? datereceived,
      bool? isChecked}) {
    return Job(
        id: id ?? this.id,
        name: name ?? this.name,
        noOfPairs: noOfPairs ?? this.noOfPairs,
        weight: weight ?? this.weight,
        damage: damage ?? this.damage,
        status: status ?? this.status,
        datedispatched: datedispatched ?? this.datedispatched,
        datereceived: datereceived ?? this.datereceived,
        isChecked: isChecked ?? this.isChecked);
  }
}
