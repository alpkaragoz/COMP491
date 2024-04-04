class ClientAccountModel {
  String id;
  String name;
  String email;
  int age;
  String accountType;
  String? coach; //Store UID's of coaches
  List<String> workouts;  //Store UID's of workouts

  ClientAccountModel(this.id, this.name, this.email, this.age, this.accountType, this.coach,this.workouts);

  // Convert a User instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'accountType': accountType,
      'coach': coach,
      'workouts': workouts,
    };
  }
  
    // Convert a Map into a User instance
  static ClientAccountModel fromJson(Map<String, dynamic> json) {
    return ClientAccountModel(
      json['id'],
      json['name'],
      json['email'],
      json['age'],
      json['accountType'],
      json['coach'],
      List<String>.from(json['workouts']),
    );
  }
}
