class ExerciseModel {
  String? id;
  String? name;

  ExerciseModel({
    this.id,
    this.name,
  });

  ExerciseModel copyWith({
    String? id,
    String? name,
  }) {
    return ExerciseModel(
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

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  @override
  String toString() => "exerciseModel(id: $id,name: $name)";

  @override
  int get hashCode => Object.hash(id, name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;
}