import 'workout.dart';

class User {
  String id;
  String name;
  String email;
  int age;
  String accountType;
  List<User> coaches;  //Store the id's of the coaches
  List<Workout> workouts;

  User(this.id, this.name, this.email, this.age, this.accountType, this.coaches, this.workouts);
}