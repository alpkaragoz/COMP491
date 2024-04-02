import 'video.dart';

class Move {
  String id;
  String name;
  int setNumber;
  int repNumber;
  String coachNote;
  String clientNote;
  bool isDone;
  Video? video;

  Move(this.id, this.name, this.setNumber, this.repNumber, this.coachNote,
      this.clientNote, this.isDone, this.video);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'setNumber': setNumber,
      'repNumber': repNumber,
      'coachNote': coachNote,
      'clientNote': clientNote,
      'isDone': isDone,
      'video': video?.toMap(),
    };
  }

  static Move fromJson(Map<String, dynamic> json) {
    return Move(
      json['id'],
      json['name'],
      json['setNumber'],
      json['repNumber'],
      json['coachNote'],
      json['clientNote'],
      json['isDone'],
      json['video'] != null ? Video.fromJson(json['video']) : null,
    );
  }
}
