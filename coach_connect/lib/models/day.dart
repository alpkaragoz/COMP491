import 'exercise.dart';

class DayModel {
  String? id;
  String? name;

  DayModel({
    this.id,
    this.name,
  });

  DayModel copyWith({
    String? id,
    String? name,
  }) {
    return DayModel(
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

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  @override
  String toString() => "dayModel(id: $id,name: $name)";

  @override
  int get hashCode => Object.hash(id, name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;
}