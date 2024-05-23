class WorkoutModel {
  final String? id;
  final String? name;
  final String? coachId;
  final String? clientId;

  WorkoutModel({
    this.id,
    this.name,
    this.coachId,
    this.clientId,
  });

  WorkoutModel copyWith({
    String? id,
    String? name,
    String? coachId,
    String? clientId,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      name: name ?? this.name,
      coachId: coachId ?? this.coachId,
      clientId: clientId ?? this.clientId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coachId': coachId,
      'clientId': clientId,
    };
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      coachId: json['coachId'] as String?,
      clientId: json['clientId'] as String?,
    );
  }

  @override
  String toString() =>
      "WorkoutModel(id: $id,name: $name,coachId: $coachId,clientId: $clientId)";

  @override
  int get hashCode => Object.hash(id, name, coachId, clientId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          coachId == other.coachId &&
          clientId == other.clientId;
}
