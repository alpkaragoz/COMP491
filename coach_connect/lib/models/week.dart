import 'move.dart';

class WeekModel {
  String? id;
  String? name;

  WeekModel({
    this.id,
    this.name,
  });

  WeekModel copyWith({
    String? id,
    String? name,
  }) {
    return WeekModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory WeekModel.fromJson(Map<String, dynamic> json) {
    return WeekModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  @override
  String toString() => "weekModel(id: $id,name: $name)";

  @override
  int get hashCode => Object.hash(id, name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;
}