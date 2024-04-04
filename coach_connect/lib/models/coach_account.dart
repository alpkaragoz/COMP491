class CoachAccountModel {
  String id;
  String name;
  String email;
  int age;
  String accountType;
  //List<String> clients;
  List<String> workouts;  //Store UID's of workouts

  CoachAccountModel(this.id, this.name, this.email, this.age, this.accountType,/* this.clients, */ this.workouts);

  // Convert a User instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'accountType': accountType,
      //'clients': clients,
      'workouts': workouts,
    };
  }
  
    // Convert a Map into a User instance
  static CoachAccountModel fromJson(Map<String, dynamic> json) {
    return CoachAccountModel(
      json['id'],
      json['name'],
      json['email'],
      json['age'],
      json['accountType'],
      //List<String>.from(json['clients']),
      List<String>.from(json['workouts']),
    );
  }
}
