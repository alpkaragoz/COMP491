class DayModel {
  String? id;
  String name;
  bool completed; // Add the completed flag

  DayModel({
    this.id,
    required this.name,
    this.completed = false, // Default completed to false
  });

  DayModel copyWith({
    String? id,
    String? name,
    bool? completed,
  }) {
    return DayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'completed': completed, // Include completed in the JSON
    };
  }

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      completed: json['completed'] as bool? ?? false, // Assume the JSON has a non-null name and handle completed
    );
  }

  @override
  String toString() => "DayModel(id: $id, name: $name, completed: $completed)";

  @override
  int get hashCode => Object.hash(id, name, completed);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          completed == other.completed;
}
