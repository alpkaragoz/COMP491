import 'package:coach_connect/utils/constants.dart';

class UserAccount {
  String id;
  String name;
  String email;
  int age;
  AccountType accountType;
  String username;
  String coachId; // Store UID of coach
  List<String> clientIds; //Store UID's of clients
  List<String> workoutIds; //Store UID's of workouts

  UserAccount(this.id, this.name, this.email, this.age, this.accountType, this.username,
      this.coachId, this.clientIds, this.workoutIds);

  // Convert a User instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'accountType': accountType.name,
      'username': username,
      'coachId': coachId,
      'clientIds': clientIds,
      'workoutIds': workoutIds,
    };
  }

// Helper method to parse account type string to AccountType enum
  static AccountType _accountTypeFromString(String accountTypeString) {
    return AccountType.values.firstWhere(
      (type) => type.name == accountTypeString,
      orElse: () => AccountType.client, // Default value if not found
    );
  }

// Convert a Map into a User instance
  static UserAccount fromJson(Map<String, dynamic> json) {
    return UserAccount(
      json['id'] ?? '',
      json['name'] ?? '',
      json['email'] ?? '',
      json['age'] ?? 0,
      _accountTypeFromString(
          json['accountType'] ?? 'client'), // Convert string to enum
      json['username'] ?? '',
      json['coachId'] ?? '',
      List<String>.from(json['clientIds'] ?? []),
      List<String>.from(json['workoutIds'] ?? []),
    );
  }
}
