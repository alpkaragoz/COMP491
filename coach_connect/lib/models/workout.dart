import 'session.dart';

class Workout {
  String id;
  String name;
  String coach; // Store coach UID.
  String client; // Store client UID;
  List<Session> sessions; // List of session objects.

  Workout(this.id, this.name, this.coach, this.client, this.sessions);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'coach': coach,
      'client': client,
      'sessions': sessions.map((session) => session.toMap()).toList(),
    };
  }

  static Workout fromJson(Map<String, dynamic> json) {
    var sessionList = json['sessions'] as List;
    List<Session> sessions = sessionList.map((sessionJson) => Session.fromJson(sessionJson)).toList();
    
    return Workout(
      json['id'],
      json['name'],
      json['coach'],
      json['client'],
      sessions,
    );
  }
}
