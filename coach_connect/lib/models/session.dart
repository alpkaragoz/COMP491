import 'move.dart';

class Session {
  String id;
  String weekNumber; // Number of the week. For example, Week 3.
  String dayNumber; // Number of the day. For example, Day 4.
  List<Move> moves; //Store list of move objects.
  bool isDone;

  Session(this.id, this.weekNumber, this.dayNumber, this.moves, this.isDone);

  // Convert a User instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weekNumber': weekNumber,
      'dayNumber': dayNumber,
      'moves': moves.map((e) => e.toMap()).toList(),
    };
  }
}