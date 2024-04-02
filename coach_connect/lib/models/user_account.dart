class UserAccount {
  String id;
  String name;
  String email;
  int age;
  String accountType;
  List<String> coaches; //Store UID's of coaches
  List<String> workouts;  //Store UID's of workouts

  UserAccount(this.id, this.name, this.email, this.age, this.accountType, this.coaches,
      this.workouts);

  // Convert a User instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'accountType': accountType,
      'coaches': coaches,
      'workouts': workouts,
    };
  }
}
