class SetModel {
  final String? id;
  final String? name;
  final String? rpe;
  final String? reps;
  final String? kg;

  SetModel({
    this.id,
    this.name,
    this.rpe,
    this.reps,
    this.kg,
  });

  SetModel copyWith({
    String? id,
    String? name,
    String? rpe,
    String? reps,
    String? kg,
  }) {
    return SetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rpe: rpe ?? this.rpe,
      reps: reps ?? this.reps,
      kg: kg ?? this.kg,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rpe': rpe,
      'reps': reps,
      'kg': kg,
    };
  }

  factory SetModel.fromJson(Map<String, dynamic> json) {
    return SetModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      rpe: json['rpe'] as String?,
      reps: json['reps'] as String?,
      kg: json['kg'] as String?,
    );
  }

  @override
  String toString() =>
      "SetModel(id: $id, name: $name, rpe: $rpe, reps: $reps, kg: $kg)";

  @override
  int get hashCode => Object.hash(id, name, rpe, reps, kg);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          rpe == other.rpe &&
          reps == other.reps &&
          kg == other.kg;
}