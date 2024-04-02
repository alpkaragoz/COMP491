import 'move.dart';

class Session {
  String id;
  String weekNumber; // Number of the week. For example, Week 3.
  String dayNumber; // Number of the day. For example, Day 4.
  List<Move> moves; // Store list of move objects.
  bool isDone;

  Session(this.id, this.weekNumber, this.dayNumber, this.moves, this.isDone);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weekNumber': weekNumber,
      'dayNumber': dayNumber,
      'moves': moves.map((move) => move.toMap()).toList(),
      'isDone': isDone,
    };
  }

  static Session fromJson(Map<String, dynamic> json) {
    var movesList = json['moves'] as List;
    List<Move> moves = movesList.map((moveJson) => Move.fromJson(moveJson)).toList();
    
    return Session(
      json['id'],
      json['weekNumber'],
      json['dayNumber'],
      moves,
      json['isDone'],
    );
  }
}
